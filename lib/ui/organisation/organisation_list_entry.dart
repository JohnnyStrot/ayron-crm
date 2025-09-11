import 'package:ayron_crm/data/model/organisation.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/ui/rounded_image_icon.dart';
import 'package:ayron_crm/ui/opportunity/opportunity_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class OrganisationListEntry extends OpportunityListEntry<Organisation> {
  const OrganisationListEntry({
    super.key,
    required Organisation organisation,
    required super.onDelete,
  }) : super(opportunity: organisation);

  @override
  String route(op) => Routes.organisations;

  @override
  Widget buildContent(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            opportunity.name,
            overflow: TextOverflow.ellipsis,
            style: TextTheme.of(context).displaySmall!.copyWith(
              fontSize: TextTheme.of(context).bodyLarge!.fontSize,
            ),
          ),
        ),
        if (opportunity.logo != null)
          RoundedImageIcon(
            imageLocation:
                "organisation/logo/${opportunity.id}/${opportunity.logo}",
            size: 40,
          ),
      ],
    );
  }
}
