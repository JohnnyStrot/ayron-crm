import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/list_widgets/opportunity_list_entry.dart';

class EventListEntry extends OpportunityListEntry<Event> {
  const EventListEntry({
    super.key,
    required Event event,
    required super.onDelete,
  }) : super(opportunity: event);

  @override
  String get route => Routes.events;
}
