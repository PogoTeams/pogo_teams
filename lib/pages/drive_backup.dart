// Dart
import 'dart:async';
import 'dart:convert';

// Flutter
import 'package:flutter/material.dart';

// Packages
import 'package:googleapis/drive/v3.dart' as drive_api;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

// Local Imports
import '../modules/data/globals.dart';
import '../modules/data/pogo_data.dart';
import '../modules/ui/sizing.dart';
import '../widgets/buttons/gradient_button.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class DriveBackup extends StatefulWidget {
  const DriveBackup({Key? key}) : super(key: key);

  @override
  _DriveBackupState createState() => _DriveBackupState();
}

class _DriveBackupState extends State<DriveBackup> {
  final TextEditingController _textController = TextEditingController();
  String? _backupFolderId;
  drive_api.File? _selectedBackupFile;
  List<drive_api.File> _backupFiles = [];
  bool _refreshBackupsList = false;
  Function()? _beforeLoadBackupsList;

  GoogleSignInAccount? _account;
  bool get _signedIn => _account != null;

  void _trySignInSilently() async {
    final googleSignIn =
        GoogleSignIn.standard(scopes: [drive_api.DriveApi.driveFileScope]);
    _account = await googleSignIn.signInSilently();
    if (_signedIn) {
      _backupFolderId =
          await PogoData.getUserGoogldDriveFolderId(_account!.email);
      setState(() {
        _refreshBackupsList = true;
      });
    }
  }

  void _signIn() async {
    final googleSignIn =
        GoogleSignIn.standard(scopes: [drive_api.DriveApi.driveFileScope]);
    _account = await googleSignIn.signIn();
    if (_signedIn) {
      _backupFolderId =
          await PogoData.getUserGoogldDriveFolderId(_account!.email);
      setState(() {
        _refreshBackupsList = true;
      });
    }
  }

  void _signOut() async {
    setState(() {
      _backupFiles.clear();
      _refreshBackupsList = false;
      _account = null;
      _selectedBackupFile = null;
      _backupFolderId = null;
    });
  }

  void _import() async {
    if (_selectedBackupFile == null || _selectedBackupFile?.id == null) return;
    if (await _getConfirmation('Download Backup',
        'All data will be imported from ${_selectedBackupFile?.name ?? 'this file'}.')) {
      setState(() {
        _refreshBackupsList = true;
        _beforeLoadBackupsList = () => _importBackup(_selectedBackupFile!);
      });
    }
  }

