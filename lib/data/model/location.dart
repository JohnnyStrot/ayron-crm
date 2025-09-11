import 'package:ayron_crm/data/model/addressable.dart';
import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/model/to_many.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:flutter/material.dart';

import 'opportunity.dart';

class Location extends Opportunity implements Addressable {
  Location({
    required Opportunity opportunity,
    this.postcode = "",
    this.city = "",
    this.street = "",
    this.houseNumber = "",
    this.googlemaps = "",
    this.logo,
    required this.images,
    this.publicShorttext = "",
    required ToMany<Event> events,
  }) : _events = events,
       super.copyFrom(opportunity);

  factory Location.create(int id) => Location(
    opportunity: Opportunity.create(id),
    events: ToMany(entities: []),
    images: [],
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
    logo: json["logo"] as String?,
    images:
        (json["images"] as List<dynamic>?)?.map((c) => c as String).toList() ??
        [],
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

  String? logo;
  List<String> images;

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
      'logo': logo,
    };
    a.addAll(super.toJson());
    return a;
  }

  @override
  String get typeDisplay => "Location";
  @override
  IconData get typeIcon => Icons.location_on;

  @override
  String get route => Routes.locations;

  @override
  String get address => [
    [
      if (street.isNotEmpty) street,
      if (houseNumber.isNotEmpty) houseNumber,
    ].join(" "),
    [if (postcode.isNotEmpty) postcode, if (city.isNotEmpty) city].join(" "),
  ].join(", ");
}
