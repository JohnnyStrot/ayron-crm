import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/data/repositories/band/band_repository.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/band/band_details.dart';
import 'package:ayron_crm/ui/band/band_details_viewmodel.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class BandPicker extends StatefulWidget {
  const BandPicker({
    super.key,
    required this.repository,
    required this.onSelect,
    this.label,
    this.initialValue,
  });

  final BandRepository repository;

  final void Function(Band? l) onSelect;

  final Band? initialValue;

  final String? label;

  Future<Result<List<Band>>> getEntities(
    String filterName,
    String filterCity,
    String filterGenre,
    LoadProps? loadProps,
  ) {
    return repository
        .getEntities(
          filter: {
            "name": filterName,
            "city": filterCity,
            "genre": filterGenre,
          },
          skip: loadProps?.skip,
          take: loadProps?.take,
          order: "name",
          orderDesc: false,
        )
        .then((v) {
          switch (v) {
            case Ok<ResultList<Band>>():
              return Result.ok(v.value.entities);
            case Error<ResultList<Band>>():
              return Result.error(v.error);
          }
        });
  }

  @override
  State<BandPicker> createState() => BandPickerState();
}

class BandPickerState extends State<BandPicker> {
  Band? currentValue;

  final int take = 25;

  late TextEditingController nameController;
  late TextEditingController cityController;
  late TextEditingController genreController;
  late PagingController<int, Band> pagingController;

  @override
  void initState() {
    pagingController = PagingController(
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: (pageKey) => getData(
        nameController.text,
        cityController.text,
        genreController.text,
        LoadProps(skip: (pageKey - 1) * take, take: take),
      ),
    );
    nameController = TextEditingController();
    cityController = TextEditingController();
    genreController = TextEditingController();
    nameController.debounce(Durations.medium4).addListener(() {
      pagingController.refresh();
    });
    cityController.debounce(Durations.medium4).addListener(() {
      pagingController.refresh();
    });
    genreController.debounce(Durations.medium4).addListener(() {
      pagingController.refresh();
    });

    currentValue = widget.initialValue;
    super.initState();
  }

  void select(Band? l) {
    widget.onSelect(l);
    if (context.mounted) {
      setState(() {
        currentValue = l;
      });
    }
  }

  Future<List<Band>> getData(
    String filterName,
    String filterCity,
    String filterGenre,
    LoadProps? loadProps,
  ) {
    return widget
        .getEntities(filterName, filterCity, filterGenre, loadProps)
        .then((result) {
          switch (result) {
            case Ok<List<Band>>():
              return result.value;
            case Error<List<Band>>():
              return Future.value([]);
          }
        });
  }

  void addBand(BuildContext context) async {
    BandDetailsViewmodel vm = BandDetailsViewmodel(
      bandRepository: context.read(),
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
          child: BandDetails(viewmodel: vm),
        ),
      ),
    );
    if (p != null && p is Band) {
      select(p);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  String entityAsString(Band? entity) {
    if (entity == null) {
      return "";
    }
    return entity.displayShort;
  }

  void openBottomSheet(BuildContext context) async {
    final paging = PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedSliverList<int, Band>(
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
                    decoration: InputDecoration(labelText: "Ort"),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: cityController,
                    decoration: InputDecoration(labelText: "Genre"),
                  ),
                ),
                IconButton(
                  onPressed: () => addBand(context),
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

  Widget buildEntry(BuildContext context, Band entity) {
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
      subtitle: Text([entity.genre, entity.city].join(", ")),
    );
  }
}
