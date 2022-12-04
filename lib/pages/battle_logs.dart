// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../pogo_objects/pokemon_team.dart';
import '../pogo_objects/tag.dart';
import '../modules/ui/sizing.dart';
import '../modules/data/pogo_data.dart';
import '../widgets/tag_dot.dart';
import '../widgets/buttons/tag_filter_button.dart';
import '../widgets/buttons/gradient_button.dart';
import '../widgets/nodes/team_node.dart';
import '../widgets/nodes/win_loss_node.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class BattleLogs extends StatefulWidget {
  const BattleLogs({Key? key}) : super(key: key);

  @override
  _RankingsState createState() => _RankingsState();
}

class _RankingsState extends State<BattleLogs> {
  Tag? _selectedTag;

  Widget _buildLoggedBattles() {
    final opponents = PogoData.getOpponentTeamsSync(tag: _selectedTag);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: opponents.length,
      itemBuilder: (context, index) {
        if (index == opponents.length - 1) {
          return Column(
            children: [
              TeamNode(
                onEmptyPressed: (_) => {},
                onPressed: (_) {},
                pokemonTeam: opponents[index].getOrderedPokemonListFilled(),
                cup: opponents[index].getCup(),
                footer: _buildTeamNodeFooter(opponents[index]),
              ),

              // Spacer to give last node in the list more scroll room
              SizedBox(
                height: Sizing.blockSizeVertical * 10.0,
              ),
            ],
          );
        }

        return TeamNode(
          onEmptyPressed: (_) => {},
          onPressed: (_) {},
          pokemonTeam: opponents[index].getOrderedPokemonListFilled(),
          cup: opponents[index].getCup(),
          tag: opponents[index].tag.value,
          footer: _buildTeamNodeFooter(opponents[index]),
        );
      },
      physics: const BouncingScrollPhysics(),
    );
  }

  Widget _buildTeamNodeFooter(OpponentPokemonTeam opponent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TagDot(
          tag: opponent.getTag(),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: Sizing.blockSizeVertical,
            bottom: Sizing.blockSizeVertical,
          ),
          child: WinLossNode(outcome: opponent.battleOutcome),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.blockSizeVertical * 2.0,
      ),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logged battles list
            _buildLoggedBattles(),
          ],
        ),
        floatingActionButton: TagFilterButton(
          tag: _selectedTag,
          onTagChanged: (tag) {
            setState(() {
              _selectedTag = tag;
            });
          },
          width: Sizing.blockSizeHorizontal * .85,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
