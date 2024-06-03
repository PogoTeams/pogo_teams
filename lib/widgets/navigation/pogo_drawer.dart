// Flutter
import 'package:flutter/material.dart';

// Packages
import 'package:url_launcher/url_launcher.dart';

// Local Imports
import '../../app/views/app_views.dart';
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
    required this.onDestinationSelected,
    required this.currentPage,
    this.isModal = true,
    this.onToggleCollapse,
    this.isCollapsed = false,
  });

  final Function(AppViews) onDestinationSelected;
  final AppViews currentPage;
  final bool isModal;
  final Function()? onToggleCollapse;
  final bool isCollapsed;

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
    final double? width;
    if (isModal) {
      width = Sizing.modalDrawerWidth(context);
    } else if (isCollapsed) {
      width = Sizing.collapsedDrawerWidth;
    } else {
      width = null;
    }

    return Drawer(
      width: width,
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
                        if (!isModal)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RotatedBox(
                              quarterTurns: isCollapsed ? 0 : 1,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.menu,
                                ),
                                onPressed: onToggleCollapse,
                              ),
                            ),
                          ),
                        DriveBackup(
                          isCollapsed: isCollapsed,
                          onBackupRestored: () =>
                              onDestinationSelected(AppViews.sync),
                        ),
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
                                    if (!isCollapsed)
                                      Text(
                                        '${AppViews.teams.displayName}  ',
                                      ),
                                    Icon(
                                      AppViews.teams.icon,
                                    ),
                                  ],
                                ),
                                selected: currentPage == AppViews.teams,
                                onTap: () {
                                  onDestinationSelected(AppViews.teams);
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
                                    if (!isCollapsed)
                                      Text(
                                        '${AppViews.tags.displayName}  ',
                                      ),
                                    Icon(
                                      AppViews.tags.icon,
                                    ),
                                  ],
                                ),
                                selected: currentPage == AppViews.tags,
                                onTap: () async {
                                  onDestinationSelected(AppViews.tags);
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
                                    if (!isCollapsed)
                                      Text(
                                        '${AppViews.battleLogs.displayName}  ',
                                      ),
                                    Icon(
                                      AppViews.battleLogs.icon,
                                    ),
                                  ],
                                ),
                                selected: currentPage == AppViews.battleLogs,
                                onTap: () {
                                  onDestinationSelected(AppViews.battleLogs);
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
                                    if (!isCollapsed)
                                      Text(
                                        '${AppViews.rankings.displayName}  ',
                                      ),
                                    Icon(
                                      AppViews.rankings.icon,
                                    ),
                                  ],
                                ),
                                selected: currentPage == AppViews.rankings,
                                onTap: () {
                                  onDestinationSelected(AppViews.rankings);
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
                              if (!isCollapsed)
                                Text(
                                  '${AppViews.sync.displayName}  ',
                                ),
                              Icon(
                                AppViews.sync.icon,
                              ),
                            ],
                          ),
                          onTap: () {
                            onDestinationSelected(AppViews.sync);
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
                              if (!isCollapsed)
                                Text(
                                  '${AppViews.settings.displayName}  ',
                                ),
                              Icon(
                                AppViews.settings.icon,
                              )
                            ],
                          ),
                          selected: currentPage == AppViews.settings,
                          onTap: () async {
                            onDestinationSelected(AppViews.settings);
                            if (isModal) Navigator.pop(context);
                          },
                        ),

                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(
                              width: 15.0,
                            ),
                            // GitHub link
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 35.0,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: _launchGitHubUrl,
                                  icon: Image.asset(
                                      'assets/GitHub-Mark-Light-64px.png'),
                                ),
                              ),
                            ),

                            Sizing.paneSpacer,

                            // Version
                            if (!isCollapsed)
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
                        Sizing.lineItemSpacer,
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
