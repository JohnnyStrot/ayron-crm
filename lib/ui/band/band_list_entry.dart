import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/list_widgets/opportunity_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class BandListEntry extends OpportunityListEntry<Band> {
  const BandListEntry({super.key, required Band band, required super.onDelete})
    : super(opportunity: band);

  @override
  String get route => Routes.bands;

  @override
  Widget buildContent(BuildContext context) {
    final band = opportunity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          band.name,
          overflow: TextOverflow.ellipsis,
          style: TextTheme.of(context).displaySmall!.copyWith(
            fontSize: TextTheme.of(context).bodyLarge!.fontSize,
          ),
        ),
        Row(
          spacing: Dimens.hgap,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(band.city), Text(band.genre)],
        ),
      ],
    );
  }
}
