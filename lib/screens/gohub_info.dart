// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

// Local Imports
import '../data/pokemon/pokemon.dart';
import '../widgets/exit_button.dart';

/*
-------------------------------------------------------------------------------
The Pokemon GoHub info page. Various webscraped content is displayed here in a
vertically scrollable view.
-------------------------------------------------------------------------------
*/

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
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8082'),
  );

  final String testJson = '{"min": 1, "max": 10, "randCount": 3}';

  ListView _buildGoHubBody() {
    return ListView(
      shrinkWrap: true,
      children: widget.pokemonTeam.map((pokemon) {
        final String scraperRequest =
            '{"URL": ' + GoHubInfo.goHubBaseUrl + pokemon.dex.toString() + '}';
        print(scraperRequest);
        return Text(scraperRequest);
      }).toList(),
    );
  }

  @override
  void initState() {
    channel.sink.add(testJson);

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
              child: Text(snapshot.hasData ? '${snapshot.data}' : ''));
        },
      ),
      floatingActionButton: ExitButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
