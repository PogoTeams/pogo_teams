// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pogo_teams/app/bloc/app_bloc.dart';
import 'package:pogo_teams/app/pogo_scaffold/pogo_scaffold.dart';
import 'package:pogo_teams/modules/pogo_repository.dart';

// Local Imports
import 'ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class PogoDataSync extends StatelessWidget {
  const PogoDataSync({
    super.key,
    this.forceUpdate = false,
  });

  final bool forceUpdate;
  static const String routeName = 'pogoDataSync';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc(pogoRepository: context.read<PogoRepository>())
        ..add(PogoDataFetched()),
      child: const PogoDataSyncView(),
    );
  }
}

class PogoDataSyncView extends StatelessWidget {
  const PogoDataSyncView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state is AppLoaded) {
          Navigator.pushReplacementNamed(context, PogoScaffold.routeName);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: Sizing.horizontalWindowInsets(context).copyWith(
            bottom: Sizing.screenHeight(context) * .10,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: Sizing.screenWidth(context) * .03,
              right: Sizing.screenWidth(context) * .05,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Loading message
                  BlocBuilder<AppBloc, AppState>(
                    builder: (context, state) {
                      if (state is AppLoading && state.message != null) {
                        return Text(
                          state.message!,
                          style: Theme.of(context).textTheme.titleLarge,
                        );
                      }

                      return Container();
                    },
                  ),

                  // Loading indicator
                  const SizedBox(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                      semanticsLabel: 'Pogo Teams Loading Indicator',
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
