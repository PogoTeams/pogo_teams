// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import 'team_builder_search.dart';
import '../widgets/buttons/analyze_button.dart';
import '../configs/size_config.dart';
import '../widgets/dropdowns/cup_dropdown.dart';
import '../widgets/pogo_drawer.dart';
import '../widgets/nodes/square_pokemon_node.dart';
import '../data/cup.dart';
import '../data/pokemon/pokemon.dart';
import '../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/

class BattleLog extends StatefulWidget {
  const BattleLog({Key? key}) : super(key: key);

  @override
  _BattleLogState createState() => _BattleLogState();
}

class _BattleLogState extends State<BattleLog>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return const Text('Battle Log');
  }
}
