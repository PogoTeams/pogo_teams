// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:web_socket_channel/web_socket_channel.dart';

// Local Imports
import '../data/pokemon/pokemon.dart';
import '../widgets/exit_button.dart';

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
  final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080'),
      protocols: ['echo-protocol']);

  final String baseUrl = 'https://pokemon.gameinfo.io/en/pokemon/';

  @override
  void initState() {
    List<String> urls = [];

    final pokemonTeam = widget.pokemonTeam;
    final int teamLength = pokemonTeam.length;

    for (int i = 0; i < teamLength; ++i) {
      urls.add('{"url" : "' +
          baseUrl +
          pokemonTeam[i].dex.toString() +
          '-' +
          pokemonTeam[i].speciesId.toString() +
          '"}');
    }

    channel.sink.add(urls[0]);
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            return Center(
              child: Text(snapshot.hasData ? snapshot.data.toString() : ''),
            );
          }),
      floatingActionButton: ExitButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
