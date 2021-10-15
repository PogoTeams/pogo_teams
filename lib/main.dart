import 'package:flutter/material.dart';

const String spritesPath = 'sprites/';
const String imageSuffix = '.png';

void main() {
  runApp(const PogoTeamsApp());
}

class PogoTeamsApp extends StatelessWidget {
  const PogoTeamsApp({Key? key}) : super(key: key);

  //// APPLICATION ROOT
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POGO Teams',
      theme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.yellow),

      /**
       * Routes define the different pages that are found in this application.
       * The initial route will always be the "Team Builder"
       */
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return const TeamBuilder(title: 'Team Builder');
        }
      },
      //home: const TeamBuilder(title: 'Team Builder'),

      //Removes the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}

class TeamBuilder extends StatefulWidget {
  const TeamBuilder({Key? key, required this.title}) : super(key: key);

  final String title;

  //// STATES
  @override
  _TeamBuilderState createState() => _TeamBuilderState();
}

class _TeamBuilderState extends State<TeamBuilder> {
  AssetImage lTeamNode = const AssetImage('sprites/poke.png');

  void _changeImage() {
    setState(() {
      if (lTeamNode.assetName == 'sprites/poke.png') {
        lTeamNode = const AssetImage('sprites/sceptile.png');
      } else {
        lTeamNode = const AssetImage('sprites/poke.png');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ButtonBar(
          alignment: MainAxisAlignment.center,
          buttonPadding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          children: <ElevatedButton>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const PokemonSearch(title: 'POGO Search')));
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: lTeamNode, fit: BoxFit.none, scale: 1.0),
                ),
                child: const Padding(padding: EdgeInsets.all(20.0)),
              ),
            ),
          ]),
    );
  }
}

class PokemonSearch extends StatefulWidget {
  const PokemonSearch({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _PokemonSearchState createState() => _PokemonSearchState();
}

class _PokemonSearchState extends State<PokemonSearch> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    searchController.addListener(_updatePokemonStack);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    searchController.dispose();
    super.dispose();
  }

  void _updatePokemonStack() {
    final String input = searchController.text.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search for a Pokemon',
                  //contentPadding: EdgeInsets.only(left: 95.0),
                ),
                textAlign: TextAlign.center,
                controller: searchController),
            const Divider(
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
                child: SizedBox(
              height: 200.0,
              child: PokemonList(),
            )),
          ],
        ),
      ),
    );
  }
}

class PokemonList extends StatefulWidget {
  PokemonList({Key? key}) : super(key: key);

  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  static const List<Pokemon> pokemonStack = <Pokemon>[
    Pokemon(name: 'Treecko'),
    Pokemon(name: 'Grovyle'),
    Pokemon(name: 'Sceptile')
  ];

  @override
  Widget build(BuildContext buildContext) {
    return ListView(children: <Widget>[
      Container(
        height: 50,
        color: Colors.amber[600],
        child: const Center(child: Text('Entry A')),
      ),
      Container(
        height: 50,
        color: Colors.amber[500],
        child: const Center(child: Text('Entry B')),
      ),
      Container(
        height: 50,
        color: Colors.amber[100],
        child: const Center(child: Text('Entry C')),
      ),
    ]);
  }
}

class Pokemon extends StatefulWidget {
  const Pokemon({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  /*
  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Pokemon && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
  */

  @override
  _PokemonState createState() => _PokemonState();
}

class _PokemonState extends State<Pokemon> {
  @override
  Widget build(BuildContext context) {
    return const Text('Poke');
  }
}
