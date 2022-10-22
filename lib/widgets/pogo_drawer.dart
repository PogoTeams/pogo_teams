// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:url_launcher/url_launcher.dart';

// Local Imports
import '../enums/pogo_pages.dart';
import '../modules/data/globals.dart';
import '../modules/ui/sizing.dart';

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

  final Function(PogoPages) onNavSelected;

  void _launchGitHubUrl() async => await launchUrl(Uri(
        host: 'https://github.com',
        path: 'PogoTeams/pogo_teams',
      ));

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
      height: Sizing.blockSizeVertical * 30.0,
      child: DrawerHeader(
        child: Image.asset(
          'assets/pogo_teams_icon.png',
          scale: Sizing.blockSizeHorizontal * .5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(
          bottom: Sizing.blockSizeVertical * 4.0,
        ),
        decoration: _buildGradientDecoration(),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  // Pogo Teams Logo
                  _buildDrawerHeader(),

                  // Sign in option
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          PogoPages.account.displayName,
                          style: TextStyle(fontSize: Sizing.h1),
                        ),
                        SizedBox(
                          width: Sizing.blockSizeHorizontal * 3.0,
                        ),
                        PogoPages.account.icon,
                      ],
                    ),
                    onTap: () {
                      onNavSelected(PogoPages.account);
                      Navigator.pop(context);
                    },
                  ),

                  // Teams page option
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          PogoPages.teams.displayName,
                          style: TextStyle(fontSize: Sizing.h1),
                        ),
                        SizedBox(
                          width: Sizing.blockSizeHorizontal * 3.0,
                        ),
                        PogoPages.teams.icon,
                      ],
                    ),
                    onTap: () {
                      onNavSelected(PogoPages.teams);
                      Navigator.pop(context);
                    },
                  ),

                  // Rankings page option
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          PogoPages.rankings.displayName,
                          style: TextStyle(fontSize: Sizing.h1),
                        ),
                        SizedBox(
                          width: Sizing.blockSizeHorizontal * 3.0,
                        ),
                        PogoPages.rankings.icon,
                      ],
                    ),
                    onTap: () {
                      onNavSelected(PogoPages.rankings);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            // Spacer
            SizedBox(
              height: Sizing.blockSizeVertical * 2.0,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Current version
                Text(
                  Globals.version,
                  style: TextStyle(
                    fontSize: Sizing.h2,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                // GitHub link
                SizedBox(
                  width: Sizing.blockSizeHorizontal * 10.0,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: _launchGitHubUrl,
                    icon: Image.asset('assets/GitHub-Mark-Light-64px.png'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
