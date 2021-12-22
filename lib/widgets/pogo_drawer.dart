// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../configs/size_config.dart';
import '../data/globals.dart' as globals;

/*
-------------------------------------------------------------------- @PogoTeams
The drawer that handles all app navigation and some other functionality. It is
accessible to the user by any screen that contains a scaffold app bar.
-------------------------------------------------------------------------------
*/

class PogoDrawer extends StatelessWidget {
  const PogoDrawer({
    Key? key,
    required this.onNavSelected,
  }) : super(key: key);

  final Function(String) onNavSelected;

  // The background gradient on the drawer
  BoxDecoration _buildGradientDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF29F19C), Color(0xFF02A1F9)],
        tileMode: TileMode.clamp,
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 30.0,
      child: DrawerHeader(
        child: Image.asset(
          'assets/pogo_teams_icon.png',
          scale: SizeConfig.blockSizeHorizontal * .5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(
          bottom: SizeConfig.blockSizeVertical * 4.0,
        ),
        decoration: _buildGradientDecoration(),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  // Pogo Teams Logo
                  _buildDrawerHeader(),

                  // Teams page option
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Teams',
                          style: TextStyle(fontSize: SizeConfig.h1),
                        ),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal * 3.0,
                        ),
                        Image.asset(
                          'assets/pokeball_icon.png',
                          width: SizeConfig.h2 * 1.2,
                        ),
                      ],
                    ),
                    onTap: () {
                      onNavSelected('Teams');
                      Navigator.pop(context);
                    },
                  ),

                  // Rankings page option
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Rankings',
                          style: TextStyle(fontSize: SizeConfig.h1),
                        ),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal * 3.0,
                        ),
                        Icon(
                          Icons.bar_chart,
                          size: SizeConfig.h2 * 1.5,
                        ),
                      ],
                    ),
                    onTap: () {
                      onNavSelected('Rankings');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            // Spacer
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2.0,
            ),

            // Current version
            Text(
              globals.version,
              style: TextStyle(
                fontSize: SizeConfig.h2,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