  void _export() async {
    if (_account == null) return;
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
                  style: Theme.of(context).textTheme.headline6?.copyWith(
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
                'Exports will be saved to ${Globals.userBackupFolderName}'
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
                          setState(() {
                            _refreshBackupsList = true;
                            _beforeLoadBackupsList =
                                () => _writeBackupFileToDrive(text);
                            _textController.clear();
                          });
                        }
                      }),
                  label: const Text('Export File Name'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _writeBackupFileToDrive(String filename) async {
    drive_api.File writeFile = drive_api.File()..name = '$filename.json';
    final drive =
        drive_api.DriveApi(GoogleAuthClient(await _account!.authHeaders));

    await _loadOrCreateBackupFolder(drive);
    if (_backupFolderId == null) return;

    writeFile.parents = [_backupFolderId!];

    final Map<String, dynamic> userExportJson =
        await PogoData.userDataToExportJson();
    final String userExportJsonEncoded = jsonEncode(userExportJson);

    final stream = Future.value(userExportJsonEncoded.codeUnits)
        .asStream()
        .asBroadcastStream();

    await drive.files.create(
      writeFile,
      uploadMedia: drive_api.Media(
        stream,
        userExportJsonEncoded.length,
      ),
    );
  }

  Widget _buildScaffoldBody() {
    if (!_signedIn) return Container();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _account!.email,
              style: Theme.of(context).textTheme.headline6?.copyWith(
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
        Expanded(
          child: _buildGoogleDriveBackupOptions(),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButtons() {
    if (_signedIn) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Import
          GradientButton(
            onPressed: _import,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Import',
                  style: Theme.of(context).textTheme.headline6,
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
            width: Sizing.screenWidth * .4,
            height: Sizing.blockSizeVertical * 8.5,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(50),
            ),
          ),

          // Export
          GradientButton(
            onPressed: _export,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Export',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  width: Sizing.blockSizeHorizontal * 5.0,
                ),
                Icon(
                  Icons.upload,
                  size: Sizing.blockSizeHorizontal * 7.0,
                ),
              ],
            ),
            width: Sizing.screenWidth * .4,
            height: Sizing.blockSizeVertical * 8.5,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ],
      );
    }
    return GradientButton(
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
            _signedIn ? Icons.logout : Icons.login,
            size: Sizing.blockSizeHorizontal * 7.0,
          ),
        ],
      ),
      width: Sizing.screenWidth * .85,
      height: Sizing.blockSizeVertical * 8.5,
      borderRadius: BorderRadius.circular(10),
    );
  }

  Future<bool> _tryFindFolderIdByName(drive_api.DriveApi drive) async {
    if (_backupFolderId == null) {
      final drive_api.FileList filesList = await drive.files.list();
      if (filesList.files != null) {
        for (var file in filesList.files!) {
          if (file.name == Globals.userBackupFolderName) {
            _backupFolderId = file.id;
          }
        }
      }
    }

    if (_account != null) {
      await PogoData.updateUserGoogleDriveFolderId(
          _account!.email, _backupFolderId!);
    }
    return _backupFolderId != null;
  }

  Future<void> _loadOrCreateBackupFolder(drive_api.DriveApi drive) async {
    if (_backupFolderId == null && !await _tryFindFolderIdByName(drive)) {
      final drive_api.File driveFolder = drive_api.File()
        ..name = Globals.userBackupFolderName
        ..mimeType = 'application/vnd.google-apps.folder';
      final drive_api.File createdFolder =
          await drive.files.create(driveFolder);
      _backupFolderId = createdFolder.id;
    }
    if (_account != null) {
      await PogoData.updateUserGoogleDriveFolderId(
          _account!.email, _backupFolderId!);
    }
  }

  Widget _buildGoogleDriveBackupOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Existing Backups',
          style: Theme.of(context).textTheme.headline5,
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
                    return _buildExistingBackupsList();
                  }

                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                    ),
                  );
                },
              )
            : _buildExistingBackupsList(),
      ],
    );
  }

  Future<void> _loadBackupFilesFromDrive() async {
    if (_account == null) return;

    if (_beforeLoadBackupsList != null) {
      await _beforeLoadBackupsList!();
      _beforeLoadBackupsList = null;
    }

    final drive =
        drive_api.DriveApi(GoogleAuthClient(await _account!.authHeaders));
    await _tryFindFolderIdByName(drive);
    if (_backupFolderId != null) {
      _selectedBackupFile = null;
      _backupFiles =
          (await drive.files.list(q: '\'$_backupFolderId\' in parents'))
                  .files
                  ?.where((file) => file.name != null)
                  .toList() ??
              [];
    }

    _refreshBackupsList = false;
  }

  Widget _buildExistingBackupsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _backupFiles.length,
        itemBuilder: (context, index) {
          return RadioListTile<String?>(
            contentPadding: EdgeInsets.zero,
            selected: _selectedBackupFile == _backupFiles[index],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _backupFiles[index].name ?? '',
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
                IconButton(
                  onPressed: () => _onClearBackup(_backupFiles[index]),
                  icon: Icon(
                    Icons.clear,
                    size: Sizing.icon3,
                  ),
                ),
              ],
            ),
            value: _backupFiles[index].id,
            groupValue: _selectedBackupFile?.id,
            onChanged: (String? id) {
              setState(() {
                _refreshBackupsList = false;
                _selectedBackupFile = _backupFiles[index];
              });
            },
            selectedTileColor: Theme.of(context).selectedRowColor,
          );
        },
      ),
    );
  }

  Future<bool> _getConfirmation(
    String title,
    String message,
  ) async {
    bool confirmation = false;
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
                  title,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.headline6,
                ),
                child: Text(
                  'Continue',
                  style: Theme.of(context).textTheme.headline6,
                ),
                onPressed: () {
                  confirmation = true;
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
    return confirmation;
  }

  Future<void> _importBackup(drive_api.File file) async {
    if (_account == null) return;
    final drive =
        drive_api.DriveApi(GoogleAuthClient(await _account!.authHeaders));
    final drive_api.Media? result = await drive.files.get(
      file.id!,
      downloadOptions: drive_api.DownloadOptions.fullMedia,
    ) as drive_api.Media?;
    if (result != null) {
      String serializedUserDataJson = '';
      result.stream
          .map((asciiCodes) => String.fromCharCodes(asciiCodes))
          .listen(
            (event) {
              serializedUserDataJson += event;
            },
            onError: (error) {
              _displayError(error);
            },
            cancelOnError: true,
            onDone: () async {
              final userDataJson = jsonDecode(serializedUserDataJson);
              await PogoData.importUserDataFromJson(userDataJson);
            },
          );
    }
  }

  void _displayError(String error) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          title: Text(
            'Import Error',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'An unexpected error occured on import:\n$error',
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.headline6,
                ),
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.headline6,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _onClearBackup(drive_api.File file) async {
    if (file.id == null) return;
    if (await _getConfirmation('Delete Backup',
        '${file.name ?? 'This file'} will be permanently deleted.')) {
      final drive =
          drive_api.DriveApi(GoogleAuthClient(await _account!.authHeaders));
      _beforeLoadBackupsList = () => drive.files.delete(file.id!);
      setState(() {
        _selectedBackupFile = null;
        _refreshBackupsList = true;
      });
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
