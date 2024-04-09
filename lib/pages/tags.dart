// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../pogo_objects/tag.dart';
import '../modules/data/pogo_data.dart';
import '../modules/ui/sizing.dart';
import '../widgets/tag_dot.dart';
import '../widgets/dialogs.dart';
import '../widgets/buttons/gradient_button.dart';
import 'tag_edit.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A list view of all tags created by the user. The user can create, edit, and
delete tags from here.
-------------------------------------------------------------------------------
*/

class Tags extends StatefulWidget {
  const Tags({Key? key}) : super(key: key);

  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  Widget _buildTagsListView() {
    return ListView(
      children: PogoData.getTagsSync().map((tag) {
        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TagDot(
                tag: tag,
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
                    icon: Icon(
                      Icons.edit,
                      size: Sizing.icon3,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _onRemoveTag(tag),
                    icon: Icon(
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
    int affectedTeamsCount = PogoData.getUserTeamsSync(tag: tag).length;
    if (affectedTeamsCount > 0 &&
        !await getConfirmation(
          context,
          'Remove Tag',
          'Removing ${tag.name} will affect $affectedTeamsCount teams.',
        )) {
      return;
    }
    setState(() {
      PogoData.deleteTagSync(tag.id);
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
      padding: EdgeInsets.only(
        top: Sizing.blockSizeVertical * 2.0,
        left: Sizing.blockSizeHorizontal * 2.0,
        right: Sizing.blockSizeHorizontal * 2.0,
      ),
      child: Scaffold(
        body: _buildTagsListView(),
        floatingActionButton: GradientButton(
          onPressed: _onEditTag,
          width: Sizing.screenWidth * .85,
          height: Sizing.blockSizeVertical * 8.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add Tag',
                style: Theme.of(context).textTheme.titleLarge,
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
