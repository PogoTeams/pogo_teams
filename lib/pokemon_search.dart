import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pogo_data.dart';

//// BASE WIDGET
// This widget manages the gamemaster, which contains all Pokemon GO data
class PogoData extends InheritedWidget {
  const PogoData({
    Key? key,
    required Widget child,
    required this.gamemaster,
  }) : super(key: key, child: child);

  final GameMaster gamemaster;
  //final List<Pokemon> pokemonList;
  //final List<Move> moveList;

  static PogoData of(BuildContext context) {
    final PogoData? result =
        context.dependOnInheritedWidgetOfExactType<PogoData>();
    assert(result != null, 'No PogoData found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

//// APPLICATION ROOT
class PogoTeamsApp extends StatelessWidget {
  const PogoTeamsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POGO Teams',
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Futura'),

      // Routes define the different pages that are found in this application.
      // The initial route will always be the "Team Builder"
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
  //AssetImage lTeamNode = const AssetImage('sprites/poke.png');

  /*
  void _changeImage() {
    setState(() {
      if (lTeamNode.assetName == 'sprites/poke.png') {
        lTeamNode = const AssetImage('sprites/sceptile.png');
      } else {
        lTeamNode = const AssetImage('sprites/poke.png');
      }
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            TeamNode(),
            TeamNode(),
            TeamNode(),
          ],
        )));
  }
}

class TeamNode extends StatefulWidget {
  const TeamNode({Key? key}) : super(key: key);

  @override
  _TeamNodeState createState() => _TeamNodeState();
}

class _TeamNodeState extends State<TeamNode> {
  Widget? nodeButton;

  _searchMode() async {
    Pokemon? pokemon = await Navigator.push(context,
        MaterialPageRoute<Pokemon>(builder: (BuildContext context) {
      return const PokemonSearch(title: 'POGO Search');
    }));

    if (pokemon != null) {
      setState(() {
        /*
        nodeButton = ElevatedButton(
          child: Text(pokemon.speciesName),
          onPressed: _searchMode,
        );
        */
        nodeButton = pokemon;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    nodeButton = IconButton(
      icon: const Icon(
        Icons.add,
        size: 70.0,
      ),
      tooltip: 'add a pokemon to your team',
      onPressed: _searchMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: nodeButton,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: 350,
      height: 185,
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
  List<Pokemon> pokemon = [];
  List<Pokemon> filteredPokemon = [];

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    searchController.addListener(_filterPokemonList);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    searchController.dispose();
    super.dispose();
  }

  void _filterPokemonList() {
    setState(() {
      final String input = searchController.text.toLowerCase();
      filteredPokemon = pokemon
          .where((pkm) => pkm.speciesName.toLowerCase().contains(input))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    pokemon = PogoData.of(context).gamemaster.pokemon;

    //Display a scrollable list of all Pokemon if there is no input
    if (filteredPokemon.isEmpty) {
      filteredPokemon = pokemon;
    }

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
                contentPadding: EdgeInsets.only(left: 95.0),
              ),
              textAlign: TextAlign.center,
              controller: searchController,
            ),
            const Divider(
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
                child: SizedBox(
              height: 200.0,
              child: ListView(
                children: filteredPokemon,
                physics: const BouncingScrollPhysics(),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
