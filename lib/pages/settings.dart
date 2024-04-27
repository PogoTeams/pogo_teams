// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../widgets/dialogs.dart';
import '../modules/pogo_repository.dart';
import '../app/ui/sizing.dart';
import '../widgets/buttons/gradient_button.dart';

/*
-------------------------------------------------------------------- @PogoTeams
App settings.
-------------------------------------------------------------------------------
*/

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Widget _buildSettingsListView() {
    return ListView(
      children: [
        GradientButton(
          onPressed: _clearUserData,
          width: Sizing.screenWidth(context) * .85,
          height: Sizing.screenHeight(context) * .085,
          borderRadius: BorderRadius.circular(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Clear All Local Data',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                width: Sizing.screenWidth(context) * .05,
              ),
              Icon(
                Icons.restore,
                size: Sizing.screenWidth(context) * .07,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _clearUserData() async {
    if (await getConfirmation(
      context,
      'Clear All',
      'All local data will be removed from this device.',
    )) {
      await PogoRepository.clearUserData();

      if (mounted) {
        processFinished(
          context,
          'All Local Data Cleared',
          'All Local Pogo Teams data was removed from this device.',
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.screenHeight(context) * .02,
        left: Sizing.screenWidth(context) * .02,
        right: Sizing.screenWidth(context) * .02,
      ),
      child: _buildSettingsListView(),
    );
  }
}
