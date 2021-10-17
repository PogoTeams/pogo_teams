import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'pogo_data.dart';

// All widgets will have access to the gamemaster through this widget
// All Pokemon GO related data is populated from a JSON via the GameMaster class
class PogoData extends InheritedWidget {
  const PogoData({
    Key? key,
    required Widget child,
    required this.gamemaster,
  }) : super(key: key, child: child);

  final GameMaster gamemaster;

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

// A column of 3 Team Nodes are displayed
// These nodes represent the Pokemon that are in a particular team
class TeamBuilder extends StatefulWidget {
  const TeamBuilder({Key? key, required this.title}) : super(key: key);

  final String title;

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
        ),
      ),
    );
  }
}

class TeamNode extends StatefulWidget {
  TeamNode({Key? key}) : super(key: key);

  @override
  _TeamNodeState createState() => _TeamNodeState();
}

class _TeamNodeState extends State<TeamNode> {
  // The Pokemon this node manages
  Pokemon? pokemon;

  // Open a new app page that allows the user to search for a given Pokemon
  // If a Pokemon is selected in that page, the Pokemon reference will be kept
  // The node will then populate all data related to that Pokemon
  _searchMode() async {
    final caughtPokemon = await Navigator.push(context,
        MaterialPageRoute<Pokemon>(builder: (BuildContext context) {
      return const PokemonSearch(title: 'POGO Search');
    }));

    // If a pokemon was returned from the search page, update the node
    if (caughtPokemon != null) {
      setState(() {
        pokemon = caughtPokemon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: NodeButton(
        onPressed: _searchMode,
        pokemon: pokemon,
      ),
      width: 350,
      height: 185,
    );
  }
}

class NodeButton extends StatefulWidget {
  const NodeButton({
    Key? key,
    required this.onPressed,
    required this.pokemon,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Pokemon? pokemon;

  @override
  _NodeButtonState createState() => _NodeButtonState();
}

class _NodeButtonState extends State<NodeButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.pokemon == null) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.add,
            size: 70.0,
          ),
          tooltip: 'add a pokemon to your team',
          onPressed: widget.onPressed,
        ),
      );
    }

    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) {
              return widget.pokemon!.typeColor;
            },
          ),
        ),
        onPressed: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.only(right: 7.0),
          margin: const EdgeInsets.only(top: 14.0),
          child: Column(
            children: <Widget>[
              Align(
                child: RichText(
                    text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: widget.pokemon!.speciesName,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: widget.pokemon!.isShadow ? '  [Shadow]' : '',
                      style: const TextStyle(
                          fontSize: 12.0, fontStyle: FontStyle.italic),
                    ),
                  ],
                )),
                /*
                child: RichText(
                  widget.pokemon!.isShadow
                      ? widget.pokemon!.speciesName + ' shadow'
                      : widget.pokemon!.speciesName,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 16.0),
                ),
                */
                alignment: Alignment.topRight,
              ),
            ],
          ),
        ));
  }
}

class PokemonSearch extends StatefulWidget {
  const PokemonSearch({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _PokemonSearchState createState() => _PokemonSearchState();
}

class _PokemonSearchState extends State<PokemonSearch> {
  // Search bar text input controller
  final TextEditingController searchController = TextEditingController();

  // List of ALL Pokemon
  List<Pokemon> pokemon = [];

  // List of ALL Moves
  List<Move> moves = [];

  // A variable list of Pokemon based on search bar text input
  List<Pokemon> filteredPokemon = [];

  // Setup the input controller
  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    searchController.addListener(_filterPokemonList);
  }

  // Setup all Pokemon GO data needed for this page
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the gamemaster reference
    final GameMaster gamemaster =
        context.dependOnInheritedWidgetOfExactType<PogoData>()!.gamemaster;

    // Get the list of Pokemon
    pokemon = gamemaster.pokemon;

    // Get the list of Moves
    moves = gamemaster.moves;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    searchController.dispose();
    super.dispose();
  }

  // Generate a filtered list of Pokemon based off of the search bar user input
  void _filterPokemonList() {
    // Get the lowercase user input
    final String input = searchController.text.toLowerCase();

    setState(() {
      // Build a list of Pokemon button widgets based off of the input
      filteredPokemon = pokemon
          .where((pkm) => pkm.speciesName.toLowerCase().contains(input))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    //Display all Pokemon if there is no input
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
              child: ListView.builder(
                itemCount: filteredPokemon.length,
                itemBuilder: (context, index) {
                  return PokemonBarButton(
                      onPressed: () {
                        Navigator.pop(context, filteredPokemon[index]);
                      },
                      onLongPress: () {},
                      pokemon: filteredPokemon[index]);
                },
                physics: const BouncingScrollPhysics(),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class PokemonBarButton extends StatelessWidget {
  const PokemonBarButton({
    Key? key,
    required this.onPressed,
    required this.onLongPress,
    required this.pokemon,
  }) : super(key: key);

  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            return pokemon.typeColor;
          },
        ),
      ),
      onPressed: onPressed,
      onLongPress: onLongPress,
      child: RichText(
          text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: pokemon.speciesName,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          TextSpan(
            text: pokemon.isShadow ? '  [Shadow]' : '',
            style: const TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
          ),
        ],
      )),
    );
  }
}
