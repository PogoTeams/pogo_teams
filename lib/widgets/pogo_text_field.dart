// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  }) : super(key: key);

  final TextEditingController controller;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: SizeConfig.blockSizeVertical * 5.0,
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
        cursorColor: Colors.white,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(100),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(100),
          ),
          //labelText: 'Search for a Pokemon',
          label: const Icon(Icons.search),
          //labelStyle: const TextStyle(color: Colors.greenAccent),
        ),
        textAlign: TextAlign.center,
        controller: controller,
      ),
    );
  }
}
