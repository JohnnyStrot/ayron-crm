import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/data/repositories/opportunity/opportunity_repository.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class OpportunityPicker extends StatefulWidget {
  const OpportunityPicker({
    super.key,
    required this.repository,
    required this.onSelect,
    this.label,
    this.initialValue,
    this.buttonOnly = false,
  });

  final OpportunityRepository repository;

  final void Function(Opportunity? l) onSelect;

  final Opportunity? initialValue;

  final String? label;

  final bool buttonOnly;

  Future<Result<List<Opportunity>>> getEntities(
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
            case Ok<ResultList<Opportunity>>():
              return Result.ok(v.value.entities);
            case Error<ResultList<Opportunity>>():
              return Result.error(v.error);
          }
        });
  }

  @override
  State<OpportunityPicker> createState() => OpportunityPickerState();
}

class OpportunityPickerState extends State<OpportunityPicker> {
  Opportunity? currentValue;

  final int take = 25;

  late TextEditingController nameController;
  late PagingController<int, Opportunity> pagingController;

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

  void select(Opportunity? l) {
    widget.onSelect(l);
    if (context.mounted) {
      setState(() {
        currentValue = l;
      });
    }
  }

  Future<List<Opportunity>> getData(String filterName, LoadProps? loadProps) {
    return widget.getEntities(filterName, loadProps).then((result) {
      switch (result) {
        case Ok<List<Opportunity>>():
          return result.value;
        case Error<List<Opportunity>>():
          return Future.value([]);
      }
    });
  }

  String entityAsString(Opportunity? entity) {
    if (entity == null) {
      return "";
    }
    return entity.displayShort;
  }

  void openBottomSheet(BuildContext context) async {
    final paging = PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedSliverList<int, Opportunity>(
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
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
          ),
          Expanded(child: scroll),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buttonOnly) {
      return IconButton(
        onPressed: () => openBottomSheet(context),
        icon: Icon(Icons.add),
      );
    }
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

  Widget buildEntry(BuildContext context, Opportunity entity) {
    return ListTile(
      onTap: () {
        select(entity);
        Navigator.pop(context);
      },
      leading: Icon(entity.typeIcon),
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
