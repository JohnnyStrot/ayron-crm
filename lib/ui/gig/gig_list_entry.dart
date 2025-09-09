import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/opportunity/opportunity_list_entry.dart';
import 'package:flutter/material.dart';

class GigListEntry extends OpportunityListEntry<Gig> {
  const GigListEntry({super.key, required Gig gig, required super.onDelete})
    : super(opportunity: gig);

  @override
  String route(op) => Routes.gigs;

  @override
  Widget buildContent(BuildContext context) {
    final gig = opportunity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text((gig.date?.toIso8601String() ?? "").substring(0, 10)),
        Text(
          gig.name,
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
                gig.location?.name ?? "",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextTheme.of(context).bodySmall,
              ),
            ),
            Expanded(
              child: Text(
                gig.organisation?.name ?? "",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: TextTheme.of(context).bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
