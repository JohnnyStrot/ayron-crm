import 'package:ayron_crm/data/model/song.dart';
import 'package:ayron_crm/data/repositories/song/song_repository.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RepertoireList extends StatefulWidget {
  const RepertoireList({super.key, required this.repository});

  final SongRepository repository;

  @override
  State<RepertoireList> createState() => _RepertoireListState();
}

class _RepertoireListState extends State<RepertoireList> {
  _RepertoireListState() : repertoire = [];

  List<Song> repertoire;

  @override
  void initState() {
    widget.repository.getRepertoire().then((res) {
      switch (res) {
        case Ok<List<Song>>():
          setState(() {
            repertoire = res.value;
          });
        case Error<List<Song>>():
          if (mounted && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Fehler beim Laden des Repertoires")),
            );
          }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimens.vgap,
        horizontal: Dimens.paddingHorizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.vgap,
        children: [
          Text("Repertoire", style: TextTheme.of(context).headlineSmall),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                Song song = repertoire[index];
                return InkWell(
                  onTap: () {
                    context.push("${Routes.songs}/${song.id}");
                  },
                  child: Card(
                    elevation: 0.5,
                    margin: EdgeInsets.symmetric(
                      vertical: Dimens.vgap / 2.0,
                      horizontal: Dimens.hgap,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.vgap,
                        horizontal: Dimens.hgap,
                      ),
                      child: Row(
                        spacing: Dimens.hgap,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            song.name,
                            style: TextTheme.of(context).bodyLarge!,
                          ),
                          Text(song.author),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: repertoire.length,
            ),
          ),
        ],
      ),
    );
  }
}
