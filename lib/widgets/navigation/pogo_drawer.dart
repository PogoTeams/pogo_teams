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
    required this.currentPage,
    this.isModal = true,
  });

  final Function(PogoPages) onNavSelected;
  final PogoPages currentPage;
  final bool isModal;

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
          scale: Sizing.screenWidth(context) * .05,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: isModal ? Sizing.modalDrawerWidth(context) : null,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: _buildGradientDecoration(),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: constraints.copyWith(
                  minHeight: constraints.maxHeight,
                  maxHeight: double.infinity,
                ),
                child: IntrinsicHeight(
                  child: SafeArea(
                    left: false,
                    right: false,
                    child: Column(
                      children: [
                        const DriveBackup(),
                        Expanded(
                          child: Column(
                            children: [
                              // Teams
                              ListTile(
                                titleTextStyle:
                                    Theme.of(context).textTheme.headlineSmall,
                                selectedColor:
                                    Theme.of(context).colorScheme.background,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${PogoPages.teams.displayName}  ',
                                    ),
                                    PogoPages.teams.icon,
                                  ],
                                ),
                                selected: currentPage == PogoPages.teams,
                                onTap: () {
                                  onNavSelected(PogoPages.teams);
                                  if (isModal) Navigator.pop(context);
                                },
                              ),

                              // Tags
                              ListTile(
                                titleTextStyle:
                                    Theme.of(context).textTheme.headlineSmall,
                                selectedColor:
                                    Theme.of(context).colorScheme.background,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${PogoPages.tags.displayName}  ',
                                    ),
                                    PogoPages.tags.icon,
                                  ],
                                ),
                                selected: currentPage == PogoPages.tags,
                                onTap: () async {
                                  onNavSelected(PogoPages.tags);
                                  if (isModal) Navigator.pop(context);
                                },
                              ),

                              // Battle logs
                              ListTile(
                                titleTextStyle:
                                    Theme.of(context).textTheme.headlineSmall,
                                selectedColor:
                                    Theme.of(context).colorScheme.background,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${PogoPages.battleLogs.displayName}  ',
                                    ),
                                    PogoPages.battleLogs.icon,
                                  ],
                                ),
                                selected: currentPage == PogoPages.battleLogs,
                                onTap: () {
                                  onNavSelected(PogoPages.battleLogs);
                                  if (isModal) Navigator.pop(context);
                                },
                              ),

                              // Rankings
                              ListTile(
                                titleTextStyle:
                                    Theme.of(context).textTheme.headlineSmall,
                                selectedColor:
                                    Theme.of(context).colorScheme.background,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${PogoPages.rankings.displayName}  ',
                                    ),
                                    PogoPages.rankings.icon,
                                  ],
                                ),
                                selected: currentPage == PogoPages.rankings,
                                onTap: () {
                                  onNavSelected(PogoPages.rankings);
                                  if (isModal) Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),

                        // Synchronize Pogo data
                        ListTile(
                          titleTextStyle:
                              Theme.of(context).textTheme.headlineSmall,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${PogoPages.sync.displayName}  ',
                              ),
                              PogoPages.sync.icon,
                            ],
                          ),
                          onTap: () {
                            onNavSelected(PogoPages.sync);
                            if (isModal) Navigator.pop(context);
                          },
                        ),

                        // Settings
                        ListTile(
                          titleTextStyle:
                              Theme.of(context).textTheme.headlineSmall,
                          selectedColor:
                              Theme.of(context).colorScheme.background,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${PogoPages.settings.displayName}  ',
                              ),
                              PogoPages.settings.icon,
                            ],
                          ),
                          selected: currentPage == PogoPages.settings,
                          onTap: () async {
                            onNavSelected(PogoPages.settings);
                            if (isModal) Navigator.pop(context);
                          },
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
                              width: Sizing.screenWidth(context) * .1,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: _launchGitHubUrl,
                                icon: Image.asset(
                                    'assets/GitHub-Mark-Light-64px.png'),
                              ),
                            ),

                            Sizing.paneSpacer,

                            // Version
                            Text(
                              Globals.version,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
