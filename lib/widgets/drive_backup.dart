// dart
import 'dart:ui';
import 'dart:convert';

// flutter
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// packages
import 'package:sign_in_button/sign_in_button.dart';
import 'package:intl/intl.dart';

// pogo teams
import 'dialogs.dart';
import '../utils/extensions.dart';
import '../modules/pogo_repository.dart';
import '../app/ui/sizing.dart';
import '../modules/google_drive_repository.dart';
import '../pages/drive_backups.dart';

class DriveBackup extends StatefulWidget {
  const DriveBackup({super.key});

  @override
  State<DriveBackup> createState() => _DriveBackupState();
}

class _DriveBackupState extends State<DriveBackup> {
  late Widget _syncBackup;

  Future _signIn() async {
    if (await GoogleDriveRepository.signIn()) {
      setState(() {});
    }
  }

  Future _signOut() async {
    await GoogleDriveRepository.signOut();
    setState(() {});
  }

  Future _onLinkBackupFilePressed() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            insetPadding: EdgeInsets.only(
              left: Sizing.blockSizeHorizontal * 2.0,
              right: Sizing.blockSizeHorizontal * 2.0,
            ),
            backgroundColor: Colors.transparent,
            child: const DriveBackups(),
          ),
        );
      },
    );
    setState(() {});
  }

  Future _onSyncBackup() async {
    if (!GoogleDriveRepository.isSignedIn) return;

    setState(() {
      _syncBackup = const CircularProgressIndicator(
        color: Colors.white,
      );
    });

    final Map<String, dynamic> backupJson =
        await PogoRepository.exportUserDataToJson();
    final String backupJsonEncoded = jsonEncode(backupJson);

    GoogleDriveRepository.updateLinkedBackup(backupJsonEncoded).then((_) {
      setState(() {
        _syncBackup = _SyncButton(onPressed: _onSyncBackup);
      });
    }).onError((error, stackTrace) {
      setState(() {
        _syncBackup = _SyncButton(onPressed: _onSyncBackup);
      });

      displayError(context, error.toString());
    });
  }

  @override
  void initState() {
    _syncBackup = _SyncButton(onPressed: _onSyncBackup);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (GoogleDriveRepository.isSignedIn) {
      return SizedBox(
        height: Sizing.scrnheight * .3,
        child: DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: Sizing.scrnwidth * .2,
                      height: Sizing.scrnwidth * .2,
                      child: GoogleUserCircleAvatar(
                        identity: GoogleDriveRepository.account!,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (GoogleDriveRepository.account!.displayName != null)
                        Text(
                          GoogleDriveRepository.account!.displayName!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      Text(
                        GoogleDriveRepository.account!.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              if (GoogleDriveRepository.linkedBackupFile != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'linked backup: ${GoogleDriveRepository.linkedBackupFile!.nameWithoutExtension}\nlast modified: ${DateFormat.yMMMMd().add_jm().format(GoogleDriveRepository.linkedBackupFile!.modifiedTime!.toLocal())}',
                    style: Theme.of(context).textTheme.bodySmall?.apply(
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (GoogleDriveRepository.linkedBackupFile != null)
                    _syncBackup,
                  ElevatedButton(
                    onPressed: _onLinkBackupFilePressed,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Backups  ',
                          style: Theme.of(context).textTheme.bodySmall?.apply(
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                        Icon(
                          Icons.backup_rounded,
                          color: Theme.of(context).iconTheme.color,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return DrawerHeader(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(
              Buttons.google,
              text: 'Sign in with Google',
              onPressed: _signIn,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '*Backup your data via Google Drive ',
                  style: Theme.of(context).textTheme.bodySmall?.apply(
                        fontStyle: FontStyle.italic,
                      ),
                ),
                const Icon(Icons.backup_rounded)
              ],
            ),
          ],
        ),
      );
    }
  }
}

class _SyncButton extends StatelessWidget {
  const _SyncButton({
    required this.onPressed,
  });

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Icon(
        Icons.sync_rounded,
        color: Theme.of(context).iconTheme.color,
        size: Sizing.icon3,
      ),
    );
  }
}
