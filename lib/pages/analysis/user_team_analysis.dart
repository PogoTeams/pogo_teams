// Dart
import 'dart:math';

// Flutter
import 'package:flutter/material.dart';

// Local
import '../../enums/rankings_categories.dart';
import '../../pogo_objects/battle_pokemon.dart';
import '../../battle/battle_result.dart';
import 'counters.dart';
import '../../widgets/analysis/type_coverage.dart';
import '../../widgets/nodes/pokemon_node.dart';
import '../../widgets/formatted_pokemon_name.dart';
import '../../widgets/buttons/pokemon_action_button.dart';
import '../teams/team_swap.dart';
import '../../pogo_objects/pokemon.dart';
import '../../pogo_objects/pokemon_team.dart';
import '../../pogo_objects/pokemon_typing.dart';
import '../../modules/data/pokemon_types.dart';
import '../../modules/data/pogo_data.dart';
import '../../modules/ui/sizing.dart';
import '../../tools/pair.dart';
import '../../ranker/pokemon_ranker.dart';
import '../../ranker/ranking_data.dart';

/*
-------------------------------------------------------------------- @PogoTeams
An analysis of the User's team, including:

- Type Coverage: defense threats, offense coverage, and a bar graph showing
  a net effectiveness of the team against each type.

- Threats: A list of threats against the team overall, and a list of threats
  against the lead Pokemon.

Battles are simulated against the top meta for the selected cup to determine
the top threats.
-------------------------------------------------------------------------------
*/

class UserTeamAnalysis extends StatefulWidget {
  const UserTeamAnalysis({
    Key? key,
    required this.team,
    required this.defenseThreats,
    required this.offenseCoverage,
    required this.netEffectiveness,
    required this.onTeamChanged,
  }) : super(key: key);

  final UserPokemonTeam team;
  final List<Pair<PokemonType, double>> defenseThreats;
  final List<Pair<PokemonType, double>> offenseCoverage;
  final List<Pair<PokemonType, double>> netEffectiveness;
  final Function onTeamChanged;

  @override
  _UserTeamAnalysisState createState() => _UserTeamAnalysisState();
}

