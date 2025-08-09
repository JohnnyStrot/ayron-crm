import 'package:ayron_crm/data/model/event_series.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/list_widgets/opportunity_list_entry.dart';

class EventSeriesListEntry extends OpportunityListEntry<EventSeries> {
  const EventSeriesListEntry({
    super.key,
    required EventSeries series,
    required super.onDelete,
  }) : super(opportunity: series);

  @override
  String get route => Routes.series;
}
