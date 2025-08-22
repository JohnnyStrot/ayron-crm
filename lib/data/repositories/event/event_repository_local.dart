import 'package:ayron_crm/config/assets.dart';
import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/repositories/data_repository_local.dart';
import 'package:ayron_crm/data/repositories/event/event_repository.dart';

class EventRepositoryLocal extends DataRepositoryLocal<Event>
    implements EventRepository {
  EventRepositoryLocal({required super.localDataService});

  @override
  String get assetFile => Assets.gigs;

  @override
  bool filter(Event entity, Map<String, dynamic> search) {
    return (search["name"] == null
            ? true
            : entity.name.toLowerCase().contains(
                search["name"].toLowerCase(),
              )) &&
        (search["state"] == null ? true : entity.state == search["state"]);
  }

  @override
  Event Function(Map<String, dynamic> json) get fromJson => Event.fromJson;

  @override
  Event newEntity(int id) => Event.create(id);

  @override
  String get typeName => "Event";
}
