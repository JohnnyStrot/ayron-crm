import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/repositories/data_repository_remote.dart';
import 'package:ayron_crm/data/repositories/event/event_repository.dart';

class EventRepositoryRemote extends DataRepositoryRemote<Event>
    implements EventRepository {
  EventRepositoryRemote({required super.apiService});

  @override
  Event Function(Map<String, dynamic> json) get fromJson => Event.fromJson;

  @override
  String get typeName => "Veranstaltung";

  @override
  String get typeApiEndpoint => "event";
}
