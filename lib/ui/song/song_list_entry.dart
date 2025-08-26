import 'package:ayron_crm/data/model/song.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SongListEntry extends StatelessWidget {
  const SongListEntry({super.key, required this.song, required this.onDelete});

  final Song song;

  final void Function(Song song) onDelete;

  String get route => Routes.songs;

  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          song.name,
          overflow: TextOverflow.ellipsis,
          style: TextTheme.of(context).displaySmall!.copyWith(
            fontSize: TextTheme.of(context).bodyLarge!.fontSize,
            color: ColorScheme.of(
              context,
            ).onSurface.withAlpha(song.inRepertoire ? 255 : 120),
          ),
        ),
        Text(
          song.author,
          style: TextStyle(
            color: ColorScheme.of(
              context,
            ).onSurface.withAlpha(song.inRepertoire ? 255 : 120),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final action = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            context.push("$route/${song.id}");
          },
          icon: Icon(Icons.edit),
        ),
        IconButton(
          onPressed: () {
            onDelete(song);
          },
          icon: Icon(Icons.delete),
        ),
      ],
    );
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.fromLTRB(
          bottom: BorderSide(
            color: ColorScheme.of(context).primary.withAlpha(60),
            style: BorderStyle.solid,
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: 10, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: buildContent(context)),
          action,
        ],
      ),
    );
  }
}
