import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/list_widgets/opportunity_list_entry.dart';
import 'package:flutter/material.dart';

class EventListEntry extends OpportunityListEntry<Event> {
  const EventListEntry({
    super.key,
    required Event event,
    required super.onDelete,
  }) : super(opportunity: event);

  @override
  String get route => Routes.events;

  @override
  Widget buildContent(BuildContext context) {
    final event = opportunity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text((event.date?.toIso8601String() ?? "").substring(0, 10)),
        Text(
          event.name,
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
                event.location?.name ?? "",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextTheme.of(context).bodySmall,
              ),
            ),
            Expanded(
              child: Text(
                event.organisation?.name ?? "",
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
