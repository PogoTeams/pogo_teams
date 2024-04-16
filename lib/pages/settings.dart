// Flutter
import 'package:flutter/material.dart';
import 'package:http/http.dart';

// Local Imports
import '../widgets/dialogs.dart';
import '../modules/data/pogo_repository.dart';
import '../modules/data/google_drive_repository.dart';
import '../modules/ui/sizing.dart';
import '../widgets/buttons/gradient_button.dart';
import 'drive_backups.dart';

/*
-------------------------------------------------------------------- @PogoTeams
App settings.
-------------------------------------------------------------------------------
*/

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<void> _trySignInSilently() async {
    if (await GoogleDriveRepository.trySignInSilently()) {
      setState(() {});
    }
  }

  Future<void> _signIn() async {
    if (await GoogleDriveRepository.signIn()) {
      setState(() {});
    }
  }

  Future<void> _signOut() async {
    await GoogleDriveRepository.signOut();
    setState(() {});
  }

  Widget _buildSettingsListView() {
    return ListView(
      children: [
        GoogleDriveRepository.isSignedIn
            ? _buildGoogleDriveBackupStatus()
            : GradientButton(
                onPressed: _signIn,
                width: Sizing.screenWidth * .85,
                height: Sizing.blockSizeVertical * 8.5,
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign In',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(
                      width: Sizing.blockSizeHorizontal * 5.0,
                    ),
                    Icon(
                      Icons.login,
                      size: Sizing.blockSizeHorizontal * 7.0,
                    ),
                  ],
                ),
              ),
        GradientButton(
          onPressed: _clearUserData,
          width: Sizing.screenWidth * .85,
          height: Sizing.blockSizeVertical * 8.5,
          borderRadius: BorderRadius.circular(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Clear All Local Data',
                style: Theme.of(context).textTheme.titleLarge,
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
        ),
      ],
    );
  }

  Widget _buildGoogleDriveBackupStatus() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              GoogleDriveRepository.account!.email,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
            IconButton(
              onPressed: _signOut,
              icon: Icon(
                Icons.logout,
                size: Sizing.blockSizeHorizontal * 7.0,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GoogleDriveRepository.linkedBackupFile == null
                ? GradientButton(
                    onPressed: () {},
                    width: Sizing.screenWidth * .85,
                    height: Sizing.blockSizeVertical * 8.5,
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Link Backup File',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(
                          width: Sizing.blockSizeHorizontal * 5.0,
                        ),
                        Icon(
                          Icons.drive_file_move,
                          size: Sizing.blockSizeHorizontal * 7.0,
                        ),
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        GoogleDriveRepository.account!.email,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      IconButton(
                        onPressed: _signOut,
                        icon: Icon(
                          Icons.logout,
                          size: Sizing.blockSizeHorizontal * 7.0,
                        ),
                      ),
                    ],
                  ),
            Text(
              GoogleDriveRepository.linkedBackupFile?.name ?? '',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
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
        top: Sizing.blockSizeVertical * 2.0,
        left: Sizing.blockSizeHorizontal * 2.0,
        right: Sizing.blockSizeHorizontal * 2.0,
      ),
      child: _buildSettingsListView(),
    );
  }
}
