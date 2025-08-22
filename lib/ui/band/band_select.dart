import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/data/repositories/band/band_repository.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/entity_select.dart';
import 'package:flutter/material.dart';

class BandSelect extends EntitySelect<Band> {
  const BandSelect({
    super.key,
    required BandRepository super.repository,
    required super.onSelect,
    super.initialValue,
  });

  @override
  Widget buildItem(
    BuildContext context,
    Band item,
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
          "${item.genre}, ${item.city}",
          overflow: TextOverflow.ellipsis,
          style: TextTheme.of(context).titleSmall,
        ),
      ),
    ],
  );

  @override
  Map<String, dynamic> createFilter(String filter) => <String, dynamic>{
    "name": filter,
  };

  @override
  String entityAsString(Band? entity) => entity?.name ?? "";

  @override
  String get label => "Band";
}
