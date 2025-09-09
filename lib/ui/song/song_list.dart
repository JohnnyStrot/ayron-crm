import 'package:ayron_crm/data/model/song.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/list_widgets/data_list_view.dart';
import 'package:ayron_crm/ui/song/song_list_entry.dart';
import 'package:ayron_crm/ui/song/song_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

class SongListView extends DataListView<Song, SongListViewmodel, SongListView> {
  const SongListView({super.key, required super.viewmodel});

  @override
  State<SongListView> createState() => _SongListViewState();
}

class _SongListViewState
    extends DataListViewState<Song, SongListViewmodel, SongListView> {
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    nameController
        .debounce(Durations.medium2)
        .listen((text, _) => widget.viewmodel.nameChanged(text.text));
    super.initState();
  }

  @override
  Widget buildEntry(BuildContext context, Song entity) {
    return SongListEntry(song: entity, onDelete: (org) => delete(org));
  }

  @override
  Widget buildSearch(BuildContext context) {
    return Row(
      spacing: Dimens.paddingHorizontal,
      children: [
        Expanded(
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              label: Text("Name"),
              suffixIcon: IconButton(
                onPressed: () {
                  nameController.clear();
                },
                icon: Icon(Icons.clear),
              ),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  String get entityDisplay => "Song";

  @override
  String get route => Routes.songs;
}