class _UserTeamAnalysisState extends State<UserTeamAnalysis>
    with TickerProviderStateMixin {
  bool _teamExpanded = false;
  late UserPokemonTeam _team = widget.team;

  final Map<int, RankingData> _teamRankingData = {};
  final List<CupPokemon> _leadThreats = [];
  final List<CupPokemon> _overallThreats = [];
  bool _generateRankings = true;

  // The included type keys of the team's given cup
  late final List<String> includedTypesKeys =
      widget.team.getCup().includedTypeKeys();

  final ScrollController _scrollController = ScrollController();
  late final TabController _tabController;
  late final TabController _threatsTabController;

  // When the team is changed from a swap page, animate to the top of to
  // display the new team
  void _onSwap(Pokemon swapPokemon) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return TeamSwap(
            team: _team,
            swap: UserPokemon.fromPokemon(swapPokemon),
          );
        },
      ),
    );

    widget.onTeamChanged();
  }

  void _onCounters(Pokemon pokemon) async {
    List<PokemonType> counterTypes;

    if (pokemon.getBase().isMonoType()) {
      counterTypes = PokemonTypes.getCounterTypes(
        [
          pokemon.getBase().typing.typeA,
        ],
        includedTypesKeys,
      );
    } else {
      counterTypes = PokemonTypes.getCounterTypes(
        [
          pokemon.getBase().typing.typeA,
          pokemon.getBase().typing.typeB!,
        ],
        includedTypesKeys,
      );
    }
    List<CupPokemon> counters = await PogoData.getCupPokemon(
      _team.getCup(),
      counterTypes,
      RankingsCategories.overall,
      limit: 50,
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return PokemonCountersList(
            team: _team,
            pokemon: pokemon,
            counters: counters,
          );
        },
      ),
    );

    widget.onTeamChanged();
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(
          context,
        ),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            'Team Analysis',
            style: Theme.of(context).textTheme.headline5?.apply(
                  fontStyle: FontStyle.italic,
                ),
          ),

          // Spacer
          SizedBox(
            width: Sizing.blockSizeHorizontal * 3.0,
          ),

          // Page icon
          Icon(
            Icons.analytics,
            size: Sizing.icon3,
          ),
        ],
      ),
    );
  }

  // Build the list of either 3 or 6 PokemonNodes that make up this team
  Widget _buildPokemonNodes(List<UserPokemon> pokemonTeam) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: List.generate(
        pokemonTeam.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            top: Sizing.blockSizeVertical * .5,
            bottom: Sizing.blockSizeVertical * .5,
          ),
          child: PokemonNode.small(
            pokemon: pokemonTeam[index],
            onMoveChanged: () {
              PogoData.updateUserPokemonSync(pokemonTeam[index]);
              widget.onTeamChanged();
            },
            lead: ((pokemonTeam[index].teamIndex ?? -1) == 0),
          ),
        ),
      ),
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Future<void> _generateTeamRankings() async {
    _teamRankingData.clear();
    _leadThreats.clear();
    _overallThreats.clear();

    List<CupPokemon> opponents = await PogoData.getCupPokemon(
      await _team.getCupAsync(),
      PokemonTypes.typeList,
      RankingsCategories.overall,
      limit: 100,
    );

    List<BattleResult> losses = [];

    // Simulate battles against the top meta for this cup
    for (UserPokemon pokemon in await _team.getOrderedPokemonListAsync()) {
      BattlePokemon battlePokemon =
          await BattlePokemon.fromPokemonAsync(await pokemon.getBaseAsync())
            ..selectedBattleFastMove = await pokemon.getSelectedFastMoveAsync()
            ..selectedBattleChargeMoves =
                await pokemon.getSelectedChargeMovesAsync();

      battlePokemon.initializeStats((await _team.getCupAsync()).cp);

      int pokemonIndex = pokemon.teamIndex ?? -1;
      if (pokemonIndex != -1) {
        _teamRankingData[pokemon.teamIndex ?? 0] = await PokemonRanker.rankApp(
          battlePokemon,
          await _team.getCupAsync(),
          opponents,
        );

        // Accumulate lead outcomes
        int len = min(
            10, _teamRankingData[pokemonIndex]!.leadOutcomes!.losses.length);
        losses.addAll(_teamRankingData[pokemonIndex]!
            .leadOutcomes!
            .losses
            .getRange(0, len));

        // Accumulate switch outcomes
        len = min(
            10, _teamRankingData[pokemonIndex]!.switchOutcomes!.losses.length);
        losses.addAll(_teamRankingData[pokemonIndex]!
            .switchOutcomes!
            .losses
            .getRange(0, len));

        // Accumulate closer outcomes
        len = min(
            10, _teamRankingData[pokemonIndex]!.closerOutcomes!.losses.length);
        losses.addAll(_teamRankingData[pokemonIndex]!
            .closerOutcomes!
            .losses
            .getRange(0, len));
      }
    }

    losses.sort((loss1, loss2) =>
        loss2.opponent.currentRating > loss1.opponent.currentRating ? -1 : 1);

    for (BattleResult loss in losses) {
      // Avoid adding duplicate Pokemon
      if (-1 ==
          _overallThreats.indexWhere((threat) =>
              threat.getBase().pokemonId == loss.opponent.pokemonId)) {
        _overallThreats.add(CupPokemon.fromBattlePokemon(
          loss.opponent,
          PogoData.getPokemonById(loss.opponent.pokemonId),
        ));
      }

      if (_overallThreats.length == 20) break;
    }

    // If the user's team has a lead Pokemon
    if (_teamRankingData.containsKey(0)) {
      List<BattleResult> leadLosses = _teamRankingData[0]!.leadOutcomes!.losses;
      // Scale opponent's outcome rating to it's rating against the meta.
      /*
      for (BattleResult result in leadLosses) {
        int i = opponents.indexWhere((pokemon) =>
            pokemon.getBase().pokemonId == result.opponent.pokemonId);
        if (i == -1) {
          result.opponent.currentRating = 0;
        } else {
          result.opponent.currentRating *= opponents[i].ratings.lead;
        }
      }

      // Resort the losses after scaling
      leadLosses.sort((r1, r2) =>
          (r2.opponent.currentRating > r1.opponent.currentRating ? -1 : 1));
          */

      int len = min(leadLosses.length, 20);
      for (BattleResult result in leadLosses.getRange(0, len)) {
        _leadThreats.add(CupPokemon.fromBattlePokemon(
          result.opponent,
          PogoData.getPokemonById(result.opponent.pokemonId),
        ));
      }
    }
  }

  Widget _buildScaffoldBody() {
    return Column(
      children: [
        ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.zero,
          dividerColor: Colors.transparent,
          elevation: 0.0,
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _teamExpanded = !isExpanded;
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      'Team',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                );
              },
              body: Padding(
                padding: EdgeInsets.only(
                  left: Sizing.blockSizeHorizontal * 2.0,
                  right: Sizing.blockSizeHorizontal * 2.0,
                ),
                child: _buildPokemonNodes(_team.getOrderedPokemonList()),
              ),
              isExpanded: _teamExpanded,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            left: Sizing.blockSizeHorizontal * 2.0,
            right: Sizing.blockSizeHorizontal * 2.0,
            bottom: 12.0,
          ),
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Text(
                  'Coverage',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Tab(
                child: Text(
                  'Threats',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: Sizing.blockSizeHorizontal * 2.0,
              right: Sizing.blockSizeHorizontal * 2.0,
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                TypeCoverage(
                  netEffectiveness: widget.netEffectiveness,
                  defenseThreats: widget.defenseThreats,
                  offenseCoverage: widget.offenseCoverage,
                  includedTypesKeys: includedTypesKeys,
                  teamSize: _team.teamSize,
                ),
                _buildThreats(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThreats() {
    UserPokemon? leadPokemon = _team.getPokemon(0);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 12.0,
          ),
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).focusColor,
            ),
            controller: _threatsTabController,
            tabs: [
              Tab(
                child: Text(
                  'Overall',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Lead',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (leadPokemon != null)
                      Text(
                        '-',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    if (leadPokemon != null)
                      FormattedPokemonName(
                        pokemon: leadPokemon.getBase(),
                        style: Theme.of(context).textTheme.bodyMedium?.apply(
                              color: Colors.amber,
                            ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _threatsTabController,
            children: [
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _overallThreats.length,
                itemBuilder: (context, index) {
                  return MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    onLongPress: () {},
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: Sizing.blockSizeVertical * .5,
                        bottom: Sizing.blockSizeVertical * .5,
                      ),
                      child: PokemonNode.large(
                        pokemon: _overallThreats[index],
                        footer: _buildPokemonNodeFooter(
                            context, _overallThreats[index]),
                      ),
                    ),
                  );
                },
                physics: const BouncingScrollPhysics(),
              ),
              leadPokemon == null
                  ? Center(
                      child: Text(
                        'You currently do not have a lead on your team.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _leadThreats.length,
                      itemBuilder: (context, index) {
                        return MaterialButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          onLongPress: () {},
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: Sizing.blockSizeVertical * .5,
                              bottom: Sizing.blockSizeVertical * .5,
                            ),
                            child: PokemonNode.large(
                              pokemon: _leadThreats[index],
                              footer: _buildPokemonNodeFooter(
                                  context, _leadThreats[index]),
                            ),
                          ),
                        );
                      },
                      physics: const BouncingScrollPhysics(),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPokemonNodeFooter(BuildContext context, CupPokemon pokemon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PokemonActionButton(
          width: Sizing.screenWidth * .4,
          pokemon: pokemon,
          label: 'Team Swap',
          icon: Icon(
            Icons.move_up,
            size: Sizing.blockSizeHorizontal * 5.0,
            color: Colors.white,
          ),
          onPressed: _onSwap,
        ),
        PokemonActionButton(
          width: Sizing.screenWidth * .4,
          pokemon: pokemon,
          label: 'Counters',
          icon: Icon(
            Icons.block,
            size: Sizing.blockSizeHorizontal * 5.0,
            color: Colors.white,
          ),
          onPressed: _onCounters,
        ),
      ],
    );
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _threatsTabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    _threatsTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _team = PogoData.getUserTeamSync(_team.id);

    if (_generateRankings) {
      _generateRankings = false;

      return Scaffold(
        appBar: _buildAppBar(),
        body: FutureBuilder(
          future: _generateTeamRankings(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: SizedBox(
                        width: Sizing.blockSizeHorizontal * 7.0,
                        height: Sizing.blockSizeHorizontal * 7.0,
                        child: const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.cyan),
                          semanticsLabel: 'Pogo Teams Loading Indicator',
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    Text(
                      'Analyzing Team & Simulating Battles',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              );
            }

            return _buildScaffoldBody();
          },
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildScaffoldBody(),
    );
  }
}
