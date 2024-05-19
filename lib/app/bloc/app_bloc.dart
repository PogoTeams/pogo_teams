import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'dart:convert';

import '../../modules/globals.dart';
import '../../modules/pogo_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required this.pogoRepository}) : super(AppInitial()) {
    on<PogoDataFetched>(_onPogoDataFetched);
  }

  final PogoRepository pogoRepository;

  Future _onPogoDataFetched(
      PogoDataFetched event, Emitter<AppState> emit) async {
    String loadMessagePrefix = ''; // For indicating testing

    String pathPrefix = '/';

    // TRUE FOR TESTING ONLY
    if (Globals.testing) {
      pathPrefix += 'test/';
      loadMessagePrefix = '[ TEST ]  ';
    }

    Box localSettings = await Hive.openBox('pogoSettings');

    final client = RetryClient(Client());

    try {
      // If an update is available
      // make an http request for the new data
      if (event.forceUpdate ||
          await _updateAvailable(localSettings, client, pathPrefix)) {
        // Retrieve gamemaster
        String response = await client.read(Uri.https(Globals.pogoBucketDomain,
            '${Globals.pogoDataSourcePath}${pathPrefix}pogo_data_source.json'));

        emit(
            AppLoading(message: '${loadMessagePrefix}Getting Pogo Updates...'));

        // If request was successful, load in the new gamemaster,
        final Map<String, dynamic> pogoDataSourceJson =
            Map<String, dynamic>.from(jsonDecode(response));

        emit(AppLoading(
            message: '${loadMessagePrefix}Syncing Rankings Data...'));

        final rankingsJson = await downloadRankings(
          client,
          pathPrefix,
          List<Map<String, dynamic>>.from(pogoDataSourceJson['cups']),
        );

        emit(AppLoading(message: '${loadMessagePrefix}Syncing Local Data...'));

        await pogoRepository.buildDataSourceFromJson(
          pogoDataSourceJson,
          rankingsJson,
        );
      }

      await pogoRepository.loadUserData();
    }

    // If HTTP request or json decoding fails
    catch (error) {
      emit(AppLoading(message: '${loadMessagePrefix}Update Failed...'));
      await Future.delayed(
          const Duration(seconds: Globals.minLoadDisplaySeconds));
    } finally {
      client.close();
      localSettings.close();
    }

    emit(AppLoaded());
  }

  static Future<bool> _updateAvailable(
      Box localSettings, Client client, String pathPrefix) async {
    bool updateAvailable = false;

    // Retrieve local timestamp
    final String timestampString =
        localSettings.get('timestamp') ?? Globals.earliestTimestamp;
    DateTime localTimeStamp = DateTime.parse(timestampString);

    // Retrieve server timestamp
    String response = await client.read(Uri.https(Globals.pogoBucketDomain,
        '${Globals.pogoDataSourcePath}${pathPrefix}timestamp.txt'));

    // If request is successful, compare timestamps to determine update
    final latestTimestamp = DateTime.tryParse(response);

    if (latestTimestamp != null &&
        !localTimeStamp.isAtSameMomentAs(latestTimestamp)) {
      updateAvailable = true;
      localTimeStamp = latestTimestamp;
    }

    // Store the timestamp in the local db
    await localSettings.put('timestamp', localTimeStamp.toString());

    return updateAvailable;
  }

  static Future<Map<String, dynamic>> downloadRankings(
    Client client,
    String pathPrefix,
    List<Map<String, dynamic>> cupsJsonList,
  ) async {
    Map<String, dynamic> rankingsJson = {};

    for (Map<String, dynamic> cupEntry in cupsJsonList) {
      if (cupEntry.containsKey('cupId')) {
        String cupId = cupEntry['cupId'];
        try {
          String response = await client.read(Uri.https(
              Globals.pogoBucketDomain,
              '${Globals.pogoDataSourcePath}${pathPrefix}rankings/$cupId.json'));
          rankingsJson[cupId] = jsonDecode(response);
        } catch (_) {}
      }
    }

    return rankingsJson;
  }
}
