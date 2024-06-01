// Dart
import 'dart:async';

// Packages
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive_api;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:hive/hive.dart';

// Local Imports
import 'globals.dart';

class GoogleDriveRepository {
  static late final Box _cache;

  static List<drive_api.File> backupFiles = [];

  static GoogleSignInAccount? account;
  static bool get isSignedIn => account != null;

  static late final GoogleSignIn googleSignIn;

  static drive_api.File? _linkedBackupFile;
  static drive_api.File? get linkedBackupFile {
    return _linkedBackupFile;
  }

  static set linkedBackupFile(drive_api.File? value) {
    _linkedBackupFile = value;
    putLinkedBackupFile();
  }

  static String? backupFolderId;

  static Future<void> init() async {
    _cache = await Hive.openBox('googleDriveRepositoryCache');
    googleSignIn =
        GoogleSignIn.standard(scopes: [drive_api.DriveApi.driveFileScope]);

    if (kIsWeb) {
      googleSignIn.onCurrentUserChanged.listen(_onCurrentUserChanged);
    }

    await trySignInSilently();
  }

  static void _onCurrentUserChanged(GoogleSignInAccount? newAccount) {
    account = newAccount;
  }

  static Future<void> tryLoadLinkedBackupFile() async {
    if (!isSignedIn || backupFiles.isEmpty) return;

    String? id = await _cache.get('${account?.id}_linked_backup_file_id');

    if (id != null) {
      _linkedBackupFile = backupFiles.firstWhere((file) => file.id == id,
          orElse: () => backupFiles.first);
    }
  }

  static Future<void> putLinkedBackupFile() async {
    if (!isSignedIn) return;

    await _cache.put(
        '${account?.id}_linked_backup_file_id', _linkedBackupFile?.id);
  }

  static Future<drive_api.DriveApi> getDrive() async {
    return drive_api.DriveApi(GoogleAuthClient(await account!.authHeaders));
  }

  static Future<bool> trySignInSilently() async {
    if (kIsWeb) return false;

    account = await googleSignIn.signInSilently();

    if (isSignedIn) {
      await loadBackups();
    }

    return isSignedIn;
  }

  static Future<bool> signIn() async {
    account = await googleSignIn.signIn();

    if (isSignedIn) {
      await loadBackups();
    }

    return isSignedIn;
  }

  static Future<void> signOut() async {
    account = null;
    backupFiles.clear();
    _linkedBackupFile = null;
    backupFolderId = null;
  }

  static Future<bool> tryFindDriveFolder() async {
    final drive = await getDrive();
    final List<drive_api.File>? files = (await drive.files.list(
      q: 'appProperties has { key=\'pogo_teams_backup_id\' and'
          ' value=\'${Globals.driveBackupFolderGuid}\' }',
    ))
        .files;

    // TODO: let the user choose a folder from their drive
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

      final drive = await getDrive();
      final drive_api.File createdFolder =
          await drive.files.create(driveFolder);
      backupFolderId = createdFolder.id;
    }
  }

  static Future<void> loadBackups() async {
    if (backupFolderId != null || await tryFindDriveFolder()) {
      final drive = await getDrive();
      backupFiles = (await drive.files.list(
                  q: '\'$backupFolderId\' in parents',
                  $fields: 'files(id,name,createdTime,modifiedTime)',
                  orderBy: 'modifiedTime'))
              .files ??
          [];

      await tryLoadLinkedBackupFile();
    }
  }

  static Future<drive_api.Media?> getBackup(String id) async {
    if (!isSignedIn) return null;

    final drive = await getDrive();
    return await drive.files.get(
      id,
      downloadOptions: drive_api.DownloadOptions.fullMedia,
    ) as drive_api.Media?;
  }

  static Future<void> createBackup(
    String filename,
    String backupJsonEncoded,
  ) async {
    await GoogleDriveRepository.loadOrCreateBackupFolder();
    if (GoogleDriveRepository.backupFolderId == null) return;

    final now = DateTime.now();
    drive_api.File writeFile = drive_api.File()
      ..createdTime = now
      ..modifiedTime = now
      ..name = '$filename.json';
    writeFile.parents = [GoogleDriveRepository.backupFolderId!];

    final stream = Future.value(backupJsonEncoded.codeUnits)
        .asStream()
        .asBroadcastStream();

    final drive = await getDrive();
    await drive.files.create(
      writeFile,
      uploadMedia: drive_api.Media(
        stream,
        backupJsonEncoded.length,
      ),
    );
  }

  static Future updateLinkedBackup(
    String backupJsonEncoded,
  ) async {
    if (!isSignedIn || linkedBackupFile?.id == null) return;

    final stream = Future.value(backupJsonEncoded.codeUnits)
        .asStream()
        .asBroadcastStream();

    drive_api.File writeFile = drive_api.File();

    final drive = await getDrive();
    await drive.files.update(
      writeFile,
      linkedBackupFile!.id!,
      uploadMedia: drive_api.Media(
        stream,
        backupJsonEncoded.length,
      ),
    );

    await loadBackups();
  }

  static Future<void> deleteBackup(String id) async {
    final drive = await getDrive();
    await drive.files.delete(id);
    linkedBackupFile = null;
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
