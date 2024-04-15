// Dart
import 'dart:async';
import 'dart:convert';

// Packages
import 'package:googleapis/drive/v3.dart' as drive_api;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:hive/hive.dart';

// Local Imports
import 'globals.dart';
import 'pogo_data.dart';

class UserData {
  static late final Box localUserSettings;

  static List<drive_api.File> backupFiles = [];

  static GoogleSignInAccount? account;
  static bool get isSignedIn => account != null;

  static drive_api.DriveApi? _drive;
  static Future<drive_api.DriveApi> get drive async {
    _drive ??= drive_api.DriveApi(GoogleAuthClient(await account!.authHeaders));
    return _drive!;
  }

  static drive_api.File? selectedBackupFile;
  static String? backupFolderId;

  static Future<void> init() async {
    localUserSettings = await Hive.openBox('localUserSettings');
  }

  static Future<bool> trySignInSilently() async {
    final googleSignIn =
        GoogleSignIn.standard(scopes: [drive_api.DriveApi.driveFileScope]);
    account = await googleSignIn.signInSilently();

    return isSignedIn;
  }

  static Future<bool> signIn() async {
    final googleSignIn =
        GoogleSignIn.standard(scopes: [drive_api.DriveApi.driveFileScope]);
    account = await googleSignIn.signIn();

    return isSignedIn;
  }

  static Future<void> signOut() async {
    account = null;
    backupFiles.clear();
    selectedBackupFile = null;
    backupFolderId = null;
  }

  static Future<drive_api.Media?> getBackup(drive_api.File file) async {
    if (!isSignedIn) return null;

    return await (await drive).files.get(
          file.id!,
          downloadOptions: drive_api.DownloadOptions.fullMedia,
        ) as drive_api.Media?;
  }

  static Future<bool> tryFindDriveFolder() async {
    final List<drive_api.File>? files = (await (await drive).files.list(
              q: 'appProperties has { key=\'pogo_teams_backup_id\' and'
                  ' value=\'${Globals.driveBackupFolderGuid}\' }',
            ))
        .files;

    if (files != null && files.isNotEmpty) {
      backupFolderId = files.first.id;
    }

    return backupFolderId != null;
  }

  static Future<void> loadOrCreateBackupFolder() async {
    if (!await tryFindDriveFolder()) {
      // Create a new backup folder
      final drive_api.File driveFolder = drive_api.File()
        ..createdTime = DateTime.now()
        ..name = Globals.driveBackupFolderName
        ..appProperties = {
          'pogo_teams_backup_id': Globals.driveBackupFolderGuid,
        }
        ..mimeType = 'application/vnd.google-apps.folder';
      final drive_api.File createdFolder =
          await (await drive).files.create(driveFolder);
      backupFolderId = createdFolder.id;
    }
  }

  static Future<void> createBackup(String filename) async {
    await UserData.loadOrCreateBackupFolder();
    if (UserData.backupFolderId == null) return;

    drive_api.File writeFile = drive_api.File()
      ..createdTime = DateTime.now()
      ..name = '$filename.json';
    writeFile.parents = [UserData.backupFolderId!];

    final Map<String, dynamic> userExportJson =
        await PogoData.exportUserDataToJson();
    final String userExportJsonEncoded = jsonEncode(userExportJson);

    final stream = Future.value(userExportJsonEncoded.codeUnits)
        .asStream()
        .asBroadcastStream();

    await (await drive).files.create(
          writeFile,
          uploadMedia: drive_api.Media(
            stream,
            userExportJsonEncoded.length,
          ),
        );
  }

  static Future<void> deleteFile(drive_api.File file) async {
    await (await drive).files.delete(file.id!);
    selectedBackupFile = null;
  }

  static Future<void> loadBackups() async {
    if (backupFolderId != null || await tryFindDriveFolder()) {
      selectedBackupFile = null;
      backupFiles = (await (await drive).files.list(
                  q: '\'$backupFolderId\' in parents',
                  $fields: 'files(id,name,createdTime)',
                  orderBy: 'createdTime'))
              .files ??
          [];
    }
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
