// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package Imports
import 'package:provider/provider.dart';

// Local Imports
import 'team_edit.dart';
import '../../configs/size_config.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/pokemon/pokemon.dart';
import '../../widgets/nodes/team_node.dart';

/*
-------------------------------------------------------------------------------
A list view of the user's pvp teams is displayed. Each team is a TeamNode,
containing the following functionality :

- remove a team
- edit a team
-------------------------------------------------------------------------------
*/

class TeamBuilder extends StatefulWidget {
  const TeamBuilder({Key? key}) : super(key: key);

  @override
  _TeamBuilderState createState() => _TeamBuilderState();
}

class _TeamBuilderState extends State<TeamBuilder> {
  // Build the list of TeamNodes, with the necessary callbacks
  Widget _buildTeamsList(BuildContext context) {
    // Provider retrieve
    final _teams =
        Provider.of<PokemonTeams>(context, listen: false).pokemonTeams;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _teams.length,
      itemBuilder: (context, index) => (TeamNode(
        onClear: _onClearTeam,
        onEdit: _onEditTeam,
        teamIndex: index,
        onEmptyPressed: () => _onEmptyPressed(index),
      )),
      physics: const BouncingScrollPhysics(),
    );
  }

  // Remove the team at specified index
  void _onClearTeam(int teamIndex) {
    setState(() {
      Provider.of<PokemonTeams>(context, listen: false).removeTeamAt(teamIndex);
    });
  }

  // Edit the team at specified index
  void _onEditTeam(int teamIndex) {
    Navigator.push(
      context,
      MaterialPageRoute<Pokemon>(
        builder: (BuildContext context) => TeamEdit(
          teamIndex: teamIndex,
        ),
      ),
    );
  }

  // Add a new empty team
  void _onAddTeam() {
    setState(() {
      Provider.of<PokemonTeams>(context, listen: false).addTeam();
    });
  }

  // Wrapper for _onEditTeam
  void _onEmptyPressed(int teamIndex) {
    _onEditTeam(teamIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTeamsList(context),

      // Add team FAB
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTeam,
        child: Icon(
          Icons.add,
          size: SizeConfig.blockSizeHorizontal * 9.0,
        ),
        tooltip: 'Add a Team',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
