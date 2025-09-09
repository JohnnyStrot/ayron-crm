import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/opportunity/opportunity_list_entry.dart';
import 'package:flutter/material.dart';

class LocationListEntry extends OpportunityListEntry<Location> {
  const LocationListEntry({
    super.key,
    required super.opportunity,
    required super.onDelete,
  });

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          opportunity.name,
          overflow: TextOverflow.ellipsis,
          style: TextTheme.of(context).displaySmall!.copyWith(
            fontSize: TextTheme.of(context).bodyLarge!.fontSize,
          ),
        ),
        Text(opportunity.city),
      ],
    );
  }

  @override
  String route(op) => Routes.locations;
}
