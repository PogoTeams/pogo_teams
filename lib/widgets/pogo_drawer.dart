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

  // The background gradient on the drawer
  BoxDecoration _buildGradientDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF29F19C), Color(0xFF02A1F9)],
        tileMode: TileMode.clamp,
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 30.0,
      child: DrawerHeader(
        child: Image.asset(
          'assets/pogo_teams_icon.png',
          scale: SizeConfig.blockSizeHorizontal * .5,
        ),
      ),
    );
  }

  // Conditionally build the option to remove all teams
  // This will only build if a onClearAll callback was provided
  Widget _buildRemoveAllIfValid() {
    return onClearAll == null
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
          );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: _buildGradientDecoration(),
        child: ListView(
          children: [
            _buildDrawerHeader(),

            // Navigation options
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

            // Conditional remove all option
            _buildRemoveAllIfValid(),
          ],
        ),
      ),
    );
  }
}
