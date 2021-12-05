// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
A text field for the user to search by string. It is assumed that the
controller is already initialized and has listeners.
-------------------------------------------------------------------------------
*/

class PogoTextField extends StatelessWidget {
  const PogoTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth * 0.9,
      child: TextField(
        // Native toolbar options
        toolbarOptions: const ToolbarOptions(
          copy: true,
          cut: true,
          paste: true,
          selectAll: true,
        ),

        // Styling
        keyboardAppearance: Brightness.dark,
        cursorColor: Colors.greenAccent,
        decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent)),
          labelText: 'Search for a Pokemon',
          labelStyle: TextStyle(color: Colors.greenAccent),
        ),
        textAlign: TextAlign.center,
        controller: controller,
      ),
    );
  }
}
