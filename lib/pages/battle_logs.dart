// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../pogo_objects/pokemon_team.dart';
import '../pogo_objects/tag.dart';
import '../modules/ui/sizing.dart';
import '../modules/data/pogo_data.dart';
import '../widgets/tag_dot.dart';
import '../widgets/buttons/tag_filter_button.dart';
import '../widgets/nodes/team_node.dart';
import '../widgets/nodes/win_loss_node.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A list of all battles logged on all of the user's teams, which can be filtered
by tag.
-------------------------------------------------------------------------------
*/

class BattleLogs extends StatefulWidget {
  const BattleLogs({Key? key}) : super(key: key);

  @override
  _RankingsState createState() => _RankingsState();
}

class _RankingsState extends State<BattleLogs> {
  Tag? _selectedTag;

  Widget _buildLoggedBattles(List<OpponentPokemonTeam> opponents) {
    return Expanded(
      child: ListView.builder(
        itemCount: opponents.length,
        itemBuilder: (context, index) {
          if (index == opponents.length - 1) {
            return Column(
              children: [
                TeamNode(
                  onEmptyPressed: (_) => {},
                  emptyTransparent: true,
                  onPressed: (_) {},
                  team: opponents[index],
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
            emptyTransparent: true,
            onPressed: (_) {},
            team: opponents[index],
            footer: _buildTeamNodeFooter(opponents[index]),
          );
        },
        physics: const BouncingScrollPhysics(),
      ),
    );
  }

  Widget _buildTeamNodeFooter(OpponentPokemonTeam opponent) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              TagDot(
                tag: opponent.getTag(),
                onPressed: () {},
              ),
              if (opponent.getTag() != null)
                SizedBox(
                  width: Sizing.blockSizeHorizontal * 2.0,
                ),
              if (opponent.getTag() != null)
                Text(
                  opponent.getTag()!.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Sizing.blockSizeVertical,
              bottom: Sizing.blockSizeVertical,
            ),
            child: WinLossNode(outcome: opponent.battleOutcome),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<OpponentPokemonTeam> opponents =
        PogoData.getOpponentTeamsSync(tag: _selectedTag);

    double winRate = 0.0;
    if (opponents.isNotEmpty) {
      winRate =
          100 * opponents.where((opp) => opp.isWin()).length / opponents.length;
    }

    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.blockSizeVertical * 2.0,
      ),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: Sizing.blockSizeHorizontal * 2.0,
                  right: Sizing.blockSizeHorizontal * 2.0,
                  bottom: Sizing.blockSizeVertical * 2.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _selectedTag == null
                        ? Text(
                            'All Teams',
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Row(
                            children: [
                              Text(
                                _selectedTag!.name,
                                style: Theme.of(context).textTheme.titleLarge,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                    Text(
                      'Win Rate : ${winRate.toStringAsFixed(0)} %',
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _buildLoggedBattles(opponents),
            ],
          ),
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
