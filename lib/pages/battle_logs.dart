// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../model/pokemon_team.dart';
import '../model/tag.dart';
import '../app/ui/sizing.dart';
import '../modules/pogo_repository.dart';
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
  const BattleLogs({super.key});

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
                  height: Sizing.screenHeight(context) * .10,
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
                  width: Sizing.screenWidth(context) * .02,
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
              top: Sizing.screenHeight(context) * .01,
              bottom: Sizing.screenHeight(context) * .01,
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
        PogoRepository.getOpponentTeamsSync(tag: _selectedTag);

    double winRate = 0.0;
    if (opponents.isNotEmpty) {
      winRate =
          100 * opponents.where((opp) => opp.isWin()).length / opponents.length;
    }

    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.screenHeight(context) * .02,
      ),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: Sizing.horizontalWindowInsets(context),
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
              Sizing.listItemSpacer,
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
          width: Sizing.screenWidth(context) * .0085,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
