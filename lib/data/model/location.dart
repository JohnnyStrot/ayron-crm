import 'package:ayron_crm/data/model/addressable.dart';
import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/model/to_many.dart';

import 'opportunity.dart';

class Location extends Opportunity implements Addressable {
  Location({
    required Opportunity opportunity,
    this.postcode = "",
    this.city = "",
    this.street = "",
    this.houseNumber = "",
    this.googlemaps = "",
    this.publicShorttext = "",
    required ToMany<Event> events,
  }) : _events = events,
       super.copyFrom(opportunity);

  factory Location.create(int id) => Location(
    opportunity: Opportunity.create(id),
    events: ToMany(entities: []),
  );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    opportunity: Opportunity.fromJsonNoSubtype(json),
    postcode: (json['postcode'] ?? "") as String,
    city: (json['city'] ?? "") as String,
    street: (json['street'] ?? "") as String,
    houseNumber: (json['house_number'] ?? "") as String,
    googlemaps: (json['googlemaps'] ?? "") as String,
    publicShorttext: (json['public_shorttext'] ?? "") as String,
    events: ToMany.fromJson(json["events"], Event.fromJson),
  );

  @override
  String postcode;
  @override
  String city;
  @override
  String street;
  @override
  String houseNumber;
  String googlemaps;
  String publicShorttext;

  ToMany<Event> _events;
  List<Event> get events => _events.entities;

  @override
  Map<String, dynamic> toJson() {
    var a = <String, dynamic>{
      'postcode': postcode,
      'city': city,
      'street': street,
      'houseNumber': houseNumber,
      'googlemaps': googlemaps,
      'public_shorttext': publicShorttext,
    };
    a.addAll(super.toJson());
    return a;
  }
}
