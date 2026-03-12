import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/repositories/opportunity/opportunity_repository.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/entity_pick_button.dart';
import 'package:flutter/material.dart';

class OpportunityPickButton extends EntityPickButton<Opportunity> {
  const OpportunityPickButton({
    super.key,
    required OpportunityRepository super.repository,
    required super.onSelect,
    super.initialValue,
  });

  @override
  Widget buildItem(
    BuildContext context,
    Opportunity item,
    bool isDisabled,
    bool isSelected,
  ) => Row(
    spacing: Dimens.hdivide,
    children: [
      Icon(item.typeIcon),
      Expanded(
        flex: 3,
        child: Text(
          item.displayShort,
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
  String entityAsString(Opportunity? entity) => entity?.name ?? "";

  @override
  String get label => "Gelegenheit";

  @override
  String get order => "name";
}
