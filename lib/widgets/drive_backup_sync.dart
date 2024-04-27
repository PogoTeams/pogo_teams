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

class DriveBackupSync extends StatefulWidget {
  const DriveBackupSync({super.key});

  @override
  State<DriveBackupSync> createState() => _DriveBackupSyncState();
}

class _DriveBackupSyncState extends State<DriveBackupSync> {
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
              left: Sizing.screenWidth(context) * .2,
              right: Sizing.screenWidth(context) * .2,
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
      _syncBackup = const _SyncButton(onPressed: null);
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
    return SizedBox(
      height: Sizing.screenHeight(context, oriented: true) * .27,
      width: double.infinity,
      child: GoogleDriveRepository.isSignedIn
          ? DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: Sizing.screenHeight(context, oriented: true) * .1,
                      height: Sizing.screenHeight(context, oriented: true) * .1,
                      child: GoogleUserCircleAvatar(
                        identity: GoogleDriveRepository.account!,
                      ),
                    ),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (GoogleDriveRepository.linkedBackupFile != null)
                        _syncBackup,
                      ElevatedButton(
                        onPressed: _onLinkBackupFilePressed,
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(const CircleBorder()),
                        ),
                        child: Icon(
                          Icons.backup_rounded,
                          color: Theme.of(context).iconTheme.color,
                          size: Sizing.icon3,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _signOut,
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(const CircleBorder()),
                        ),
                        child: Icon(
                          Icons.logout,
                          color: Theme.of(context).iconTheme.color,
                          size: Sizing.icon3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignInButton(
                    Buttons.google,
                    text: 'Sign in with Google',
                    onPressed: _signIn,
                  ),
                  Text(
                    '*Backup your data via Google Drive',
                    style: Theme.of(context).textTheme.bodySmall?.apply(
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SyncButton extends StatefulWidget {
  const _SyncButton({
    required this.onPressed,
  });

  final void Function()? onPressed;

  @override
  State<_SyncButton> createState() => __SyncButtonState();
}

class __SyncButtonState extends State<_SyncButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onPressed == null) {
      _animationController.repeat();
    } else {
      _animationController.reset();
    }
    return ElevatedButton(
      onPressed: widget.onPressed ?? () {},
      style: ButtonStyle(
        shape: MaterialStateProperty.all(const CircleBorder()),
      ),
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: -1.0).animate(_animationController),
        child: Icon(
          Icons.sync_rounded,
          color: Theme.of(context).iconTheme.color,
          size: Sizing.icon3,
        ),
      ),
    );
  }
}
