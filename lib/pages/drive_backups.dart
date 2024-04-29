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
import '../modules/globals.dart';
import '../modules/pogo_repository.dart';
import '../modules/google_drive_repository.dart';
import '../app/ui/sizing.dart';
import '../widgets/buttons/gradient_button.dart';
import '../utils/extensions.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A Google drive integration allowing the user to backup and restore their data
using a Google account.
-------------------------------------------------------------------------------
*/

class DriveBackups extends StatefulWidget {
  const DriveBackups({super.key});

  @override
  _DriveBackupsState createState() => _DriveBackupsState();
}

class _DriveBackupsState extends State<DriveBackups> {
  final TextEditingController _textController = TextEditingController();
  bool _refreshBackupsList = true;
  Function()? _beforeLoadBackups;

  Future<void> _onRestoreBackup() async {
    if (GoogleDriveRepository.linkedBackupFile == null ||
        GoogleDriveRepository.linkedBackupFile?.id == null) return;

    if (await getConfirmation(context, 'Restore from Backup',
        'All data will be cleared and restored from ${GoogleDriveRepository.linkedBackupFile!.nameWithoutExtension ?? 'this file'}.')) {
      setState(() {
        _refreshBackupsList = true;
        _beforeLoadBackups = () => _restoreBackup(
              GoogleDriveRepository.linkedBackupFile!,
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
                  top: Sizing.screenHeight(context) * .02,
                  left: Sizing.screenWidth(context) * .05,
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
    return Expanded(
      child: Column(
        children: [
          Text(
            GoogleDriveRepository.account!.email,
            style: Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: Sizing.screenHeight(context) * .03,
          ),
          _buildFloatingActionButtons(),
          SizedBox(
            height: Sizing.screenHeight(context) * .03,
          ),
          _buildGoogleDriveBackupOptions(),
        ],
      ),
    );
  }

  Widget _buildGoogleDriveBackupOptions() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _refreshBackupsList
              ? FutureBuilder(
                  future: _loadBackupFilesFromDrive(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return _buildBackupFilesListView();
                    }

                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.cyan),
                        ),
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
              bottom: Sizing.screenHeight(context) * .01,
            ),
            selected: GoogleDriveRepository.linkedBackupFile?.id ==
                GoogleDriveRepository.backupFiles[index].id,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  GoogleDriveRepository
                          .backupFiles[index].nameWithoutExtension ??
                      '',
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                IconButton(
                  onPressed: () =>
                      _onDeleteBackup(GoogleDriveRepository.backupFiles[index]),
                  icon: const Icon(
                    Icons.clear,
                    size: Sizing.icon3,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              GoogleDriveRepository.backupFiles[index].modifiedTime == null
                  ? ''
                  : DateFormat.yMMMMd().add_jm().format(GoogleDriveRepository
                      .backupFiles[index].modifiedTime!
                      .toLocal()),
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
            width: Sizing.screenWidth(context) * .4,
            height: Sizing.screenHeight(context) * .085,
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
                  'Restore  ',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Icon(
                  Icons.settings_backup_restore_rounded,
                ),
              ],
            ),
          ),

          // Export
          GradientButton(
            onPressed: _onCreateBackup,
            width: Sizing.screenWidth(context) * .4,
            height: Sizing.screenHeight(context) * .085,
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
                  'New  ',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Icon(
                  Icons.add_to_drive_outlined,
                ),
              ],
            ),
          ),
        ],
      );
    }
    return GradientButton(
      onPressed: () {},
      width: Sizing.screenWidth(context) * .85,
      height: Sizing.screenHeight(context) * .085,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sign In  ',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Icon(
            Icons.login,
          ),
        ],
      ),
    );
  }

  Future<void> _restoreBackup(drive_api.File file) async {
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

                await PogoRepository.clearUserData();

                await PogoRepository.importUserDataFromJson(userDataJson);
                String message;
                if (file.name == null) {
                  message = 'The backup was successfully restored.';
                } else {
                  message = 'The backup file '
                      '${file.nameWithoutExtension ?? ''} '
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
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: Sizing.screenHeight(context) * .02,
          ),
          _buildScaffoldBody(),
          MaterialButton(
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () => Navigator.pop(context),
            height: Sizing.screenHeight(context) * .07,
            child: const Center(
              child: Icon(
                Icons.clear,
                size: Sizing.icon2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
