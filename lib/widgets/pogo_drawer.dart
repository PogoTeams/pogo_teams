// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../configs/size_config.dart';
import '../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
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
                  _buildDrawerHeader(),

                  // Navigation options
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Team Builder',
                          style: TextStyle(fontSize: SizeConfig.h1),
                        ),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal * 3.0,
                        ),
                        Icon(
                          Icons.build_circle,
                          size: SizeConfig.blockSizeHorizontal * 5.0,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onNavSelected('Team Builder');
                    },
                  ),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Battle Log',
                          style: TextStyle(fontSize: SizeConfig.h1),
                        ),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal * 3.0,
                        ),
                        Icon(
                          Icons.query_stats,
                          size: SizeConfig.blockSizeHorizontal * 5.0,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onNavSelected('Battle Log');
                    },
                  ),
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
                          size: SizeConfig.blockSizeHorizontal * 5.0,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onNavSelected('Rankings');
                    },
                  ),
                ],
              ),
            ),

            // Spacer
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2.0,
            ),

            // Versioning
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
