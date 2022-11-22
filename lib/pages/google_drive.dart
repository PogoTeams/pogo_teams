// Dart
import 'dart:convert';
import 'dart:io';

// Flutter
import 'package:flutter/material.dart';

// Packages
import 'package:googleapis/drive/v3.dart' as driveApi;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:pogo_teams/widgets/pogo_text_field.dart';

// Local Imports
import '../modules/data/pogo_data.dart';
import '../modules/ui/sizing.dart';
import '../widgets/buttons/gradient_button.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class GoogleDrive extends StatefulWidget {
  const GoogleDrive({Key? key}) : super(key: key);

  @override
  _GoogleDriveState createState() => _GoogleDriveState();
}

class _GoogleDriveState extends State<GoogleDrive> {
  final TextEditingController _textController = TextEditingController();
  final String _driveFolderName = '__pogo_teams__';
  final String _exportFilename = 'pogo_teams_backup';
  String? _backupFolderId;
  List<driveApi.File> _existingBackupFiles = [];

  GoogleSignInAccount? _account;

  void _signIn() async {
    final googleSignIn =
        GoogleSignIn.standard(scopes: [driveApi.DriveApi.driveFileScope]);
    _account = await googleSignIn.signIn();
    setState(() {});
  }

  void _signOut() async {
    setState(() {
      _account = null;
    });
  }

  Future<String?> _tryFindFolderByName(driveApi.DriveApi drive) async {
    final driveApi.FileList filesList = await drive.files.list();
    if (filesList.files != null) {
      for (var file in filesList.files!) {
        if (file.name == _driveFolderName) {
          return file.id;
        }
      }
    }
    return null;
  }

  Future<void> _loadOrCreateBackupFolder(driveApi.DriveApi drive) async {
    if (_backupFolderId == null) {
      _backupFolderId = (await _tryFindFolderByName(drive));
      if (_backupFolderId == null) {
        final driveApi.File driveFolder = driveApi.File()
          ..name = _driveFolderName
          ..mimeType = 'application/vnd.google-apps.folder';
        final driveApi.File createdFolder =
            await drive.files.create(driveFolder);
        _backupFolderId = createdFolder.id;
      }
    }
  }

  void _tryCreateBackupFile() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    driveApi.File? writeFile;
    for (var file in _existingBackupFiles) {
      if (file.name == text + '.json') {
        if (await _getConfirmation('Backup Overwrite',
            'A file with the name $text already exists.\nWould you like to overwrite this file?')) {
          writeFile = file;
          break;
        } else {
          return;
        }
      }
    }

    writeFile ??= driveApi.File()..name = text + '.json';
    _writeUserDataToDrive(writeFile);
  }

  void _writeUserDataToDrive(driveApi.File writeFile) async {
    if (_account == null) return;
    final drive =
        driveApi.DriveApi(GoogleAuthClient(await _account!.authHeaders));

    await _loadOrCreateBackupFolder(drive);
    if (_backupFolderId == null) return;

    writeFile.parents = [_backupFolderId!];

    final Map<String, dynamic> userExportJson = await PogoData.userDataToJson();
    final String userExportJsonEncoded = jsonEncode(userExportJson);

    final stream = Future.value(userExportJsonEncoded.codeUnits)
        .asStream()
        .asBroadcastStream();

    final createdFile = await drive.files.create(
      writeFile,
      uploadMedia: driveApi.Media(
        stream,
        userExportJsonEncoded.length,
      ),
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Google Drive Backup Saved'),
          content: Text(
              'File name:\n${_backupFolderId == null ? '' : _driveFolderName + '/'}${createdFile.name}'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    setState(() {});
  }

  Widget _buildGoogleDriveBackupOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _textController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: _tryCreateBackupFile,
            ),
            label: const Text('New Backup'),
          ),
        ),
        SizedBox(
          height: Sizing.blockSizeVertical * 3.0,
        ),
        Text(
          'Existing Backups',
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: Sizing.blockSizeVertical * 3.0,
        ),
        FutureBuilder(
          future: _loadExistingBackupFiles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _buildExistingBackupsList();
            }

            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _loadExistingBackupFiles() async {
    if (_account == null) return;
    final drive =
        driveApi.DriveApi(GoogleAuthClient(await _account!.authHeaders));
    _backupFolderId = await _tryFindFolderByName(drive);
    if (_backupFolderId != null) {
      _existingBackupFiles =
          (await drive.files.list(q: '\'$_backupFolderId\' in parents'))
                  .files
                  ?.where((file) => file.name != null)
                  .toList() ??
              [];
    }
  }

  Widget _buildExistingBackupsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _existingBackupFiles.length,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _existingBackupFiles[index].name ?? '',
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () =>
                        _onDownloadBackup(_existingBackupFiles[index]),
                    icon: Icon(
                      Icons.download,
                      size: Sizing.icon3,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        _onOverwriteBackup(_existingBackupFiles[index]),
                    icon: Icon(
                      Icons.upload,
                      size: Sizing.icon3,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        _onClearBackup(_existingBackupFiles[index]),
                    icon: Icon(
                      Icons.clear,
                      size: Sizing.icon3,
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Future<bool> _getConfirmation(String title, String message) async {
    bool overwrite = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                overwrite = true;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return overwrite;
  }

  void _onDownloadBackup(driveApi.File file) async {
    if (file.id == null) return;
    if (await _getConfirmation('Download Backup',
        'All data will be imported from ${file.name ?? 'this file'}. The current local data will not be effected.\nWould you like to continue?')) {
      _importBackup(file);
    }
  }

  void _importBackup(driveApi.File file) async {
    final drive =
        driveApi.DriveApi(GoogleAuthClient(await _account!.authHeaders));
    final driveApi.Media? result = await drive.files.get(
      file.id!,
      downloadOptions: driveApi.DownloadOptions.fullMedia,
    ) as driveApi.Media?;
    if (result != null) {}
  }

  void _onOverwriteBackup(driveApi.File file) async {
    if (file.id == null) return;
    if (await _getConfirmation('Overwrite Backup',
        'This will overwrite ${file.name ?? 'this file'} with the current local data.\nWould you like to continue?')) {
      _writeUserDataToDrive(file);
      setState(() {});
    }
  }

  void _onClearBackup(driveApi.File file) async {
    if (file.id == null) return;
    if (await _getConfirmation('Delete Backup',
        '${file.name ?? 'This file'} will be permanently deleted.\nWould you like to continue?')) {
      final drive =
          driveApi.DriveApi(GoogleAuthClient(await _account!.authHeaders));
      await drive.files.delete(file.id!);
      setState(() {});
    }
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
        body: _buildGoogleDriveBackupOptions(),
        floatingActionButton: GradientButton(
          onPressed: _signIn,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign In',
                style: Theme.of(context).textTheme.headline6,
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
          width: Sizing.screenWidth * .85,
          height: Sizing.blockSizeVertical * 8.5,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(50),
          ),
        ),
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
