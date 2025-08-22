import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/to_many.dart';

class EventSeries extends Opportunity {
  EventSeries({
    required Opportunity opportunity,
    this.publicShorttext = "",
    required ToMany<Event> events,
  }) : _events = events,
       super.copyFrom(opportunity);

  String publicShorttext;

  ToMany<Event> _events;
  List<Event> get events => _events.entities;

  factory EventSeries.fromJson(Map<String, dynamic> json) => EventSeries(
    opportunity: Opportunity.fromJsonNoSubtype(json),
    publicShorttext: (json["publicShorttext"] ?? "") as String,
    events: ToMany.fromJson(json["events"], Event.fromJson),
  );

  @override
  Map<String, dynamic> toJson() {
    var a = <String, dynamic>{
      'publicShorttext': publicShorttext,
      'events': _events.toJson(),
    };
    a.addAll(super.toJson());
    return a;
  }

  factory EventSeries.create(int id) {
    return EventSeries(
      opportunity: Opportunity.create(id),
      events: ToMany(entities: []),
    );
  }
}
