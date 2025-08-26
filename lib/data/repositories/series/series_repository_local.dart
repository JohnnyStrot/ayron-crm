import 'package:ayron_crm/config/assets.dart';
import 'package:ayron_crm/data/model/event_series.dart';
import 'package:ayron_crm/data/repositories/data_repository_local.dart';
import 'package:ayron_crm/data/repositories/series/series_repository.dart';

class EventSeriesRepositoryLocal extends DataRepositoryLocal<EventSeries>
    implements EventSeriesRepository {
  EventSeriesRepositoryLocal({required super.localDataService});

  @override
  String get assetFile => Assets.series;

  @override
  bool filter(EventSeries entity, Map<String, dynamic>? search) {
    if (search == null) return true;
    return (search["name"] == null
            ? true
            : entity.name.toLowerCase().contains(
                search["name"].toLowerCase(),
              )) &&
        (search["state"] == null ? true : entity.state == search["state"]);
  }

  @override
  EventSeries Function(Map<String, dynamic> json) get fromJson =>
      EventSeries.fromJson;

  @override
  EventSeries newEntity(int id) => EventSeries.create(id);

  @override
  String get typeName => "EventSeries";
}
