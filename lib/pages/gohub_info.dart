import 'package:flutter/material.dart';
import '../buttons/exit_button.dart';

class GoHubInfo extends StatelessWidget {
  const GoHubInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.network(
                'https://db.pokemongohub.net/images/official/full/252.webp'),
            Container(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: const Text(
                  "Treecko is a Grass type Pokémon in Pokémon GO. It has a max CP of 1190, with the following stats in Pokémon GO: 124 ATK, 94 DEF and 120 STA. Treecko's best moves in Pokémon GO are Pound and Grass Knot (8.30 DPS). Treecko is vulnerable to Bug, Fire, Flying, Ice and Poison type moves. Treecko is boosted by Sunny weather. It was originally found in the Hoenn region (Gen 3). It's Pokémon number is #252."),
            ),
          ],
        ),
      ),
      floatingActionButton: ExitButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
