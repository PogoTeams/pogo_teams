// Flutter
import 'package:flutter/material.dart';

// Packages
import 'package:url_launcher/url_launcher.dart';

// Local Imports
import '../pages/pogo_pages.dart';
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

  void _launchGitHubUrl() async => await launchUrl(Uri.https(
        'github.com',
        'PogoTeams/pogo_teams',
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
          bottom: Sizing.blockSizeVertical * 2.0,
        ),
        decoration: _buildGradientDecoration(),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  // Pogo Teams Logo
                  _buildDrawerHeader(),

                  // Teams
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          PogoPages.teams.displayName,
                          style: Theme.of(context).textTheme.headlineSmall,
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

                  // Tags
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          PogoPages.tags.displayName,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(
                          width: Sizing.blockSizeHorizontal * 3.0,
                        ),
                        PogoPages.tags.icon,
                      ],
                    ),
                    onTap: () async {
                      onNavSelected(PogoPages.tags);
                      Navigator.pop(context);
                    },
                  ),

                  // Battle logs
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          PogoPages.battleLogs.displayName,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(
                          width: Sizing.blockSizeHorizontal * 3.0,
                        ),
                        PogoPages.battleLogs.icon,
                      ],
                    ),
                    onTap: () {
                      onNavSelected(PogoPages.battleLogs);
                      Navigator.pop(context);
                    },
                  ),

                  // Rankings
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          PogoPages.rankings.displayName,
                          style: Theme.of(context).textTheme.headlineSmall,
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

            // Synchronize Pogo data
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: Sizing.blockSizeHorizontal * 2.0,
                  ),
                  Text(
                    PogoPages.sync.displayName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    width: Sizing.blockSizeHorizontal * 3.0,
                  ),
                  PogoPages.sync.icon,
                ],
              ),
              onTap: () {
                onNavSelected(PogoPages.sync);
                Navigator.pop(context);
              },
            ),

            // Google Drive
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: Sizing.blockSizeHorizontal * 2.0,
                  ),
                  Text(
                    PogoPages.driveBackup.displayName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    width: Sizing.blockSizeHorizontal * 3.0,
                  ),
                  PogoPages.driveBackup.icon,
                ],
              ),
              onTap: () async {
                onNavSelected(PogoPages.driveBackup);
                Navigator.pop(context);
              },
            ),

            // Settings
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: Sizing.blockSizeHorizontal * 2.0,
                  ),
                  Text(
                    PogoPages.settings.displayName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    width: Sizing.blockSizeHorizontal * 3.0,
                  ),
                  PogoPages.settings.icon,
                ],
              ),
              onTap: () async {
                onNavSelected(PogoPages.settings);
                Navigator.pop(context);
              },
            ),

            SizedBox(
              height: Sizing.blockSizeHorizontal * 3.0,
            ),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: Sizing.blockSizeHorizontal * 5.0,
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

                SizedBox(
                  width: Sizing.blockSizeHorizontal * 3.0,
                ),

                // Version
                Text(
                  Globals.version,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
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
