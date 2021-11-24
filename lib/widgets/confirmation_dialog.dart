// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../configs/size_config.dart';

Future<bool> confirmationDialog(BuildContext context) async {
  Widget cancelButton = MaterialButton(
    child: Text(
      'Cancel',
      style: TextStyle(
        fontSize: SizeConfig.h2,
        fontWeight: FontWeight.bold,
      ),
    ),
    onPressed: () {
      Navigator.pop(context, false);
    },
  );

  Widget continueButton = MaterialButton(
    child: Text(
      'Remove All',
      style: TextStyle(
        fontSize: SizeConfig.h2,
        fontWeight: FontWeight.bold,
      ),
    ),
    onPressed: () {
      Navigator.pop(context, true);
    },
  );

  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Remove ALL Teams',
            style: TextStyle(
              fontSize: SizeConfig.h2,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to remove all teams from the team builder?',
            style: TextStyle(
              fontSize: SizeConfig.h2,
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      });
}
