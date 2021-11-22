// Flutter Imports
import 'dart:convert';

import 'package:flutter/material.dart';

// Package Imports
import 'package:web_socket_channel/web_socket_channel.dart';

// Local Imports
import '../data/pokemon/pokemon.dart';
import '../widgets/buttons/exit_button.dart';
import '../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
The Pokemon team info page. Various webscraped content is displayed here in a
vertically scrollable view.
-------------------------------------------------------------------------------
*/

class TeamInfo extends StatefulWidget {
  const TeamInfo({
    Key? key,
    required this.pokemonTeam,
  }) : super(key: key);

  final List<Pokemon> pokemonTeam;

  @override
  _TeamInfoState createState() => _TeamInfoState();
}

class _TeamInfoState extends State<TeamInfo> {
  // Connection to html_scraper service
  final _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080'),
      protocols: ['echo-protocol']);

  // For requesting html_scraper service
  final String baseUrl = 'https://pokemon.gameinfo.io/en/pokemon/';

  // Image scrape from GoHub
  final String imgBaseUrl = 'https://db.pokemongohub.net/images/official/full/';
  final String imgExt = '.webp';

  // To store the responses from the service
  late List<AsyncSnapshot> snapshots = List.generate(
      widget.pokemonTeam.length, (index) => const AsyncSnapshot.nothing());

  // List of scraped images for each pokemon in the team
  List<Image> images = [];

  // Used to place scraped text under the correct image
  late final List<int> pokemonDexIds =
      widget.pokemonTeam.map((pokemon) => pokemon.dex).toList();

  List<String> requests = [];
  int reqIndex = 0;

  @override
  void initState() {
    final pokemonTeam = widget.pokemonTeam;
    final int teamLength = pokemonTeam.length;
    for (int i = 0; i < teamLength; ++i) {
      images.add(Image.network(imgBaseUrl +
          (pokemonTeam[i].dex < 100 ? '0' : '') +
          pokemonTeam[i].dex.toString() +
          imgExt));

      requests.add('{"url" : "' +
          baseUrl +
          pokemonTeam[i].dex.toString() +
          '-' +
          pokemonTeam[i].speciesId.toString() +
          '"}');
    }

    _req();
    super.initState();
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  void _req() {
    if (reqIndex == widget.pokemonTeam.length) return;
    _channel.sink.add(requests[reqIndex]);
    ++reqIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeHorizontal * 3.0,
            left: SizeConfig.blockSizeHorizontal * 3.0,
            right: SizeConfig.blockSizeHorizontal * 3.0,
          ),

          // Scrollable Pokemon info
          child: StreamBuilder(
              stream: _channel.stream.asBroadcastStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  snapshots[reqIndex - 1] = snapshot;
                  _req();
                }
                final List<PokemonEntry> list = [];

                for (int i = 0; i < widget.pokemonTeam.length; ++i) {
                  list.add(
                      PokemonEntry(image: images[i], snapshot: snapshots[i]));
                }

                return ListView(
                  children: list,
                );
              }),
        ),
      ),

      // Exit button
      floatingActionButton: ExitButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class PokemonEntry extends StatelessWidget {
  PokemonEntry({
    Key? key,
    required this.image,
    required this.snapshot,
  }) : super(key: key);

  final Image image;
  final AsyncSnapshot snapshot;
  late String pokemonDescription;
  late String moveset;

  // Parse the json from snapshot into pokemonDescription
  void _parseJson() async {
    final Map<String, dynamic> json = jsonDecode(snapshot.data);
    final rawDescription = json['response'] as String;

    int splitPoint = rawDescription.indexOf('Offense');
    pokemonDescription =
        rawDescription.replaceRange(splitPoint - 1, rawDescription.length, '');

    moveset = rawDescription.replaceRange(0, splitPoint, '');
  }

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final verticalBlockSize = SizeConfig.blockSizeVertical;
      final blockSize = SizeConfig.blockSizeHorizontal;
      _parseJson();
      return Padding(
        padding: EdgeInsets.only(
          left: blockSize * 2.0,
          right: blockSize * 2.0,
        ),
        child: Column(
          children: [
            image,

            // Horizontal divider
            Divider(
              height: verticalBlockSize * 5.0,
              thickness: blockSize * 1.0,
            ),

            Text(
              pokemonDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),

            // Horizontal divider
            Divider(
              height: verticalBlockSize * 5.0,
              thickness: blockSize * 1.0,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        image,
        const LinearProgressIndicator(),
      ],
    );
  }
}
