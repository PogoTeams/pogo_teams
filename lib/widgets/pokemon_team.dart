// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import 'nodes/pokemon_nodes.dart';
import 'nodes/empty_node.dart';
import 'dropdowns/cup_dropdown.dart';
import '../data/pokemon/pokemon.dart';
import '../data/cup.dart';
import '../configs/size_config.dart';
import '../screens/pokemon_search.dart';
import '../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
The Pokemon Team data model contains a list of 3 nullable Pokemon references
and a Cup reference. This collection represents a single Pokemon PVP Team.
This Pokemon Team can then be used to compute various information throughout
the app.
-------------------------------------------------------------------------------
*/

// The data model for a Pokemon PVP Team
// Every team page manages one instance of this class
class PokemonTeam {
  // The list of 3 pokemon references
  List<Pokemon?> team = List.filled(3, null);

  // The selected PVP cup for this team
  // Defaults to Great League
  Cup cup = globals.gamemaster.cups[0];

  // Get the list of non-null pokemon
  List<Pokemon> getPokemonTeam() {
    return team.whereType<Pokemon>().toList();
  }

  // True if there are no pokemon on the team
  bool isEmpty() {
    return team[0] == null && team[1] == null && team[2] == null;
  }

  // Switch to a different cup with the specified cupTitle
  void setCup(String cupTitle) {
    cup = globals.gamemaster.cups.firstWhere((cup) => cup.title == cupTitle);
  }
}

// A single page of 3 TeamContainers to represent a single Pokemon team
class TeamPage extends StatefulWidget {
  const TeamPage({
    Key? key,
    required this.pokemonTeam,
  }) : super(key: key);

  // This team page's Pokemon team
  final PokemonTeam pokemonTeam;

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage>
    with AutomaticKeepAliveClientMixin {
  void _onCupChanged(String? newCup) {
    if (newCup == null) return;

    setState(() {
      widget.pokemonTeam.setCup(newCup);
    });
  }

  void _onLeadChanged(Pokemon? newLead) {
    setState(() {
      widget.pokemonTeam.team[0] = newLead;
    });
  }

  void _onMidChanged(Pokemon? newMid) {
    setState(() {
      widget.pokemonTeam.team[1] = newMid;
    });
  }

  void _onCloserChanged(Pokemon? newCloser) {
    setState(() {
      widget.pokemonTeam.team[2] = newCloser;
    });
  }

  // Keeps page state upon swiping away in PageView
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final team = widget.pokemonTeam.team;
    final cup = widget.pokemonTeam.cup;

    PokemonTeam getTeam() {
      return widget.pokemonTeam;
    }

    return Padding(
      padding: EdgeInsets.only(
        right: SizeConfig.screenWidth * .025,
        left: SizeConfig.screenWidth * .025,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Dropdown for pvp cup selection
          CupDropdown(
            cup: cup,
            onCupChanged: _onCupChanged,
          ),

          // The 3 TeamContainers
          TeamContainer(
            role: 'lead',
            pokemon: team[0],
            cup: cup,
            onNodeChanged: _onLeadChanged,
            teamGetter: getTeam,
          ),
          TeamContainer(
            role: 'mid',
            pokemon: team[1],
            cup: cup,
            onNodeChanged: _onMidChanged,
            teamGetter: getTeam,
          ),
          TeamContainer(
            role: 'closer',
            pokemon: team[2],
            cup: cup,
            onNodeChanged: _onCloserChanged,
            teamGetter: getTeam,
          ),
        ],
      ),
    );
  }
}

// A TeamContainer is either an EmptyNode or PokemonNode
// An EmptyNode can be tapped by the user to add a Pokemon to it
// After a Pokemon is added it is a PokemonNode
// Each container has a different role, specifying the different team roles
// -- lead   - The first Pokemon in battle
// -- mid    - Idealy the switch or second Pokemon in battle
// -- closer - Idealy the last Pokemin in battle
class TeamContainer extends StatefulWidget {
  const TeamContainer({
    Key? key,
    required this.role,
    required this.pokemon,
    required this.cup,
    required this.onNodeChanged,
    required this.teamGetter,
  }) : super(key: key);

  final String role;
  final Pokemon? pokemon;
  final Cup cup;
  final Function(Pokemon?) onNodeChanged;
  final PokemonTeam Function() teamGetter;

  @override
  _TeamContainerState createState() => _TeamContainerState();
}

class _TeamContainerState extends State<TeamContainer> {
  // Open a new app page that allows the user to search for a given Pokemon
  // If a Pokemon is selected in that page, the Pokemon reference will be kept
  // The node will then populate all data related to that Pokemon
  _searchMode() async {
    final team = widget.teamGetter();

    final newPokemon = await Navigator.push(
      context,
      MaterialPageRoute<Pokemon>(builder: (BuildContext context) {
        return PokemonSearch(
          team: team,
          role: widget.role,
        );
      }),
    );

    // If a pokemon was returned from the search page, update the node
    // Should only be null when the user exits the search page using the app bar
    if (newPokemon != null) {
      widget.onNodeChanged(newPokemon);
    }
  }

  // Revert a PokemonNode back to an EmptyNode
  _clearNode() {
    widget.onNodeChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth * .95,
      height: SizeConfig.screenHeight * .205,

      // If the Pokemon ref is null, build an empty node
      // Otherwise build a Pokemon node with cooresponding data
      child: (widget.pokemon == null
          ? EmptyNode(
              role: widget.role,
              onPressed: _searchMode,
            )
          : PokemonNode(
              //role: widget.role,
              pokemon: widget.pokemon as Pokemon,
              cup: widget.cup,
              searchMode: _searchMode,
              clear: _clearNode,
            )),
    );
  }
}
