import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/repositories/contact/contact_repository.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/entity_select.dart';
import 'package:flutter/material.dart';

class ContactSelect extends EntitySelect<Contact> {
  const ContactSelect({
    super.key,
    required ContactRepository super.repository,
    required super.onSelect,
    super.initialValue,
  });

  @override
  Widget buildItem(
    BuildContext context,
    Contact item,
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
          item.email,
          overflow: TextOverflow.ellipsis,
          style: TextTheme.of(context).titleSmall,
        ),
      ),
    ],
  );

  @override
  Map<String, dynamic> createFilter(String filter) => <String, dynamic>{
    "filter": filter,
  };

  @override
  String entityAsString(Contact? entity) => entity?.displayShort ?? "";

  @override
  String get label => "Kontakt";
}
