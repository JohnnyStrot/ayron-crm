import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/rounded_image_icon.dart';
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
        Row(
          spacing: Dimens.hgap,
          children: [
            if (gig.thumbnail != null)
              RoundedImageIcon(
                imageLocation: "gig/thumbnail/${gig.id}/${gig.thumbnail}",
                size: 30,
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: Dimens.hgap,
                    children: [
                      Expanded(
                        child: Text(
                          (gig.date?.toIso8601String().substring(0, 10) ?? ""),
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
                  Text(
                    gig.location != null
                        ? "${gig.location!.name}${gig.location!.city.isNotEmpty ? ", ${gig.location!.city}" : ""}"
                        : "",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextTheme.of(context).bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        Text(
          gig.name,
          overflow: TextOverflow.ellipsis,
          style: TextTheme.of(context).displaySmall!.copyWith(
            fontSize: TextTheme.of(context).bodyLarge!.fontSize,
          ),
        ),
      ],
    );
  }
}
