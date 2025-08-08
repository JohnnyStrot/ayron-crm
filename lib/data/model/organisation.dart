import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/to_many.dart';

class Organisation extends Opportunity {
  Organisation({
    required Opportunity opportunity,
    this.publicShorttext = "",
    required ToMany<Event> events,
  }) : _events = events,
       super.copyFrom(opportunity);

  String publicShorttext;

  ToMany<Event> _events;
  List<Event> get events => _events.entities;

  factory Organisation.fromJson(Map<String, dynamic> json) => Organisation(
    opportunity: Opportunity.fromJsonNoSubtype(json),
    publicShorttext: (json["publicShorttext"] ?? "") as String,
    events: ToMany.fromJson(json["events"], Event.fromJson),
  );

  factory Organisation.create(int id) => Organisation(
    opportunity: Opportunity.create(id),
    events: ToMany(entities: []),
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
}
