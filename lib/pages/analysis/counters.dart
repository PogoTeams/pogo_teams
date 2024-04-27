// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../app/ui/sizing.dart';
import '../../modules/pogo_repository.dart';
import '../../model/pokemon.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/buttons/pokemon_action_button.dart';
import '../../widgets/nodes/pokemon_node.dart';
import '../../model/pokemon_team.dart';
import '../teams/team_swap.dart';

/*
-------------------------------------------------------------------- @PogoTeams
Displays a Pokemon, and a list of Pokemon that counter it. The user can also
swap a counter into their team.
-------------------------------------------------------------------------------
*/

class PokemonCountersList extends StatefulWidget {
  const PokemonCountersList({
    super.key,
    required this.team,
    required this.pokemon,
    required this.counters,
  });

  final UserPokemonTeam team;
  final Pokemon pokemon;
  final List<CupPokemon> counters;

  @override
  _PokemonCountersListState createState() => _PokemonCountersListState();
}

class _PokemonCountersListState extends State<PokemonCountersList> {
  late UserPokemonTeam _team = widget.team;

  void _onSwap(Pokemon swapPokemon) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return TeamSwap(
            team: widget.team,
            swap: UserPokemon.fromPokemon(swapPokemon),
          );
        },
      ),
    );

    setState(() {});
  }

  Widget _buildFloatingActionButton() {
    return GradientButton(
      onPressed: () {
        Navigator.pop(context);
      },
      width: Sizing.screenWidth(context) * .85,
      height: Sizing.screenHeight(context) * .8,
      child: const Icon(
        Icons.clear,
        size: Sizing.icon2,
      ),
    );
  }

  Widget _buildPokemonNode(CupPokemon pokemon) {
    return PokemonNode.large(
      context: context,
      pokemon: pokemon,
      footer: PokemonActionButton(
        width: Sizing.screenWidth(context) * .8,
        pokemon: pokemon,
        label: 'Team Swap',
        icon: Icon(
          Icons.move_up,
          size: Sizing.screenWidth(context) * .5,
          color: Colors.white,
        ),
        onPressed: _onSwap,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _team = PogoRepository.getUserTeamSync(_team.id);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: Sizing.screenWidth(context) * .2,
            right: Sizing.screenWidth(context) * .2,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  bottom: 12.0,
                ),
                child: PokemonNode.small(
                  context: context,
                  pokemon: widget.pokemon,
                  dropdowns: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 12.0,
                ),
                child: Text(
                  'Counters',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: widget.counters.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12.0,
                        ),
                        child: index == widget.counters.length - 1
                            ? Padding(
                                padding: EdgeInsets.only(
                                  bottom: Sizing.screenHeight(context) * .15,
                                ),
                                child:
                                    _buildPokemonNode(widget.counters[index]),
                              )
                            : _buildPokemonNode(widget.counters[index]));
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
