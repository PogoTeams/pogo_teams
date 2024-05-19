// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Packages
import 'package:url_launcher/url_launcher.dart';

// Local Imports
import '../../app/views/app_views.dart';
import '../../modules/globals.dart';
import '../../app/ui/sizing.dart';
import '../drive_backup.dart';
import '../../app/pogo_scaffold/bloc/pogo_scaffold_bloc.dart';

/*
-------------------------------------------------------------------- @PogoTeams
The drawer that handles all app navigation and some other functionality. It is
accessible to the user by any screen that contains a scaffold app bar.
-------------------------------------------------------------------------------
*/

class PogoDrawer extends StatelessWidget {
  const PogoDrawer({
    super.key,
    this.isModal = true,
  });

  final bool isModal;

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
                    child: _PogoDrawerContents(
                      isModal: isModal,
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

class _PogoDrawerContents extends StatelessWidget {
  const _PogoDrawerContents({required this.isModal});

  final bool isModal;

  void _launchGitHubUrl() async => await launchUrl(Uri.https(
        'github.com',
        'PogoTeams/pogo_teams',
      ));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PogoScaffoldBloc, PogoScaffoldState>(
      builder: (context, state) {
        return Column(
          children: [
            const DriveBackup(),
            Expanded(
              child: Column(
                children: [
                  // Teams
                  ListTile(
                    titleTextStyle: Theme.of(context).textTheme.headlineSmall,
                    selectedColor: Theme.of(context).colorScheme.background,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${AppViews.teams.displayName}  ',
                        ),
                        Icon(
                          AppViews.teams.icon,
                        ),
                      ],
                    ),
                    selected: state.currentView == AppViews.teams,
                    onTap: () {
                      context.read<PogoScaffoldBloc>().add(
                            const DestinationSelected(
                              currentView: AppViews.teams,
                            ),
                          );
                      if (isModal) Navigator.pop(context);
                    },
                  ),

                  // Tags
                  ListTile(
                    titleTextStyle: Theme.of(context).textTheme.headlineSmall,
                    selectedColor: Theme.of(context).colorScheme.background,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${AppViews.tags.displayName}  ',
                        ),
                        Icon(
                          AppViews.tags.icon,
                        ),
                      ],
                    ),
                    selected: state.currentView == AppViews.tags,
                    onTap: () async {
                      context.read<PogoScaffoldBloc>().add(
                            const DestinationSelected(
                              currentView: AppViews.tags,
                            ),
                          );
                      if (isModal) Navigator.pop(context);
                    },
                  ),

                  // Battle logs
                  ListTile(
                    titleTextStyle: Theme.of(context).textTheme.headlineSmall,
                    selectedColor: Theme.of(context).colorScheme.background,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${AppViews.battleLogs.displayName}  ',
                        ),
                        Icon(
                          AppViews.battleLogs.icon,
                        ),
                      ],
                    ),
                    selected: state.currentView == AppViews.battleLogs,
                    onTap: () {
                      context.read<PogoScaffoldBloc>().add(
                            const DestinationSelected(
                              currentView: AppViews.battleLogs,
                            ),
                          );
                      if (isModal) Navigator.pop(context);
                    },
                  ),

                  // Rankings
                  ListTile(
                    titleTextStyle: Theme.of(context).textTheme.headlineSmall,
                    selectedColor: Theme.of(context).colorScheme.background,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${AppViews.rankings.displayName}  ',
                        ),
                        Icon(
                          AppViews.rankings.icon,
                        ),
                      ],
                    ),
                    selected: state.currentView == AppViews.rankings,
                    onTap: () {
                      context.read<PogoScaffoldBloc>().add(
                            const DestinationSelected(
                              currentView: AppViews.rankings,
                            ),
                          );
                      if (isModal) Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            // Synchronize Pogo data
            ListTile(
              titleTextStyle: Theme.of(context).textTheme.headlineSmall,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${AppViews.sync.displayName}  ',
                  ),
                  Icon(
                    AppViews.sync.icon,
                  ),
                ],
              ),
              onTap: () {
                context.read<PogoScaffoldBloc>().add(
                      const DestinationSelected(
                        currentView: AppViews.sync,
                      ),
                    );
                if (isModal) Navigator.pop(context);
              },
            ),

            // Settings
            ListTile(
              titleTextStyle: Theme.of(context).textTheme.headlineSmall,
              selectedColor: Theme.of(context).colorScheme.background,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${AppViews.settings.displayName}  ',
                  ),
                  Icon(
                    AppViews.settings.icon,
                  )
                ],
              ),
              selected: state.currentView == AppViews.settings,
              onTap: () async {
                context.read<PogoScaffoldBloc>().add(
                      const DestinationSelected(
                        currentView: AppViews.settings,
                      ),
                    );
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
                SizedBox(
                  width: Sizing.shortedSide(context) * .1,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: _launchGitHubUrl,
                    icon: Image.asset('assets/GitHub-Mark-Light-64px.png'),
                  ),
                ),

                Sizing.paneSpacer,

                // Version
                Text(
                  Globals.version,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
            Sizing.lineItemSpacer,
          ],
        );
      },
    );
  }
}

class _DrawerLogoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
