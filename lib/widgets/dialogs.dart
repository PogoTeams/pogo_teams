// Dart
import 'dart:async';

// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../modules/ui/sizing.dart';

Future<bool> getConfirmation(
  BuildContext context,
  String title,
  String message,
) async {
  bool confirmation = false;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: Sizing.blockSizeVertical * 2.0,
                left: Sizing.blockSizeHorizontal * 5.0,
              ),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.clear),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.headline6,
              ),
              child: Text(
                'Continue',
                style: Theme.of(context).textTheme.headline6,
              ),
              onPressed: () {
                confirmation = true;
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
  return confirmation;
}

Future<void> processFinished(
  BuildContext context,
  String title,
  String message,
) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ),
        actions: [
          Center(
            child: IconButton(
              icon: const Icon(
                Icons.check,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}
