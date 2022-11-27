// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../widgets/dialogs.dart';
import '../modules/data/pogo_data.dart';
import '../modules/ui/sizing.dart';
import '../widgets/buttons/gradient_button.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Widget _buildSettingsListView() {
    return ListView(
      children: [
        GradientButton(
          onPressed: _clearUserData,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Clear All Local Data',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                width: Sizing.blockSizeHorizontal * 5.0,
              ),
              Icon(
                Icons.restore,
                size: Sizing.blockSizeHorizontal * 7.0,
              ),
            ],
          ),
          width: Sizing.screenWidth * .85,
          height: Sizing.blockSizeVertical * 8.5,
          borderRadius: BorderRadius.circular(10),
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
      await PogoData.clearUserData();

      processFinished(
        context,
        'All Local Data Cleared',
        'All Local Pogo Teams data was removed from this device.',
      );
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
        top: Sizing.blockSizeVertical * 2.0,
        left: Sizing.blockSizeHorizontal * 2.0,
        right: Sizing.blockSizeHorizontal * 2.0,
      ),
      child: _buildSettingsListView(),
    );
  }
}
