import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/repositories/location/location_repository.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/entity_select.dart';
import 'package:flutter/material.dart';

class LocationSelect extends EntitySelect<Location> {
  const LocationSelect({
    super.key,
    required LocationRepository super.repository,
    required super.onSelect,
    super.initialValue,
  });

  @override
  Widget buildItem(
    BuildContext context,
    Location item,
    bool isDisabled,
    bool isSelected,
  ) => Row(
    spacing: Dimens.hdivide,
    children: [
      Expanded(
        flex: 3,
        child: Text(
          item.name,
          overflow: TextOverflow.ellipsis,
          style: TextTheme.of(context).headlineSmall!.copyWith(fontSize: 14),
        ),
      ),
      Expanded(
        flex: 2,
        child: Text(
          item.city,
          overflow: TextOverflow.ellipsis,
          style: TextTheme.of(context).titleMedium,
        ),
      ),
    ],
  );

  @override
  Map<String, dynamic> createFilter(String filter) => <String, dynamic>{
    "name": filter,
  };

  @override
  String entityAsString(Location? entity) => entity?.name ?? "";

  @override
  String get label => "Location";
}
