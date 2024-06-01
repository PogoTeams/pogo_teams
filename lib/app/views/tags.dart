// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../model/tag.dart';
import '../../modules/pogo_repository.dart';
import '../ui/sizing.dart';
import '../../widgets/tag_dot.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/buttons/gradient_button.dart';
import 'app_views.dart';
import 'tag_edit.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A list view of all tags created by the user. The user can create, edit, and
delete tags from here.
-------------------------------------------------------------------------------
*/

class Tags extends StatefulWidget {
  const Tags({super.key});

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  Widget _buildTagsListView() {
    return ListView(
      children: PogoRepository.getTags().map((tag) {
        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 25.0,
                height: 25.0,
                child: TagDot(
                  tag: tag,
                ),
              ),
              Text(
                tag.name,
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _onEditTag(tag: tag),
                    icon: const Icon(
                      Icons.edit,
                      size: Sizing.icon3,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _onRemoveTag(tag),
                    icon: const Icon(
                      Icons.clear,
                      size: Sizing.icon3,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }).toList(),
    );
  }

  void _onEditTag({Tag? tag}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TagEdit(
          tag: tag,
          create: tag == null,
        ),
      ),
    );

    setState(() {});
  }

  void _onRemoveTag(Tag tag) async {
    int affectedTeamsCount = PogoRepository.getUserTeams(tag: tag).length;
    if (affectedTeamsCount > 0 &&
        !await getConfirmation(
          context,
          'Remove Tag',
          'Removing ${tag.name} will affect $affectedTeamsCount teams.',
        )) {
      return;
    }
    setState(() {
      PogoRepository.deleteTag(tag.name);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Sizing.horizontalWindowInsets(context).copyWith(
        top: Sizing.screenHeight(context) * .02,
      ),
      child: Scaffold(
        body: _buildTagsListView(),
        floatingActionButton: GradientButton(
          onPressed: _onEditTag,
          width: Sizing.screenWidth(context) * .85,
          height: Sizing.screenHeight(context) * .085,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add Tag  ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Icon(
                Icons.add,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
