import 'package:ayron_crm/data/model/event_series.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/data/repositories/series/series_repository.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/series/series_details.dart';
import 'package:ayron_crm/ui/series/series_details_viewmodel.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SeriesPicker extends StatefulWidget {
  const SeriesPicker({
    super.key,
    required this.repository,
    required this.onSelect,
    this.label,
    this.initialValue,
  });

  final EventSeriesRepository repository;

  final void Function(EventSeries? l) onSelect;

  final EventSeries? initialValue;

  final String? label;

  Future<Result<List<EventSeries>>> getEntities(
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
            case Ok<ResultList<EventSeries>>():
              return Result.ok(v.value.entities);
            case Error<ResultList<EventSeries>>():
              return Result.error(v.error);
          }
        });
  }

  @override
  State<SeriesPicker> createState() => SeriesPickerState();
}

class SeriesPickerState extends State<SeriesPicker> {
  EventSeries? currentValue;

  final int take = 25;

  late TextEditingController nameController;
  late PagingController<int, EventSeries> pagingController;

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

  void select(EventSeries? l) {
    widget.onSelect(l);
    if (context.mounted) {
      setState(() {
        currentValue = l;
      });
    }
  }

  Future<List<EventSeries>> getData(String filterName, LoadProps? loadProps) {
    return widget.getEntities(filterName, loadProps).then((result) {
      switch (result) {
        case Ok<List<EventSeries>>():
          return result.value;
        case Error<List<EventSeries>>():
          return Future.value([]);
      }
    });
  }

  void addEventSeries(BuildContext context) async {
    SeriesDetailsViewmodel vm = SeriesDetailsViewmodel(
      seriesRepository: context.read(),
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
          child: SeriesDetails(viewmodel: vm),
        ),
      ),
    );
    if (p != null && p is EventSeries) {
      select(p);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  String entityAsString(EventSeries? entity) {
    if (entity == null) {
      return "";
    }
    return entity.displayShort;
  }

  void openBottomSheet(BuildContext context) async {
    final paging = PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedSliverList<int, EventSeries>(
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
                  onPressed: () => addEventSeries(context),
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

  Widget buildEntry(BuildContext context, EventSeries entity) {
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
