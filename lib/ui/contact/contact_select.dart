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
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    spacing: Dimens.hgap,
    children: [
      Expanded(child: Text(item.displayShort, overflow: TextOverflow.ellipsis)),
      Expanded(
        child: Column(
          children: [
            Text(
              item.tel,
              style: TextTheme.of(context).bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              item.email,
              style: TextTheme.of(context).bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              item.instagram.isNotEmpty ? "@${item.instagram}" : "",
              style: TextTheme.of(context).bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ],
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

  @override
  String get order => "name";
}
