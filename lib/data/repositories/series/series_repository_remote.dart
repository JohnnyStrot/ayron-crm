import 'package:ayron_crm/data/model/event_series.dart';
import 'package:ayron_crm/data/repositories/data_repository_remote.dart';
import 'package:ayron_crm/data/repositories/series/series_repository.dart';

class EventSeriesRepositoryRemote extends DataRepositoryRemote<EventSeries>
    implements EventSeriesRepository {
  EventSeriesRepositoryRemote({required super.apiService});

  @override
  EventSeries Function(Map<String, dynamic> json) get fromJson =>
      EventSeries.fromJson;

  @override
  String get typeName => "Veranstaltungsreihe";

  @override
  String get typeApiEndpoint => "event-series";
}
