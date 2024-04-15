// Dart
import 'dart:async';
import 'dart:convert';

// Flutter
import 'package:flutter/material.dart';

// Packages
import 'package:googleapis/drive/v3.dart' as drive_api;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

// Local Imports
import '../widgets/dialogs.dart';
import '../modules/data/globals.dart';
import '../modules/data/pogo_data.dart';
import '../modules/data/user_data.dart';
import '../modules/ui/sizing.dart';
import '../widgets/buttons/gradient_button.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A Google drive integration allowing the user to backup and restore their data
using a Google account.
-------------------------------------------------------------------------------
*/

class DriveBackup extends StatefulWidget {
  const DriveBackup({Key? key}) : super(key: key);

  @override
  _DriveBackupState createState() => _DriveBackupState();
}

class _DriveBackupState extends State<DriveBackup> {
  final TextEditingController _textController = TextEditingController();
  bool _refreshBackupsList = false;
  Function()? _beforeLoadBackups;

  void _trySignInSilently() async {
    if (await UserData.trySignInSilently()) {
      setState(() {
        _refreshBackupsList = true;
      });
    }
  }

  void _signIn() async {
    if (await UserData.signIn()) {
      setState(() {
        _refreshBackupsList = true;
      });
    }
  }

  void _signOut() async {
    await UserData.signOut();
    setState(() {
      _refreshBackupsList = false;
    });
  }

  void _import() async {
    if (UserData.selectedBackupFile == null ||
        UserData.selectedBackupFile?.id == null) return;
    if (await getConfirmation(context, 'Download Backup',
        'All data will be imported from ${UserData.selectedBackupFile?.name ?? 'this file'}.')) {
      setState(() {
        _refreshBackupsList = true;
        _beforeLoadBackups = () => _importBackup(UserData.selectedBackupFile!);
      });
    }
  }

  void _export() async {
    if (!UserData.isSignedIn) return;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: Sizing.blockSizeVertical * 2.0,
                  left: Sizing.blockSizeHorizontal * 5.0,
                ),
                child: Text(
                  'Export',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.clear),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Exports will be saved to ${Globals.driveBackupFolderName}'
                ' on your Google Drive.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              )
            ],
          ),
          actions: [
            Center(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.upload),
                    onPressed: () {
                      final text = _textController.text.trim();
                      if (text.isNotEmpty) {
                        Navigator.of(context).pop();
                        setState(
                          () {
                            _refreshBackupsList = true;
                            _beforeLoadBackups =
                                () => UserData.createBackup(text);
                            _textController.clear();
                          },
                        );
                      }
                    },
                  ),
                  label: const Text('Export File Name'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onClearBackup(drive_api.File file) async {
    if (file.id == null) return;
    if (await getConfirmation(context, 'Delete Backup',
        '${file.name ?? 'This file'} will be permanently deleted.')) {
      _beforeLoadBackups = () => UserData.deleteFile(file);
      setState(() {
        _refreshBackupsList = true;
      });
    }
  }

  Widget _buildScaffoldBody() {
    if (!UserData.isSignedIn) return Container();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              UserData.account!.email,
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
        SizedBox(
          height: Sizing.blockSizeVertical * 3.0,
        ),
        _buildGoogleDriveBackupOptions(),
      ],
    );
  }

  Widget _buildGoogleDriveBackupOptions() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Backups',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: Sizing.blockSizeVertical * 3.0,
          ),
          _refreshBackupsList
              ? FutureBuilder(
                  future: _loadBackupFilesFromDrive(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return _buildBackupFilesListView();
                    }

                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                      ),
                    );
                  },
                )
              : _buildBackupFilesListView(),
        ],
      ),
    );
  }

  Future<void> _loadBackupFilesFromDrive() async {
    if (!UserData.isSignedIn) return;

    if (_beforeLoadBackups != null) {
      await _beforeLoadBackups!();
      _beforeLoadBackups = null;
    }

    await UserData.loadBackups();

    _refreshBackupsList = false;
  }

  Widget _buildBackupFilesListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: UserData.backupFiles.length,
        itemBuilder: (context, index) {
          return RadioListTile<String?>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.only(
              bottom: Sizing.blockSizeVertical * 1.0,
            ),
            selected: UserData.selectedBackupFile?.id ==
                UserData.backupFiles[index].id,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  UserData.backupFiles[index].name?.replaceAll('.json', '') ??
                      '',
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                IconButton(
                  onPressed: () => _onClearBackup(UserData.backupFiles[index]),
                  icon: Icon(
                    Icons.clear,
                    size: Sizing.icon3,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              UserData.backupFiles[index].createdTime == null
                  ? ''
                  : DateFormat.yMMMMd()
                      .format(UserData.backupFiles[index].createdTime!),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
            value: UserData.backupFiles[index].id,
            groupValue: UserData.selectedBackupFile?.id,
            onChanged: (String? id) {
              setState(() {
                _refreshBackupsList = false;
                UserData.selectedBackupFile = UserData.backupFiles[index];
              });
            },
            // TODO: move color into ThemeData
            selectedTileColor: const Color(0xFF02A1F9),
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    if (UserData.isSignedIn) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Import
          GradientButton(
            onPressed: _import,
            width: Sizing.screenWidth * .4,
            height: Sizing.blockSizeVertical * 8.5,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Import',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  width: Sizing.blockSizeHorizontal * 5.0,
                ),
                Icon(
                  Icons.download,
                  size: Sizing.blockSizeHorizontal * 7.0,
                ),
              ],
            ),
          ),

          // Export
          GradientButton(
            onPressed: _export,
            width: Sizing.screenWidth * .4,
            height: Sizing.blockSizeVertical * 8.5,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  width: Sizing.blockSizeHorizontal * 5.0,
                ),
                Icon(
                  Icons.add_to_drive_outlined,
                  size: Sizing.blockSizeHorizontal * 7.0,
                ),
              ],
            ),
          ),
        ],
      );
    }
    return GradientButton(
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
    );
  }

  Future<void> _importBackup(drive_api.File file) async {
    final media = await UserData.getBackup(file);
    if (media != null) {
      String serializedUserDataJson = '';
      media.stream.map((asciiCodes) => String.fromCharCodes(asciiCodes)).listen(
            (event) {
              serializedUserDataJson += event;
            },
            onError: (error) {
              displayError(context, error.toString());
            },
            cancelOnError: true,
            onDone: () async {
              try {
                final userDataJson = jsonDecode(serializedUserDataJson);
                if (userDataJson == null) {
                  throw Exception('Failed to decode backup json due to '
                      'improper formatting');
                }
                await PogoData.importUserDataFromJson(userDataJson);
                String message;
                if (file.name == null) {
                  message = 'The import was successfully completed.';
                } else {
                  message = 'The import from '
                      '${file.name?.replaceFirst('.json', '') ?? 'the backup file'}'
                      ' was successfully completed.';
                }
                if (mounted) {
                  await processFinished(
                    context,
                    'Import Complete',
                    message,
                  );
                }
              } catch (error) {
                if (mounted) {
                  displayError(context, error.toString());
                }
              }
            },
          );
    }
  }

  @override
  void initState() {
    super.initState();
    _trySignInSilently();
  }

  @override
  void dispose() {
    _textController.dispose();
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
      child: Scaffold(
        body: _buildScaffoldBody(),
        floatingActionButton: _buildFloatingActionButtons(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class GoogleAuthClient extends BaseClient {
  final Map<String, String> _headers;

  final Client _client = Client();

  GoogleAuthClient(this._headers);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
