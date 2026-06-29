import 'package:ayron_crm/data/model/song.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/data/repositories/song/song_repository.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/song/song_details.dart';
import 'package:ayron_crm/ui/song/song_details_viewmodel.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SongPicker extends StatefulWidget {
  const SongPicker({
    super.key,
    required this.repository,
    required this.onSelect,
    this.label,
    this.initialValue,
  });

  final SongRepository repository;

  final void Function(Song? l) onSelect;

  final Song? initialValue;

  final String? label;

  Future<Result<List<Song>>> getEntities(
    String filterName,
    LoadProps? loadProps,
  ) {
    return repository
        .getEntities(
          filter: {"filter": filterName},
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

  @override
  State<SongPicker> createState() => SongPickerState();
}

class SongPickerState extends State<SongPicker> {
  Song? currentValue;

  final int take = 25;

  late TextEditingController nameController;
  late PagingController<int, Song> pagingController;

  @override
  void initState() {
    pagingController = PagingController(
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: (pageKey) => getData(
        nameController.text,
        LoadProps(skip: (pageKey - 1) * take, take: take),
      ),
    );
    nameController = TextEditingController();
    nameController.debounce(Durations.medium4).addListener(() {
      pagingController.refresh();
    });
    currentValue = widget.initialValue;
    super.initState();
  }

  void select(Song? l) {
    widget.onSelect(l);
    if (context.mounted) {
      setState(() {
        currentValue = l;
      });
    }
  }

  Future<List<Song>> getData(String filterName, LoadProps? loadProps) {
    return widget.getEntities(filterName, loadProps).then((result) {
      switch (result) {
        case Ok<List<Song>>():
          return result.value;
        case Error<List<Song>>():
          return Future.value([]);
      }
    });
  }

  void addSong(BuildContext context) async {
    SongDetailsViewmodel vm = SongDetailsViewmodel(
      songRepository: context.read(),
    );
    vm.createEntity.execute();

    var p = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            Navigator.pop(context, vm.entity);
          },
          child: SongDetails(viewmodel: vm),
        ),
      ),
    );
    if (p != null && p is Song) {
      select(p);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  String entityAsString(Song? entity) {
    if (entity == null) {
      return "";
    }
    return entity.displayShort;
  }

  void openBottomSheet(BuildContext context) async {
    final paging = PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedSliverList<int, Song>(
          state: state,
          fetchNextPage: fetchNextPage,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, entity, index) => Padding(
              padding: EdgeInsets.only(top: index > 0 ? 10 : 0),
              child: buildEntry(context, entity),
            ),
          ),
        );
      },
    );

    final scroll = CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            bottom: Dimens.fabGap,
            right: Dimens.scrollBarGap,
          ),
          sliver: paging,
        ),
      ],
    );

    await showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.of(context).paddingScreenHorizontal,
              vertical: Dimens.of(context).paddingScreenVertical,
            ),
            child: Row(
              spacing: Dimens.hgap,
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                ),
                IconButton(
                  onPressed: () => addSong(context),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(child: scroll),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: entityAsString(currentValue)),
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: currentValue != null
            ? IconButton(onPressed: () => select(null), icon: Icon(Icons.clear))
            : null,
      ),
      onTap: () => openBottomSheet(context),
    );
  }

  Widget buildEntry(BuildContext context, Song entity) {
    return ListTile(
      onTap: () {
        select(entity);
        Navigator.pop(context);
      },
      leading: Icon(Icons.person),
      /*entity.logo?.isNotEmpty ?? false
          ? Image.network(
              entity.logo!,
              width: 32,
              height: 32,
              alignment: AlignmentGeometry.center,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.group, size: 32),
            )
          : Icon(entity.typeIcon, size: 32),*/
      title: Text(
        entity.displayShort,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
