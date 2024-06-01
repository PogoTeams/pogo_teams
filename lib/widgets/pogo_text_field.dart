// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../app/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A text field for the user to search by string. It is assumed that the
controller is already initialized and has listeners.
-------------------------------------------------------------------------------
*/

class PogoTextField extends StatelessWidget {
  const PogoTextField({
    super.key,
    required this.controller,
    required this.onClear,
    this.onChanged,
    this.label,
  });

  final TextEditingController controller;
  final VoidCallback onClear;
  final Widget? label;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizing.formFieldHeight,
      child: TextField(
        onChanged: onChanged,
        controller: controller,

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
          label: label ?? const Icon(Icons.search),
          suffixIcon: controller.text.isEmpty
              ? Container()
              : IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.clear),
                  iconSize: Sizing.screenWidth(context) * .05,
                  color: Colors.white,
                ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
