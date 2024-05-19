// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pogo_teams/pages/teams/bloc/teams_bloc.dart';

// Local Imports
import '../../model/pokemon_team.dart';
import '../../model/tag.dart';
import '../../modules/pogo_repository.dart';
import '../../app/ui/sizing.dart';
import '../../app/app_views/tag_edit.dart';
import '../../widgets/nodes/team_node.dart';
import '../../widgets/tag_dot.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A page that allows the user to link a tag to a team. The user can also create
new tags from this page.
-------------------------------------------------------------------------------
*/

class TagTeam extends StatelessWidget {
  const TagTeam({
    super.key,
  });

  void _onAddTag(context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const TagEdit(create: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamsBloc, TeamsState>(
      builder: (context, state) {
        final tags = context.read<PogoRepository>().getTags();

        return Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TeamNode(
                onPressed: (_) {},
                onEmptyPressed: (_) {},
                team: state.selectedTeam!,
              ),

              // Create New Tag
              MaterialButton(
                onPressed: () => _onAddTag(context),
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
                      child: RadioListTile<Tag?>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.only(
                          left: Sizing.screenWidth(context) * .02,
                          right: Sizing.screenWidth(context) * .02,
                        ),
                        selected: state.selectedTag?.name == tags[index].name,
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
                        value: tags[index],
                        groupValue: state.selectedTag,
                        onChanged: (Tag? tag) {
                          if (tag != null) {
                            context.read<TeamsBloc>().add(
                                  TagChanged(tag: tag),
                                );
                          }
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
                onPressed: () => Navigator.pop(context),
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
      },
    );
  }
}
