// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pogo_teams/enums/rankings_categories.dart';
import 'package:pogo_teams/pages/teams/bloc/teams_bloc.dart';
import 'package:pogo_teams/utils/async_state.dart';

// Local
import 'counters.dart';
import '../../widgets/analysis/type_coverage.dart';
import '../../widgets/nodes/pokemon_node.dart';
import '../../widgets/formatted_pokemon_name.dart';
import '../../widgets/buttons/pokemon_action_button.dart';
import '../teams/team_swap.dart';
import '../../model/pokemon.dart';
import '../../model/pokemon_team.dart';
import '../../model/pokemon_typing.dart';
import '../../modules/pokemon_types.dart';
import '../../modules/pogo_repository.dart';
import '../../app/ui/sizing.dart';

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
  const UserTeamAnalysis({super.key});

  @override
  State<UserTeamAnalysis> createState() => _UserTeamAnalysisState();
}

class _UserTeamAnalysisState extends State<UserTeamAnalysis>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final TabController _tabController;
  late final TabController _threatsTabController;
  bool _teamExpanded = false;

  // When the team is changed from a swap page, animate to the top of to
  // display the new team
  void _onSwap(PokemonTeam team, Pokemon swapPokemon) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return TeamSwap(
            team: team,
            swap: UserPokemon.fromPokemon(swapPokemon),
          );
        },
      ),
    );
  }

  void _onCounters(PokemonTeam team, Pokemon pokemon) async {
    List<PokemonType> counterTypes;

    if (pokemon.getBase().isMonoType()) {
      counterTypes = PokemonTypes.getCounterTypes(
        [
          pokemon.getBase().typing.typeA,
        ],
        team.cup.includedTypeKeys(),
      );
    } else {
      counterTypes = PokemonTypes.getCounterTypes(
        [
          pokemon.getBase().typing.typeA,
          pokemon.getBase().typing.typeB!,
        ],
        team.cup.includedTypeKeys(),
      );
    }

    List<CupPokemon> counters = context.read<PogoRepository>().getCupPokemon(
          team.cup,
          counterTypes,
          RankingsCategories.overall,
          limit: 50,
        );

    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return PokemonCountersList(
              team: team,
              pokemon: pokemon,
              counters: counters,
            );
          },
        ),
      );
    }
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
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          // Spacer
          SizedBox(
            width: Sizing.screenWidth(context) * .03,
          ),

          // Page icon
          const Icon(
            Icons.analytics,
            size: Sizing.icon3,
          ),
        ],
      ),
    );
  }

  // Build the list of either 3 or 6 PokemonNodes that make up this team
  Widget _buildPokemonNodes(PokemonTeam team) {
    List<UserPokemon> pokemonTeam = team.getNonNullPokemonList();
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        pokemonTeam.length,
        (index) {
          return Padding(
            padding: const EdgeInsets.only(
              top: Sizing.listItemVerticalSpacing * .5,
              bottom: Sizing.listItemVerticalSpacing * .5,
            ),
            child: PokemonNode.small(
              pokemon: pokemonTeam[index],
              context: context,
              onMoveChanged: () {
                context.read<TeamsBloc>().add(TeamChanged(team: team));
              },
              lead: ((pokemonTeam[index].teamIndex ?? -1) == 0),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScaffoldBody(TeamsState state) {
    final team = state.selectedTeam!;
    return Column(
      children: [
        ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.zero,
          dividerColor: Colors.transparent,
          elevation: 0.0,
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _teamExpanded = isExpanded;
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
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                );
              },
              body: Padding(
                padding: EdgeInsets.only(
                  left: Sizing.screenWidth(context) * .02,
                  right: Sizing.screenWidth(context) * .02,
                ),
                child: _buildPokemonNodes(team),
              ),
              isExpanded: _teamExpanded,
            ),
          ],
        ),
        Padding(
          padding: Sizing.horizontalWindowInsets(context),
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
              left: Sizing.screenWidth(context) * .02,
              right: Sizing.screenWidth(context) * .02,
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                TypeCoverage(
                  netEffectiveness: state.netEffectiveness!,
                  defenseThreats: state.defenseThreats!,
                  offenseCoverage: state.offenseCoverage!,
                  includedTypesKeys: state.selectedTeam!.cup.includedTypeKeys(),
                  teamSize: team.teamSize,
                ),
                _buildThreats(state),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThreats(TeamsState state) {
    UserPokemon? leadPokemon = state.selectedTeam!.getPokemon(0);
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
                itemCount: state.overallThreats!.length,
                itemBuilder: (context, index) {
                  return MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    onLongPress: () {},
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: Sizing.screenHeight(context) * .005,
                        bottom: Sizing.screenHeight(context) * .005,
                      ),
                      child: PokemonNode.large(
                        pokemon: state.overallThreats![index],
                        context: context,
                        footer: _buildPokemonNodeFooter(
                          state.selectedTeam!,
                          context,
                          state.overallThreats![index],
                        ),
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
                      itemCount: state.leadThreats!.length,
                      itemBuilder: (context, index) {
                        return MaterialButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          onLongPress: () {},
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: Sizing.screenHeight(context) * .005,
                              bottom: Sizing.screenHeight(context) * .005,
                            ),
                            child: PokemonNode.large(
                              pokemon: state.leadThreats![index],
                              context: context,
                              footer: _buildPokemonNodeFooter(
                                state.selectedTeam!,
                                context,
                                state.leadThreats![index],
                              ),
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

  Widget _buildPokemonNodeFooter(
    PokemonTeam team,
    BuildContext context,
    CupPokemon pokemon,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: PokemonActionButton(
            pokemon: pokemon,
            label: 'Team Swap',
            icon: const Icon(
              Icons.move_up,
              color: Colors.white,
            ),
            onPressed: (pokemon) => _onSwap(team, pokemon),
          ),
        ),
        Sizing.paneSpacer,
        Flexible(
          child: PokemonActionButton(
            pokemon: pokemon,
            label: 'Counters',
            icon: const Icon(
              Icons.block,
              color: Colors.white,
            ),
            onPressed: (pokemon) => _onCounters(team, pokemon),
          ),
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
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocBuilder<TeamsBloc, TeamsState>(
        builder: (context, state) {
          if (state.analysisAsyncState.status.isInProgress) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: SizedBox(
                      width: Sizing.screenWidth(context) * .07,
                      height: Sizing.screenWidth(context) * .07,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
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

          return _buildScaffoldBody(state);
        },
      ),
    );
  }
}
