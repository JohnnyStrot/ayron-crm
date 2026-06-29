import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/data/repositories/location/location_repository.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/location/location_details.dart';
import 'package:ayron_crm/ui/location/location_details_viewmodel.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({
    super.key,
    required this.repository,
    required this.onSelect,
    this.label,
    this.initialValue,
  });

  final LocationRepository repository;

  final void Function(Location? l) onSelect;

  final Location? initialValue;

  final String? label;

  Future<Result<List<Location>>> getEntities(
    String filterName,
    String filterCity,
    LoadProps? loadProps,
  ) {
    return repository
        .getEntities(
          filter: {"name": filterName, "city": filterCity},
          skip: loadProps?.skip,
          take: loadProps?.take,
          order: "name",
          orderDesc: false,
        )
        .then((v) {
          switch (v) {
            case Ok<ResultList<Location>>():
              return Result.ok(v.value.entities);
            case Error<ResultList<Location>>():
              return Result.error(v.error);
          }
        });
  }

  @override
  State<LocationPicker> createState() => LocationPickerState();
}

class LocationPickerState extends State<LocationPicker> {
  Location? currentValue;

  final int take = 25;

  late TextEditingController nameController;
  late TextEditingController cityController;
  late PagingController<int, Location> pagingController;

  @override
  void initState() {
    pagingController = PagingController(
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: (pageKey) => getData(
        nameController.text,
        cityController.text,
        LoadProps(skip: (pageKey - 1) * take, take: take),
      ),
    );
    nameController = TextEditingController();
    cityController = TextEditingController();
    nameController.debounce(Durations.medium4).addListener(() {
      pagingController.refresh();
    });
    cityController.debounce(Durations.medium4).addListener(() {
      pagingController.refresh();
    });
    currentValue = widget.initialValue;
    super.initState();
  }

  void select(Location? l) {
    widget.onSelect(l);
    if (context.mounted) {
      setState(() {
        currentValue = l;
      });
    }
  }

  Future<List<Location>> getData(
    String filterName,
    String filterCity,
    LoadProps? loadProps,
  ) {
    return widget.getEntities(filterName, filterCity, loadProps).then((result) {
      switch (result) {
        case Ok<List<Location>>():
          return result.value;
        case Error<List<Location>>():
          return Future.value([]);
      }
    });
  }

  void addLocation(BuildContext context) async {
    LocationDetailsViewmodel vm = LocationDetailsViewmodel(
      locationRepository: context.read(),
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
          child: LocationDetails(viewmodel: vm),
        ),
      ),
    );
    if (p != null && p is Location) {
      select(p);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  String entityAsString(Location? entity) {
    if (entity == null) {
      return "";
    }
    return entity.displayShort;
  }

  void openBottomSheet(BuildContext context) async {
    final paging = PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedSliverList<int, Location>(
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
                Expanded(
                  child: TextField(
                    controller: cityController,
                    decoration: InputDecoration(labelText: "Stadt"),
                  ),
                ),
                IconButton(
                  onPressed: () => addLocation(context),
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

  Widget buildEntry(BuildContext context, Location entity) {
    return ListTile(
      onTap: () {
        select(entity);
        Navigator.pop(context);
      },
      leading: entity.logo?.isNotEmpty ?? false
          ? Image.network(
              entity.logo!,
              width: 32,
              height: 32,
              alignment: AlignmentGeometry.center,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.group, size: 32),
            )
          : Icon(entity.typeIcon, size: 32),
      title: Text(entity.name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text([entity.city, entity.street].join(", ")),
    );
  }
}
