// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
The drawer that handles all app navigation and some other functionality. It is
accessible to the user by any screen that contains a scaffold app bar.
-------------------------------------------------------------------------------
*/

class PogoDrawer extends StatelessWidget {
  const PogoDrawer({
    Key? key,
    this.onClearAll,
  }) : super(key: key);

  final VoidCallback? onClearAll;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text(
              'POGO  Teams',
              style: TextStyle(
                fontSize: SizeConfig.h1 * 2.0,
              ),
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Team Builder',
                  style: TextStyle(fontSize: SizeConfig.h1),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 3.0,
                ),
                Icon(
                  Icons.build_circle,
                  size: SizeConfig.blockSizeHorizontal * 5.0,
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/',
              );
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Rankings',
                  style: TextStyle(fontSize: SizeConfig.h1),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 3.0,
                ),
                Icon(
                  Icons.bar_chart,
                  size: SizeConfig.blockSizeHorizontal * 5.0,
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/rankings',
              );
            },
          ),

          // Only build this option if the clear all is provided
          onClearAll == null
              ? Container()
              : ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Remove All Teams',
                        style: TextStyle(fontSize: SizeConfig.h1),
                      ),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 3.0,
                      ),
                      Icon(
                        Icons.remove_circle,
                        size: SizeConfig.blockSizeHorizontal * 5.0,
                      ),
                    ],
                  ),
                  onTap: onClearAll,
                ),
        ],
      ),
    );
  }
}
