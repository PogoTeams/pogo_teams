// Flutter
import 'package:flutter/material.dart';
import 'package:pogo_teams/pages/pogo_scaffold.dart';

// Local Imports
import '../modules/pogo_repository.dart';
import '../utils/pair.dart';
import '../app/ui/sizing.dart';
import '../modules/globals.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class PogoDataSync extends StatefulWidget {
  const PogoDataSync({
    super.key,
    this.forceUpdate = false,
  });

  final bool forceUpdate;
  static const String routeName = 'pogoDataSync';

  @override
  State<PogoDataSync> createState() => _PogoDataSyncState();
}

class _PogoDataSyncState extends State<PogoDataSync>
    with SingleTickerProviderStateMixin {
  // For animating the loading progress bar
  late final AnimationController _progressBarAnimController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: StreamBuilder<Pair<String, double>>(
              stream: PogoRepository.loadPogoData(
                forceUpdate: widget.forceUpdate ? true : Globals.forceUpdate,
              ),
              initialData: Pair(a: '', b: 0.0),
              builder: (context, snapshot) {
                // App is finished loading
                if (snapshot.connectionState == ConnectionState.done) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _progressBarAnimController.dispose();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(
                        context,
                        PogoScaffold.routeName,
                      );
                    }
                  });
                }

                // Rebuild progress bar
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Loading message
                    Text(
                      snapshot.data!.a,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    // Loading indicator
                    SizedBox(
                      child: CircularProgressIndicator(
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.cyan),
                        semanticsLabel: 'Pogo Teams Loading Indicator',
                        semanticsValue: snapshot.data.toString(),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
