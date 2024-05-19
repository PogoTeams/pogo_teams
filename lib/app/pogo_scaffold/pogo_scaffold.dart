// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pogo_teams/app/pogo_data_sync.dart';

// Local Imports
import '../app_views/app_views.dart';
import '../ui/sizing.dart';
import '../../widgets/navigation/pogo_drawer.dart';
import '../../modules/pogo_repository.dart';
import '../bloc/app_bloc.dart';
import 'bloc/pogo_scaffold_bloc.dart';

/*
-------------------------------------------------------------------- @PogoTeams
The top level scaffold for the app. Navigation via the scaffold's drawer, will
apply changes to the body, and app bar title. Upon startup, this widget enters
a loading phase, which animates a progress bar while the gamemaster and
rankings data are loaded. 
-------------------------------------------------------------------------------
*/

class PogoScaffold extends StatelessWidget {
  const PogoScaffold({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PogoScaffoldBloc>(
      create: (_) => PogoScaffoldBloc(),
      child: const PogoScaffoldView(),
    );
  }
}

class PogoScaffoldView extends StatelessWidget {
  const PogoScaffoldView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isExpanded = Sizing.isExpanded(context);

    return BlocConsumer<PogoScaffoldBloc, PogoScaffoldState>(
      listener: (context, state) {
        if (state.currentView == AppViews.sync) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const PogoDataSync(
                forceUpdate: true,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: isExpanded
              ? null
              : AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Page title
                      Text(
                        state.currentView.displayName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),

                      // Spacer
                      SizedBox(
                        width: Sizing.screenWidth(context) * .02,
                      ),

                      // Page icon
                      Icon(
                        state.currentView.icon,
                      ),
                    ],
                  ),
                ),
          drawer: isExpanded ? null : const PogoDrawer(),
          extendBody: true,
          body: Row(
            children: [
              if (isExpanded)
                const PogoDrawer(
                  isModal: false,
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: Sizing.screenWidth(context) * .02,
                    right: Sizing.screenWidth(context) * .02,
                  ),
                  child: state.currentView.page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
