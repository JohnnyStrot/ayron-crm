import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/opportunity/opportunity_list_entry.dart';
import 'package:flutter/material.dart';

class ContactListEntry extends OpportunityListEntry<Contact> {
  const ContactListEntry({
    super.key,
    required Contact contact,
    required super.onDelete,
  }) : super(opportunity: contact);

  @override
  String route(op) => Routes.contacts;

  @override
  String opportunityToString(Contact opp) => opp.displayShort;

  @override
  Widget buildContent(BuildContext context) {
    final contact = opportunity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          contact.displayShort,
          overflow: TextOverflow.ellipsis,
          style: TextTheme.of(context).displaySmall!.copyWith(
            fontSize: TextTheme.of(context).bodyLarge!.fontSize,
          ),
        ),
        Row(
          spacing: Dimens.hgap,
          children: [
            Expanded(
              child: Text(
                contact.instagram != "" ? "@${contact.instagram}" : "",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextTheme.of(context).bodySmall,
              ),
            ),
            Expanded(
              child: Text(
                contact.tel,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: TextTheme.of(context).bodySmall,
              ),
            ),
          ],
        ),
        Row(
          spacing: Dimens.hgap,
          children: [
            Expanded(
              child: Text(
                contact.email,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextTheme.of(context).bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
