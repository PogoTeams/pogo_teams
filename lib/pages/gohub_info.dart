import 'dart:async';
import 'package:flutter/material.dart';
import '../data/pokemon.dart';
import '../widgets/exit_button.dart';

class GoHubInfo extends StatefulWidget {
  const GoHubInfo({
    Key? key,
    required this.pokemonTeam,
  }) : super(key: key);

  final List<Pokemon> pokemonTeam;
  static const String goHubBaseUrl = 'https://db.pokemongohub.net/pokemon/';

  @override
  _GoHubInfoState createState() => _GoHubInfoState();
}

class _GoHubInfoState extends State<GoHubInfo> {
  late StreamSubscription _subscription;

  ListView _buildGoHubBody() {
    return ListView(
      shrinkWrap: true,
      children: widget.pokemonTeam.map((pokemon) {
        final String scraperRequest =
            '{"URL": ' + GoHubInfo.goHubBaseUrl + pokemon.dex.toString() + '}';
        return Text(scraperRequest);
      }).toList(),
    );
  }

  @override
  void initState() {
    // Setup for microservice request
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildGoHubBody(),
      floatingActionButton: ExitButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
