// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../pogo_objects/tag.dart';
import '../modules/ui/sizing.dart';
import '../widgets/buttons/tag_filter_button.dart';
import '../widgets/buttons/gradient_button.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class BattleLogs extends StatefulWidget {
  const BattleLogs({Key? key}) : super(key: key);

  @override
  _RankingsState createState() => _RankingsState();
}

class _RankingsState extends State<BattleLogs> {
  Tag? _selectedTag;

  Widget _buildLoggedBattles() {
    return Container();
  }

  void _onAddLog() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.blockSizeVertical * 2.0,
      ),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logged battles list
            _buildLoggedBattles(),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GradientButton(
              onPressed: _onAddLog,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add Battle Log',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    width: Sizing.blockSizeHorizontal * 5.0,
                  ),
                  Icon(
                    Icons.add,
                    size: Sizing.blockSizeHorizontal * 7.0,
                  ),
                ],
              ),
              width: Sizing.screenWidth * .6,
              height: Sizing.blockSizeVertical * 8.5,
            ),
            TagFilterButton(
              tag: _selectedTag,
              onTagChanged: (tag) {
                setState(() {
                  _selectedTag = tag;
                });
              },
              width: Sizing.blockSizeHorizontal * .85,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
