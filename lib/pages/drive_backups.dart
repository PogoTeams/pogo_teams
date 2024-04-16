// Dart
import 'dart:async';
import 'dart:convert';

// Flutter
import 'package:flutter/material.dart';

// Packages
import 'package:googleapis/drive/v3.dart' as drive_api;
import 'package:intl/intl.dart';

// Local Imports
import '../widgets/dialogs.dart';
import '../modules/data/globals.dart';
import '../modules/data/pogo_repository.dart';
import '../modules/data/google_drive_repository.dart';
import '../modules/ui/sizing.dart';
import '../widgets/buttons/gradient_button.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A Google drive integration allowing the user to backup and restore their data
using a Google account.
-------------------------------------------------------------------------------
*/

class DriveBackups extends StatefulWidget {
  const DriveBackups({Key? key}) : super(key: key);

  @override
  _DriveBackupsState createState() => _DriveBackupsState();
}

class _DriveBackupsState extends State<DriveBackups> {
  final TextEditingController _textController = TextEditingController();
  bool _refreshBackupsList = false;
  Function()? _beforeLoadBackups;

  Future<void> _trySignInSilently() async {
    if (await GoogleDriveRepository.trySignInSilently()) {
      setState(() {
        _refreshBackupsList = true;
      });
    }
  }

  Future<void> _signIn() async {
    if (await GoogleDriveRepository.signIn()) {
      setState(() {
        _refreshBackupsList = true;
      });
    }
  }

  Future<void> _signOut() async {
    await GoogleDriveRepository.signOut();
    setState(() {
      _refreshBackupsList = false;
    });
  }

  Future<void> _onRestoreBackup() async {
    if (GoogleDriveRepository.linkedBackupFile == null ||
        GoogleDriveRepository.linkedBackupFile?.id == null) return;

    bool restore = false;
    bool clearAndRestore = false;

    final options = <Widget>[
      TextButton(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.titleLarge,
        ),
        child: Text(
          'Clear All Data & Restore Backup',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        onPressed: () {
          clearAndRestore = true;
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.titleLarge,
        ),
        child: Text(
          'Restore Backup',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        onPressed: () {
          restore = true;
          Navigator.of(context).pop();
        },
      ),
    ];

    await showOptions(
        context,
        'Download Backup',
        'All data will be imported from ${GoogleDriveRepository.linkedBackupFile?.name ?? 'this file'}.',
        options);

    if (restore || clearAndRestore) {
      setState(() {
        _refreshBackupsList = true;
        _beforeLoadBackups = () => _restoreBackup(
              GoogleDriveRepository.linkedBackupFile!,
              clearAndRestore,
            );
      });
    }
  }

  Future<void> _onCreateBackup() async {
    if (!GoogleDriveRepository.isSignedIn) return;
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
                    onPressed: () async {
                      final filename = _textController.text.trim();
                      if (filename.isNotEmpty) {
                        Navigator.of(context).pop();

                        final Map<String, dynamic> backupJson =
                            await PogoRepository.exportUserDataToJson();
                        final String backupJsonEncoded = jsonEncode(backupJson);

                        setState(
                          () {
                            _refreshBackupsList = true;
                            _beforeLoadBackups =
                                () => GoogleDriveRepository.createBackup(
                                      filename,
                                      backupJsonEncoded,
                                    );
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

  Future<void> _onDeleteBackup(drive_api.File file) async {
    if (file.id == null) return;
    if (await getConfirmation(context, 'Delete Backup',
        '${file.name ?? 'This file'} will be permanently deleted.')) {
      _beforeLoadBackups = () => GoogleDriveRepository.deleteBackup(file.id!);
      setState(() {
        _refreshBackupsList = true;
      });
    }
  }

  Widget _buildScaffoldBody() {
    if (!GoogleDriveRepository.isSignedIn) return Container();
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
    if (!GoogleDriveRepository.isSignedIn) return;

    if (_beforeLoadBackups != null) {
      await _beforeLoadBackups!();
      _beforeLoadBackups = null;
    }

    await GoogleDriveRepository.loadBackups();

    _refreshBackupsList = false;
  }

  Widget _buildBackupFilesListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: GoogleDriveRepository.backupFiles.length,
        itemBuilder: (context, index) {
          return RadioListTile<String?>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.only(
              bottom: Sizing.blockSizeVertical * 1.0,
            ),
            selected: GoogleDriveRepository.linkedBackupFile?.id ==
                GoogleDriveRepository.backupFiles[index].id,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  GoogleDriveRepository.backupFiles[index].name
                          ?.replaceAll('.json', '') ??
                      '',
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                IconButton(
                  onPressed: () =>
                      _onDeleteBackup(GoogleDriveRepository.backupFiles[index]),
                  icon: Icon(
                    Icons.clear,
                    size: Sizing.icon3,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              GoogleDriveRepository.backupFiles[index].createdTime == null
                  ? ''
                  : DateFormat.yMMMMd().format(
                      GoogleDriveRepository.backupFiles[index].createdTime!),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
            value: GoogleDriveRepository.backupFiles[index].id,
            groupValue: GoogleDriveRepository.linkedBackupFile?.id,
            onChanged: (String? id) {
              setState(() {
                _refreshBackupsList = false;
                GoogleDriveRepository.linkedBackupFile =
                    GoogleDriveRepository.backupFiles[index];
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
    if (GoogleDriveRepository.isSignedIn) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Import
          GradientButton(
            onPressed: _onRestoreBackup,
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
                  'Restore Backup',
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
            onPressed: _onCreateBackup,
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

  Future<void> _restoreBackup(drive_api.File file, bool clearAllData) async {
    if (file.id == null) return;
    final media = await GoogleDriveRepository.getBackup(file.id!);
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

                if (clearAllData) {
                  await PogoRepository.clearUserData();
                }

                await PogoRepository.importUserDataFromJson(userDataJson);
                String message;
                if (file.name == null) {
                  message = 'The backup was successfully restored.';
                } else {
                  message = 'The backup file '
                      '${file.name?.replaceFirst('.json', '') ?? ''} '
                      'was successfully completed.';
                }
                if (mounted) {
                  await processFinished(
                    context,
                    'Backup Restored',
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
    return Column(
      children: [
        _buildScaffoldBody(),
        _buildFloatingActionButtons(),
      ],
    );
  }
}
