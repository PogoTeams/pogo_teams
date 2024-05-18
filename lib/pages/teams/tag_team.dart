// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../model/pokemon_team.dart';
import '../../model/tag.dart';
import '../../modules/pogo_repository.dart';
import '../../app/ui/sizing.dart';
import '../tag_edit.dart';
import '../../widgets/nodes/team_node.dart';
import '../../widgets/tag_dot.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A page that allows the user to link a tag to a team. The user can also create
new tags from this page.
-------------------------------------------------------------------------------
*/

class TagTeam extends StatefulWidget {
  const TagTeam({
    super.key,
    required this.team,
    this.winRate,
  });

  final PokemonTeam team;
  final String? winRate;

  @override
  State<TagTeam> createState() => _TagTeamState();
}

class _TagTeamState extends State<TagTeam> {
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
    final tags = PogoRepository.getTags();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TeamNode(
            onPressed: (_) {},
            onEmptyPressed: (_) {},
            team: widget.team,
          ),

          // Create New Tag
          MaterialButton(
            onPressed: _onAddTag,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add Tag',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(
                  width: Sizing.screenWidth(context) * .02,
                ),
                const Icon(
                  Icons.add,
                  size: Sizing.icon2,
                ),
              ],
            ),
          ),

          SizedBox(
            height: Sizing.screenHeight(context) * .02,
          ),

          Expanded(
            child:
                // Tags List View
                ListView.builder(
              itemCount: tags.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: Sizing.screenWidth(context) * .02,
                    right: Sizing.screenWidth(context) * .02,
                  ),
                  child: RadioListTile<String?>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.only(
                      left: Sizing.screenWidth(context) * .02,
                      right: Sizing.screenWidth(context) * .02,
                    ),
                    selected: _selectedTag?.name == tags[index].name,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tags[index].name,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                        TagDot(
                          tag: tags[index],
                        ),
                      ],
                    ),
                    value: tags[index].name,
                    groupValue: _selectedTag?.name,
                    onChanged: (String? name) {
                      setState(() {
                        _selectedTag = tags[index];
                        widget.team.tag = _selectedTag;
                      });
                    },
                    // TODO: move color into ThemeData
                    selectedTileColor: const Color(0xFF02A1F9),
                  ),
                );
              },
            ),
          ),
          MaterialButton(
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () => Navigator.pop(context, _selectedTag),
            height: Sizing.screenHeight(context) * .07,
            child: const Center(
              child: Icon(
                Icons.clear,
                size: Sizing.icon2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
