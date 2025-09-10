import 'dart:ui';

import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/data/model/setlist.dart';
import 'package:ayron_crm/data/model/song.dart';
import 'package:ayron_crm/data/model/to_one.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/data/repositories/song/song_repository.dart';
import 'package:ayron_crm/data/services/api/api_service.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/file_downloader.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GigSetlist extends StatefulWidget {
  const GigSetlist({
    super.key,
    required this.gig,
    required this.repository,
    required this.apiService,
  });

  final Gig gig;
  final SongRepository repository;

  final ApiService apiService;

  @override
  State<GigSetlist> createState() => _GigSetlistState();

  Future<Result<List<Song>>> getEntities(String filter, LoadProps? loadProps) {
    return repository
        .getEntities(
          filter: {"filter": filter},
          skip: loadProps?.skip,
          take: loadProps?.take,
          order: "name",
          orderDesc: false,
        )
        .then((v) {
          switch (v) {
            case Ok<ResultList<Song>>():
              return Result.ok(v.value.entities);
            case Error<ResultList<Song>>():
              return Result.error(v.error);
          }
        });
  }
}

class _GigSetlistState extends State<GigSetlist> {
  @override
  Widget build(BuildContext context) {
    Widget dropdown = DropdownSearch<Song>(
      compareFn: (item1, item2) => item1.id == item2.id,
      onChanged: (song) {
        addSetlist(song: song);
      },
      clickProps: ClickProps(borderRadius: BorderRadius.circular(50)),
      mode: Mode.custom,
      items: _getData,
      itemAsString: (item) => item.name,
      dropdownBuilder: (ctx, selectedItem) => Icon(Icons.queue_music),
      popupProps: PopupProps.modalBottomSheet(
        cacheItems: true,
        modalBottomSheetProps: ModalBottomSheetProps(
          backgroundColor: ColorScheme.of(context).surfaceContainer,
        ),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(label: Text("Suche...")),
          padding: EdgeInsets.symmetric(
            vertical: Dimens.paddingVertical,
            horizontal: Dimens.paddingHorizontal,
          ),
        ),
        showSearchBox: true,
        itemBuilder: (context, item, isDisabled, isSelected) {
          return Padding(
            padding: EdgeInsetsGeometry.symmetric(
              vertical: Dimens.of(context).paddingScreenVertical,
              horizontal: Dimens.of(context).paddingScreenHorizontal,
            ),
            child: Row(
              spacing: Dimens.hgap,
              children: [
                Text(item.name),
                Text(item.author, style: TextTheme.of(context).bodySmall),
              ],
            ),
          );
        },
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dimens.of(context).paddingScreenVertical,
        horizontal: Dimens.of(context).paddingScreenHorizontal,
      ),
      child: Column(
        spacing: Dimens.vgap,
        children: [
          Row(
            spacing: Dimens.hgap,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Setlist", style: TextTheme.of(context).headlineSmall),
              SizedBox(width: Dimens.paddingHorizontal),
              dropdown,
              IconButton(
                onPressed: () async {
                  var text = "";
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Texteintrag"),
                        content: TextFormField(
                          onChanged: (value) => text = value,
                        ),
                        actions: [
                          FilledButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.add),
                            label: Text("Eintrag"),
                          ),
                        ],
                      );
                    },
                  );
                  if (text.isNotEmpty) {
                    addSetlist(text: text);
                  }
                },
                icon: Icon(Icons.edit_note),
              ),
              CrossPlatformDownloader(
                endpoint: "gig/setlist-tex/${widget.gig.id}",
                apiService: context.read(),
                fileName: "setlist.tex",
              ),
            ],
          ),
          Expanded(
            child: ReorderableListView.builder(
              proxyDecorator: proxyDecorator,
              buildDefaultDragHandles: false,
              itemBuilder: (context, index) {
                return Card(
                  key: Key('$index'),
                  color: getColor(index),
                  child: getCardContent(index),
                );
              },
              itemCount: widget.gig.setlist.length,
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  moveSetlist(widget.gig, oldIndex, newIndex);
                });
              },
            ),
          ),
          SizedBox(height: Dimens.fabGap),
        ],
      ),
    );
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(1, 6, animValue)!;
        final double scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(
          scale: scale,
          // Create a Card based on the color and the content of the dragged one
          // and set its elevation to the animated value.
          child: Card(
            elevation: elevation,
            color: getColor(index),
            child: getCardContent(index),
          ),
        );
      },
      child: child,
    );
  }

  Color getColor(int index) {
    return index.isOdd
        ? ColorScheme.of(context).surfaceContainer
        : ColorScheme.of(context).surfaceContainerLow;
  }

  Widget getCardContent(int index) {
    final sl = widget.gig.setlist[index];
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimens.vgap / 2,
        horizontal: Dimens.hgap,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => setState(() {
              if (sl.encore) {
                sl.encore = false;
                sl.optional = true;
              } else if (sl.optional) {
                sl.optional = false;
                sl.encore = false;
              } else {
                sl.encore = true;
              }
            }),
            icon: sl.encore
                ? Icon(Icons.celebration)
                : sl.optional
                ? Icon(Icons.fast_forward)
                : Icon(Icons.play_arrow),
          ),
          Expanded(
            child: sl.song != null
                ? Text(sl.song!.name)
                : Text(sl.text, style: TextStyle(fontStyle: FontStyle.italic)),
          ),
          IconButton(
            onPressed: () => setState(() => deleteSetlist(widget.gig, index)),
            icon: Icon(Icons.delete),
          ),
          ReorderableDragStartListener(
            index: index,
            child: Icon(Icons.drag_handle),
          ),
        ],
      ),
    );
  }

  void addSetlist({Song? song, String? text}) {
    setState(() {
      widget.gig.setlist.add(
        Setlist(
          song: ToOne(entity: song),
          text: text ?? "",
          gig: ToOne(),
          order: widget.gig.setlist.length,
        ),
      );
    });
  }

  void setOrderSetlist(Gig gig) {
    for (int index = 0; index < gig.setlist.length; index += 1) {
      gig.setlist[index].order = index;
    }
  }

  void deleteSetlist(Gig gig, int index) {
    gig.setlist.removeAt(index);
    setOrderSetlist(gig);
  }

  void moveSetlist(Gig gig, int oldIndex, int newIndex) {
    final item = gig.setlist.removeAt(oldIndex);
    gig.setlist.insert(newIndex, item);
    setOrderSetlist(gig);
  }

  Future<List<Song>> _getData(String filter, LoadProps? loadProps) {
    return widget.getEntities(filter, loadProps).then((result) {
      switch (result) {
        case Ok<List<Song>>():
          return result.value;
        case Error<List<Song>>():
          return Future.value([]);
      }
    });
  }
}
