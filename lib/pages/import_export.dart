// Dart
import 'dart:convert';
import 'dart:io';

// Flutter
import 'package:flutter/material.dart';

// Packages
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:file_picker/file_picker.dart';

// Local Imports
import '../modules/data/pogo_data.dart';
import '../modules/ui/sizing.dart';
import '../widgets/buttons/gradient_button.dart';
import '../widgets/gradient_divider.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class ImportExport extends StatefulWidget {
  const ImportExport({Key? key}) : super(key: key);

  @override
  _ImportExportState createState() => _ImportExportState();
}

class _ImportExportState extends State<ImportExport> {
  final TextEditingController _textController = TextEditingController();
  final String _exportFilename = 'pogo_teams_backup';

  void _import() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null) {
      File('${result.files.first.path}/pogo_teams_backup.json');
    }
  }

  void _export() async {
    String? path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      File writeFile = File('$path/$_exportFilename.json');
      final Map<String, dynamic> exportUserData =
          await PogoData.userDataToJson();
      await writeFile.writeAsString(jsonEncode(exportUserData));
    }
  }

  Widget _buildUserDataOverview() {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Teams',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              width: Sizing.blockSizeHorizontal * 3.0,
            ),
            Text(
              '0',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        SizedBox(
          height: Sizing.blockSizeVertical * 3.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Opponents',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              width: Sizing.blockSizeHorizontal * 3.0,
            ),
            Text(
              '0',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        SizedBox(
          height: Sizing.blockSizeVertical * 3.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Win Rate',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              width: Sizing.blockSizeHorizontal * 3.0,
            ),
            Text(
              '0',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        SizedBox(
          height: Sizing.blockSizeVertical * 3.0,
        ),
        const GradientDivider(),
      ],
    );
  }

  Widget _buildImportExportButtons() {
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
          width: Sizing.screenWidth * .44,
          height: Sizing.blockSizeVertical * 8.5,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
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
            topLeft: Radius.circular(20),
            topRight: Radius.circular(50),
            bottomRight: Radius.circular(50),
            bottomLeft: Radius.circular(20),
          ),
        ),
      ],
    );
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
    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.blockSizeVertical * 2.0,
        left: Sizing.blockSizeHorizontal * 2.0,
        right: Sizing.blockSizeHorizontal * 2.0,
      ),
      child: Scaffold(
        body: _buildUserDataOverview(),
        floatingActionButton: _buildImportExportButtons(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
