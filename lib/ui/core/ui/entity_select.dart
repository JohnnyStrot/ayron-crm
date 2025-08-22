import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

abstract class EntitySelect<T extends StrongEntity> extends StatefulWidget {
  const EntitySelect({
    super.key,
    required this.repository,
    required this.onSelect,
    this.initialValue,
  });

  final DataRepository<T> repository;

  final void Function(T? l) onSelect;

  final T? initialValue;

  String entityAsString(T? entity);

  String get label;

  @override
  State<StatefulWidget> createState() => EntitySelectState<T>();

  Widget buildItem(
    BuildContext context,
    T item,
    bool isDisabled,
    bool isSelected,
  );

  Future<Result<List<T>>> getEntities(String filter, LoadProps? loadProps) {
    return repository.getEntities(createFilter(filter));
  }

  Map<String, dynamic> createFilter(String filter);
}

class EntitySelectState<T extends StrongEntity> extends State<EntitySelect<T>> {
  T? _currentValue;

  @override
  void initState() {
    _currentValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      compareFn: (item1, item2) => item1.id == item2.id,
      selectedItem: _currentValue,
      onChanged: _select,
      items: _getData,
      itemAsString: widget.entityAsString,
      suffixProps: DropdownSuffixProps(
        clearButtonProps: ClearButtonProps(isVisible: true),
        dropdownButtonProps: DropdownButtonProps(isVisible: false),
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: widget.label,
          border: OutlineInputBorder(),
        ),
      ),
      popupProps: PopupProps.bottomSheet(
        cacheItems: true,
        bottomSheetProps: BottomSheetProps(
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
            child: widget.buildItem(context, item, isDisabled, isSelected),
          );
        },
      ),
    );
  }

  void _select(T? l) {
    setState(() {
      _currentValue = l;
      widget.onSelect(l);
    });
  }

  Future<List<T>> _getData(String filter, LoadProps? loadProps) {
    return widget.getEntities(filter, loadProps).then((result) {
      switch (result) {
        case Ok<List<T>>():
          return result.value;
        case Error<List<T>>():
          return Future.value([]);
      }
    });
  }
}
