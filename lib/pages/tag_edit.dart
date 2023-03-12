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
A page for creating and editing tags.
-------------------------------------------------------------------------------
*/

class TagEdit extends StatefulWidget {
  const TagEdit({
    Key? key,
    this.tag,
    this.create = false,
  }) : super(key: key);

  final Tag? tag;
  final bool create;

  @override
  _TagEditState createState() => _TagEditState();
}

class _TagEditState extends State<TagEdit> {
  final TextEditingController _textController = TextEditingController();
  late Color _selectedColor;

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
    // Create tag
    if (widget.create) {
      if (PogoData.tagNameExists(_textController.text)) {
        displayMessageOK(
          context,
          'Invalid Tag Name',
          'The tag name "${_textController.text}" already exists.',
        );
      } else {
        PogoData.updateTagSync(
          Tag(
            name: _textController.text,
            uiColor: _selectedColor.value.toRadixString(10),
            dateCreated: widget.create ? DateTime.now() : null,
          ),
        );
        Navigator.pop(context);
      }
    }

    // Update tag
    else {
      if (widget.tag!.name != _textController.text &&
          PogoData.tagNameExists(_textController.text)) {
        displayMessageOK(
          context,
          'Invalid Tag Name',
          'The tag name "${_textController.text}" already exists.',
        );
      } else {
        PogoData.updateTagSync(
          Tag(
            name: _textController.text,
            uiColor: _selectedColor.value.toRadixString(10),
            dateCreated: widget.tag!.dateCreated,
          )..id = widget.tag!.id,
        );

        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.tag != null) {
      _textController.text = widget.tag!.name;
      _selectedColor = Color(int.parse(widget.tag!.uiColor));
    } else {
      _selectedColor = Colors.black;
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
              pickerColor: _selectedColor,
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
