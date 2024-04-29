// Flutter
import 'package:flutter/material.dart';

// Packages
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// Local Imports
import '../app/ui/sizing.dart';
import '../model/tag.dart';
import '../widgets/buttons/exit_button.dart';
import '../widgets/dialogs.dart';
import '../modules/pogo_repository.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A page for creating and editing tags.
-------------------------------------------------------------------------------
*/

class TagEdit extends StatefulWidget {
  const TagEdit({
    super.key,
    this.tag,
    this.create = false,
  });

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
      width: Sizing.screenWidth(context) * .87,
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
      if (PogoRepository.tagNameExists(_textController.text)) {
        displayMessageOK(
          context,
          'Invalid Tag Name',
          'The tag name "${_textController.text}" already exists.',
        );
      } else {
        PogoRepository.updateTagSync(
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
          PogoRepository.tagNameExists(_textController.text)) {
        displayMessageOK(
          context,
          'Invalid Tag Name',
          'The tag name "${_textController.text}" already exists.',
        );
      } else {
        PogoRepository.updateTagSync(
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
        padding: Sizing.horizontalWindowInsets(context).copyWith(
          top: Sizing.screenHeight(context) * .10,
          bottom: Sizing.screenHeight(context) * .10,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name', style: Theme.of(context).textTheme.titleLarge),

              SizedBox(
                height: Sizing.screenHeight(context) * .02,
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
                height: Sizing.screenHeight(context) * .02,
              ),

              Text('Color', style: Theme.of(context).textTheme.titleLarge),

              SizedBox(
                height: Sizing.screenHeight(context) * .02,
              ),

              // Color
              ColorPicker(
                paletteType: PaletteType.hsl,
                enableAlpha: false,
                colorPickerWidth: Sizing.screenWidth(context) * .75,
                pickerAreaBorderRadius: BorderRadius.circular(10),
                labelTypes: const [],
                pickerColor: _selectedColor,
                onColorChanged: (color) => _selectedColor = color,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
