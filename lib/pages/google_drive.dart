// Dart
import 'dart:convert';

// Flutter
import 'package:flutter/material.dart';

// Packages
import 'package:googleapis/drive/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

// Local Imports
import '../modules/data/pogo_data.dart';
import '../modules/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
This screen will display a list of rankings based on selected cup, and
category. These categories and ranking information are all currently used from
The PvPoke model.
-------------------------------------------------------------------------------
*/

class GoogleDrive extends StatefulWidget {
  const GoogleDrive({Key? key}) : super(key: key);

  @override
  _GoogleDriveState createState() => _GoogleDriveState();
}

class _GoogleDriveState extends State<GoogleDrive> {
  final String _driveFolderName = '__pogo_teams__';

  void _authenticateUser() async {
    final googleSignIn =
        GoogleSignIn.standard(scopes: [DriveApi.driveFileScope]);
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account != null) {
      final drive = DriveApi(GoogleAuthClient(await account.authHeaders));

      String? folderId;
      final FileList filesList = await drive.files.list();
      if (filesList.files != null) {
        for (var file in filesList.files!) {
          if (file.name == _driveFolderName) {
            folderId = file.id;
          }
        }
      }

      if (folderId == null) {
        final File driveFolder = File()
          ..name = _driveFolderName
          ..mimeType = 'application/vnd.google-apps.folder';
        final createdFolder = await drive.files.create(driveFolder);
        folderId = createdFolder.id;
      }

      final backupFile = File()..name = 'backup.json';
      if (folderId != null) {
        backupFile.parents = [folderId];
      }

      final Map<String, dynamic> userExportJson =
          await PogoData.userDataToJson();
      final String userExportJsonEncoded = jsonEncode(userExportJson);

      final stream = Future.value(userExportJsonEncoded.codeUnits)
          .asStream()
          .asBroadcastStream();

      final savedDriveFile = await drive.files.create(
        backupFile,
        uploadMedia: Media(
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
                'File name:\n${folderId == null ? '' : _driveFolderName + '/'}${savedDriveFile.name}'),
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
    }
  }

  @override
  void initState() {
    super.initState();
    _authenticateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.blockSizeVertical * 2.0,
      ),
      child: Column(),
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
