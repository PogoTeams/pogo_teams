// Flutter
import 'package:flutter/material.dart';
import 'package:pogo_teams/pages/pogo_data_sync.dart';

// Local Imports
import '../app/views/app_views.dart';
import '../app/ui/sizing.dart';
import '../widgets/navigation/pogo_drawer.dart';

/*
-------------------------------------------------------------------- @PogoTeams
The top level scaffold for the app. Navigation via the scaffold's drawer, will
apply changes to the body, and app bar title. Upon startup, this widget enters
a loading phase, which animates a progress bar while the gamemaster and
rankings data are loaded. 
-------------------------------------------------------------------------------
*/

class PogoScaffold extends StatefulWidget {
  const PogoScaffold({super.key});

  static const String routeName = '/';

  @override
  State<PogoScaffold> createState() => _PogoScaffoldState();
}

class _PogoScaffoldState extends State<PogoScaffold>
    with TickerProviderStateMixin {
  late final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  AppViews currentPage = AppViews.defaultPage;
  bool? drawerCollapsed;

  void _onDestinationSelected(AppViews page) {
    if (page == AppViews.sync) {
      page = AppViews.defaultPage;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const PogoDataSync(
              forceUpdate: true,
            ),
          ));
    } else {
      setState(() {
        currentPage = page;
      });
    }
  }

  // Build the app bar with the current page title, and icon
  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            currentPage.displayName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          // Spacer
          SizedBox(
            width: Sizing.screenWidth(context) * .02,
          ),

          // Page icon
          Icon(
            currentPage.icon,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isExpanded = Sizing.isExpanded(context);
    drawerCollapsed ??= isExpanded;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isExpanded ? null : _buildAppBar(),
      drawer: isExpanded
          ? null
          : PogoDrawer(
              onDestinationSelected: _onDestinationSelected,
              currentPage: currentPage,
            ),
      extendBody: true,
      body: Row(
        children: [
          if (isExpanded)
            PogoDrawer(
              onDestinationSelected: _onDestinationSelected,
              currentPage: currentPage,
              isModal: false,
              onToggleCollapse: () {
                setState(() {
                  drawerCollapsed = !drawerCollapsed!;
                });
              },
              isCollapsed: drawerCollapsed!,
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: Sizing.screenWidth(context) * .02,
                right: Sizing.screenWidth(context) * .02,
              ),
              child: currentPage.page,
            ),
          ),
        ],
      ),
    );
  }
}
