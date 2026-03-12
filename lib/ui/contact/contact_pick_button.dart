import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/repositories/contact/contact_repository.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/entity_pick_button.dart';
import 'package:flutter/material.dart';

class ContactPickButton extends EntityPickButton<Contact> {
  const ContactPickButton({
    super.key,
    required ContactRepository super.repository,
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
  String entityAsString(Opportunity? entity) => entity?.name ?? "";

  @override
  String get label => "Kontakt";

  @override
  String get order => "name";
}
