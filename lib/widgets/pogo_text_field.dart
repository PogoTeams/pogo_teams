// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../configs/size_config.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A text field for the user to search by string. It is assumed that the
controller is already initialized and has listeners.
-------------------------------------------------------------------------------
*/

class PogoTextField extends StatelessWidget {
  const PogoTextField({
    Key? key,
    required this.controller,
    this.width = double.infinity,
    required this.onClear,
  }) : super(key: key);

  final TextEditingController controller;
  final double width;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: SizeConfig.blockSizeVertical * 5.0,
      child: TextField(
        controller: controller,

        // Native toolbar options
        toolbarOptions: const ToolbarOptions(
          copy: true,
          cut: true,
          paste: true,
          selectAll: true,
        ),

        // Styling
        keyboardAppearance: Brightness.dark,
        cursorColor: Colors.white,
        showCursor: true,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(100),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(100),
          ),
          label: const Icon(Icons.search),
          suffixIcon: controller.text.isEmpty
              ? Container()
              : IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.clear),
                  iconSize: SizeConfig.blockSizeHorizontal * 5.0,
                  color: Colors.white,
                ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
