import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/entity_select.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

abstract class EntitySelectBox<T extends StrongEntity> extends EntitySelect<T> {
  const EntitySelectBox({
    super.key,
    required super.repository,
    required super.onSelect,
    super.initialValue,
  });

  @override
  State<StatefulWidget> createState() => EntitySelectBoxState<T>();
}

class EntitySelectBoxState<T extends StrongEntity>
    extends EntitySelectState<T> {
  T? _currentValue;

  @override
  void initState() {
    _currentValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return DropdownSearch<T>(
          compareFn: (item1, item2) => item1.id == item2.id,
          selectedItem: _currentValue,
          onChanged: select,
          items: getData,
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
          popupProps: PopupProps.modalBottomSheet(
            cacheItems: true,
            modalBottomSheetProps: ModalBottomSheetProps(
              backgroundColor: ColorScheme.of(context).surfaceContainer,
              useRootNavigator: true,
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
      },
    );
  }
}
