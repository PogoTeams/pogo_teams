// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Local Imports
import '../ui/sizing.dart';
import '../../model/pokemon.dart';
import '../../model/cup.dart';
import '../../widgets/pokemon_list/pokemon_list.dart';
import '../../widgets/pogo_text_field.dart';
import '../../widgets/dropdowns/cup_dropdown.dart';
import '../../widgets/buttons/rankings_category_button.dart';
import '../../modules/pogo_repository.dart';
import '../../enums/rankings_categories.dart';

/*
-------------------------------------------------------------------- @PogoTeams
This screen will display a list of rankings based on selected cup, and
category. These categories and ranking information are all currently used from
The PvPoke model.
-------------------------------------------------------------------------------
*/

class Rankings extends StatefulWidget {
  const Rankings({super.key});

  @override
  State<Rankings> createState() => _RankingsState();
}

class _RankingsState extends State<Rankings> {
  // Setup the input controller
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.screenHeight(context) * .02,
      ),
      child: const PokemonList(
        dropdowns: false,
      ),
    );
  }
}
