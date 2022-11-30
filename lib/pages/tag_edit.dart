// Flutter
import 'package:flutter/material.dart';

// Packages
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// Local Imports
import '../modules/ui/sizing.dart';
import '../pogo_objects/tag.dart';
import '../widgets/buttons/exit_button.dart';
import '../widgets/dialogs.dart';
import '../modules/data/pogo_data.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class TagEdit extends StatefulWidget {
  const TagEdit({
    Key? key,
    this.tag,
  }) : super(key: key);

  final Tag? tag;

  @override
  _TagEditState createState() => _TagEditState();
}

class _TagEditState extends State<TagEdit> {
  final TextEditingController _textController = TextEditingController();
  Color _selectedColor = Colors.black;

  Widget _buildFloatingActionButtons() {
    return SizedBox(
      width: Sizing.screenWidth * .87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cancel exit button
          ExitButton(
            key: UniqueKey(),
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: const Color.fromARGB(255, 239, 83, 80),
          ),

          // Confirm exit button
          ExitButton(
            key: UniqueKey(),
            onPressed: _onSave,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }

  void _onSave() async {
    if (PogoData.tagNameExists(_textController.text)) {
      displayMessageOK(
        context,
        'Invalid Tag Name',
        'The tag name "${_textController.text}" already exists.',
      );
    } else {
      PogoData.updateTagSync(Tag(
        name: _textController.text,
        uiColor: _selectedColor.value.toRadixString(10),
      ));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Sizing.blockSizeHorizontal * 2.0,
          Sizing.blockSizeVertical * 10.0,
          Sizing.blockSizeHorizontal * 2.0,
          Sizing.blockSizeVertical * 10.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name', style: Theme.of(context).textTheme.headline6),

            SizedBox(
              height: Sizing.blockSizeVertical * 2.0,
            ),

            // Tag Name
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),

            SizedBox(
              height: Sizing.blockSizeVertical * 2.0,
            ),

            Text('Color', style: Theme.of(context).textTheme.headline6),

            SizedBox(
              height: Sizing.blockSizeVertical * 2.0,
            ),

            // Color
            ColorPicker(
              paletteType: PaletteType.hsl,
              enableAlpha: false,
              colorPickerWidth: Sizing.screenWidth,
              pickerAreaBorderRadius: BorderRadius.circular(10),
              labelTypes: const [],
              pickerColor: Colors.black,
              onColorChanged: (color) => _selectedColor = color,
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
