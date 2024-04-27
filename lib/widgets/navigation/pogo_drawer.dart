// Flutter
import 'package:flutter/material.dart';

// Packages
import 'package:url_launcher/url_launcher.dart';

// Local Imports
import '../../pages/pogo_pages.dart';
import '../../modules/globals.dart';
import '../../app/ui/sizing.dart';
import '../drive_backup.dart';

/*
-------------------------------------------------------------------- @PogoTeams
The drawer that handles all app navigation and some other functionality. It is
accessible to the user by any screen that contains a scaffold app bar.
-------------------------------------------------------------------------------
*/

class PogoDrawer extends StatelessWidget {
  const PogoDrawer({
    super.key,
    required this.onNavSelected,
    this.popOnNavSelected = true,
  });

  final Function(PogoPages) onNavSelected;
  final bool popOnNavSelected;

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

  Widget _buildDrawerHeader(BuildContext context) {
    return SizedBox(
      height: Sizing.screenHeight(context) * .30,
      child: DrawerHeader(
        child: Image.asset(
          'assets/pogo_teams_icon.png',
          scale: Sizing.screenWidth(context) * .005,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(
          bottom: Sizing.screenHeight(context) * .02,
        ),
        decoration: _buildGradientDecoration(),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  // Pogo Teams Logo
                  //_buildDrawerHeader(context),
                  const DriveBackup(),

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
                          width: Sizing.screenWidth(context) * .03,
                        ),
                        PogoPages.teams.icon,
                      ],
                    ),
                    onTap: () {
                      onNavSelected(PogoPages.teams);
                      if (popOnNavSelected) Navigator.pop(context);
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
                          width: Sizing.screenWidth(context) * .03,
                        ),
                        PogoPages.tags.icon,
                      ],
                    ),
                    onTap: () async {
                      onNavSelected(PogoPages.tags);
                      if (popOnNavSelected) Navigator.pop(context);
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
                          width: Sizing.screenWidth(context) * .03,
                        ),
                        PogoPages.battleLogs.icon,
                      ],
                    ),
                    onTap: () {
                      onNavSelected(PogoPages.battleLogs);
                      if (popOnNavSelected) Navigator.pop(context);
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
                          width: Sizing.screenWidth(context) * .03,
                        ),
                        PogoPages.rankings.icon,
                      ],
                    ),
                    onTap: () {
                      onNavSelected(PogoPages.rankings);
                      if (popOnNavSelected) Navigator.pop(context);
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
                    width: Sizing.screenWidth(context) * .02,
                  ),
                  Text(
                    PogoPages.sync.displayName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    width: Sizing.screenWidth(context) * .03,
                  ),
                  PogoPages.sync.icon,
                ],
              ),
              onTap: () {
                onNavSelected(PogoPages.sync);
                if (popOnNavSelected) Navigator.pop(context);
              },
            ),

            // Settings
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: Sizing.screenWidth(context) * .02,
                  ),
                  Text(
                    PogoPages.settings.displayName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    width: Sizing.screenWidth(context) * .03,
                  ),
                  PogoPages.settings.icon,
                ],
              ),
              onTap: () async {
                onNavSelected(PogoPages.settings);
                if (popOnNavSelected) Navigator.pop(context);
              },
            ),

            SizedBox(
              height: Sizing.screenWidth(context) * .03,
            ),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: Sizing.screenWidth(context) * .05,
                ),
                // GitHub link
                SizedBox(
                  width: Sizing.screenWidth(context) * .10,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: _launchGitHubUrl,
                    icon: Image.asset('assets/GitHub-Mark-Light-64px.png'),
                  ),
                ),

                SizedBox(
                  width: Sizing.screenWidth(context) * .03,
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
