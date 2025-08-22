import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/repositories/event/event_repository.dart';
import 'package:ayron_crm/ui/details/details_viewmodel.dart';

class EventDetailsViewmodel
    extends DetailsViewmodel<Event, EventDetailsViewmodel> {
  EventDetailsViewmodel({required EventRepository eventRepository})
    : super(repository: eventRepository);

  @override
  String get typeName => "Veranstaltung";
}
