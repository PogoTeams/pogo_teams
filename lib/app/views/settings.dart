// Flutter
import 'package:flutter/material.dart';
import 'package:pogo_teams/pages/pogo_data_sync.dart';

// Local Imports
import '../../widgets/dialogs.dart';
import '../../modules/pogo_repository.dart';
import '../ui/sizing.dart';
import '../../widgets/buttons/gradient_button.dart';

/*
-------------------------------------------------------------------- @PogoTeams
App settings.
-------------------------------------------------------------------------------
*/

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
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
                'Clear All Local Data  ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Icon(
                Icons.restore,
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
        await processFinished(
          context,
          'All Local Data Cleared',
          'All Local Pogo Teams data was removed from this device.',
        );
        if (mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const PogoDataSync(
                  forceUpdate: true,
                ),
              ));
        }
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
