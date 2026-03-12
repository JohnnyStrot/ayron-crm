import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/entity_select.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

abstract class EntityPickButton<T extends StrongEntity>
    extends EntitySelect<T> {
  const EntityPickButton({
    super.key,
    required super.repository,
    required super.onSelect,
    super.initialValue,
  });

  @override
  State<StatefulWidget> createState() => _EntityPickButtonState<T>();
}

class _EntityPickButtonState<T extends StrongEntity>
    extends EntitySelectState<T> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      compareFn: (item1, item2) => item1.id == item2.id,
      onChanged: select,
      items: getData,
      itemAsString: widget.entityAsString,
      clickProps: ClickProps(borderRadius: BorderRadius.circular(20)),
      dropdownBuilder: (ctx, selectedItem) => Icon(Icons.add),
      mode: Mode.custom,
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
  }
}
