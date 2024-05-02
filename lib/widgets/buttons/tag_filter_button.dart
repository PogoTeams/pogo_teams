// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../model/tag.dart';
import '../../app/ui/sizing.dart';
import '../../modules/pogo_repository.dart';
import '../tag_dot.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class TagFilterButton extends StatelessWidget {
  const TagFilterButton({
    super.key,
    required this.tag,
    required this.onTagChanged,
    required this.width,
  });

  final Tag? tag;
  final void Function(Tag?) onTagChanged;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: tag == null
              ? [const Color(0xBF29F19C), const Color(0xFF02A1F9)]
              : [
                  Colors.transparent,
                  Color(int.parse(tag!.uiColor)),
                ],
          tileMode: TileMode.clamp,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      width: width,
      height: width,
      child: PopupMenuButton<Tag?>(
        onSelected: onTagChanged,
        itemBuilder: (context) {
          return PogoRepository.getTags().map<PopupMenuItem<Tag?>>((tag) {
            return PopupMenuItem<Tag?>(
              value: tag,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tag.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  TagDot(
                    tag: tag,
                  ),
                ],
              ),
            );
          }).toList()
            ..add(
              PopupMenuItem<Tag?>(
                value: null,
                onTap: () => onTagChanged(null),
                child: Text(
                  'All Teams',
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
        },
        child: Icon(
          tag == null ? Icons.filter_alt_off : Icons.filter_alt,
          size: Sizing.icon2,
        ),
      ),
    );
  }
}
