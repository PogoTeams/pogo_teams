// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../pogo_objects/pokemon_team.dart';
import '../../pogo_objects/tag.dart';
import '../../modules/data/pogo_data.dart';
import '../../modules/ui/sizing.dart';
import '../../pages/tag_edit.dart';
import '../buttons/exit_button.dart';
import '../nodes/team_node.dart';
import '../color_dot.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class TeamTagOverlay extends StatefulWidget {
  const TeamTagOverlay({
    Key? key,
    required this.team,
    this.winRate,
  }) : super(key: key);

  final PokemonTeam team;
  final String? winRate;

  @override
  _TeamTagOverlayState createState() => _TeamTagOverlayState();
}

class _TeamTagOverlayState extends State<TeamTagOverlay> {
  Tag? _selectedTag;

  void _onAddTag() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const TagEdit(create: true),
      ),
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _selectedTag = widget.team.getTag();
  }

  @override
  Widget build(BuildContext context) {
    final tags = PogoData.getTagsSync();

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: Sizing.screenHeight * .84,
        width: Sizing.screenWidth * .96,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TeamNode(
              onPressed: (_) {},
              onEmptyPressed: (_) {},
              buildHeader: true,
              pokemonTeam: widget.team.getOrderedPokemonListFilled(),
              cup: widget.team.getCup(),
              tag: widget.team.getTag(),
              winRate: widget.winRate,
              padding: EdgeInsets.fromLTRB(
                Sizing.blockSizeHorizontal * 3.0,
                Sizing.blockSizeVertical * 1.0,
                Sizing.blockSizeHorizontal * 3.0,
                Sizing.blockSizeVertical * 2.0,
              ),
            ),

            // Create New Tag
            MaterialButton(
              onPressed: _onAddTag,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add Tag',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    width: Sizing.blockSizeHorizontal * 2.0,
                  ),
                  Icon(
                    Icons.add,
                    size: Sizing.icon2,
                  ),
                ],
              ),
            ),

            SizedBox(
              height: Sizing.blockSizeVertical * 2.0,
            ),

            Expanded(
              child: Stack(
                children: [
                  // Tags List View
                  ListView.builder(
                    itemCount: tags.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: Sizing.blockSizeHorizontal * 2.0,
                          right: Sizing.blockSizeHorizontal * 2.0,
                        ),
                        child: RadioListTile<String?>(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.only(
                            left: Sizing.blockSizeHorizontal * 2.0,
                            right: Sizing.blockSizeHorizontal * 2.0,
                          ),
                          selected: _selectedTag?.name == tags[index].name,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tags[index].name,
                                style: Theme.of(context).textTheme.headline6,
                                overflow: TextOverflow.ellipsis,
                              ),
                              ColorDot(
                                color: Color(int.parse(tags[index].uiColor)),
                              ),
                            ],
                          ),
                          value: tags[index].name,
                          groupValue: _selectedTag?.name,
                          onChanged: (String? name) {
                            setState(() {
                              _selectedTag = tags[index];
                              widget.team.tag.value = _selectedTag;
                            });
                          },
                          selectedTileColor: Theme.of(context).selectedRowColor,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: Sizing.blockSizeVertical * 3.0,
                    left: 0,
                    right: 0,
                    child: ExitButton(
                      onPressed: () => Navigator.pop(context, _selectedTag),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
