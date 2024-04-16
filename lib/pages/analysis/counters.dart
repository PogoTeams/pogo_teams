// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../modules/ui/sizing.dart';
import '../../modules/data/pogo_repository.dart';
import '../../pogo_objects/pokemon.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/buttons/pokemon_action_button.dart';
import '../../widgets/nodes/pokemon_node.dart';
import '../../pogo_objects/pokemon_team.dart';
import '../teams/team_swap.dart';

/*
-------------------------------------------------------------------- @PogoTeams
Displays a Pokemon, and a list of Pokemon that counter it. The user can also
swap a counter into their team.
-------------------------------------------------------------------------------
*/

class PokemonCountersList extends StatefulWidget {
  const PokemonCountersList({
    Key? key,
    required this.team,
    required this.pokemon,
    required this.counters,
  }) : super(key: key);

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
      width: Sizing.screenWidth * .85,
      height: Sizing.blockSizeVertical * 8.5,
      child: Icon(
        Icons.clear,
        size: Sizing.icon2,
      ),
    );
  }

  Widget _buildPokemonNode(CupPokemon pokemon) {
    return PokemonNode.large(
      pokemon: pokemon,
      footer: PokemonActionButton(
        width: Sizing.screenWidth * .8,
        pokemon: pokemon,
        label: 'Team Swap',
        icon: Icon(
          Icons.move_up,
          size: Sizing.blockSizeHorizontal * 5.0,
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
            left: Sizing.blockSizeHorizontal * 2.0,
            right: Sizing.blockSizeHorizontal * 2.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  bottom: 12.0,
                ),
                child: PokemonNode.small(
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
                                    bottom: Sizing.blockSizeVertical * 15.0),
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
