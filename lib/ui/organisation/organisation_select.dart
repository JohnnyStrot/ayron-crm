import 'package:ayron_crm/data/model/organisation.dart';
import 'package:ayron_crm/data/repositories/organisation/organisation_repository.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/entity_select.dart';
import 'package:flutter/material.dart';

class OrganisationSelect extends EntitySelect<Organisation> {
  const OrganisationSelect({
    super.key,
    required OrganisationRepository super.repository,
    required super.onSelect,
    super.initialValue,
  });

  @override
  Widget buildItem(
    BuildContext context,
    Organisation item,
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
    ],
  );

  @override
  Map<String, dynamic> createFilter(String filter) => <String, dynamic>{
    "name": filter,
  };

  @override
  String entityAsString(Organisation? entity) => entity?.name ?? "";

  @override
  String get label => "Organisation";
}
