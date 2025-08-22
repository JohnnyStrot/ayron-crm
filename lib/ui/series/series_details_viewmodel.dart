import 'package:ayron_crm/data/model/event_series.dart';
import 'package:ayron_crm/data/repositories/series/series_repository.dart';
import 'package:ayron_crm/ui/details/details_viewmodel.dart';

class SeriesDetailsViewmodel
    extends DetailsViewmodel<EventSeries, SeriesDetailsViewmodel> {
  SeriesDetailsViewmodel({required EventSeriesRepository seriesRepository})
    : super(repository: seriesRepository);

  @override
  String get typeName => "Veranstaltungsreihe";
}
