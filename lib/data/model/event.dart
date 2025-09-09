import 'package:ayron_crm/data/model/event_series.dart';
import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/data/model/lineup.dart';
import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/organisation.dart';
import 'package:ayron_crm/data/model/to_many.dart';
import 'package:ayron_crm/data/model/to_one.dart';
import 'package:flutter/material.dart';
import 'package:ayron_crm/utils/datetime_extension.dart';

class Event extends Opportunity {
  Event({
    required Opportunity opportunity,
    this.date,
    this.doors,
    this.begin,
    this.price = "",
    this.summary = "",
    this.description = "",
    this.tickets = "",
    required ToOne<EventSeries> series,
    required ToMany<Lineup> lineup,
    required ToOne<Location> location,
    required ToOne<Organisation> organisation,
  }) : _series = series,
       _lineup = lineup,
       _location = location,
       _organisation = organisation,
       super.copyFrom(opportunity);

  Event.copyFrom(Event copyFrom)
    : this(
        opportunity: copyFrom,
        date: copyFrom.date,
        doors: copyFrom.doors,
        begin: copyFrom.begin,
        price: copyFrom.price,
        summary: copyFrom.summary,
        description: copyFrom.description,
        tickets: copyFrom.tickets,
        series: copyFrom._series,
        lineup: copyFrom._lineup,
        location: copyFrom._location,
        organisation: copyFrom._organisation,
      );

  DateTime? date;
  TimeOfDay? doors;
  TimeOfDay? begin;
  String price;
  String summary;
  String description;
  String tickets;

  ToOne<EventSeries> _series;
  EventSeries? get series => _series.entity;
  int? get seriesId => _series.id;
  set series(EventSeries? s) {
    _series.entity = s;
  }

  ToMany<Lineup> _lineup;
  List<Lineup> get lineup => _lineup.entities;

  ToOne<Location> _location;
  Location? get location => _location.entity;
  set location(Location? l) {
    _location.entity = l;
  }

  int? get locationId => _location.id;

  ToOne<Organisation> _organisation;
  Organisation? get organisation => _organisation.entity;
  set organisation(Organisation? o) {
    _organisation.entity = o;
  }

  int? get organisationId => _organisation.id;

  factory Event.fromJsonNoSubtype(Map<String, dynamic> json) => Event(
    opportunity: Opportunity.fromJsonNoSubtype(json),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    doors: json["doors"] == null ? null : TimeOfDayParse.parse(json["doors"]),
    begin: json["begin"] == null ? null : TimeOfDayParse.parse(json["begin"]),
    price: (json['price'] ?? "") as String,
    summary: (json['summary'] ?? "") as String,
    description: (json['description'] ?? "") as String,
    tickets: (json['tickets'] ?? "") as String,
    series: ToOne.fromJson(json, EventSeries.fromJson, "series"),
    lineup: ToMany.fromJson(json["lineup"], Lineup.fromJson),
    location: ToOne.fromJson(json, Location.fromJson, "location"),
    organisation: ToOne.fromJson(json, Organisation.fromJson, "organisation"),
  );

  factory Event.fromJson(Map<String, dynamic> json) {
    if (json["__class__"] == "gig") {
      return Gig.fromJson(json);
    } else {
      return Event.fromJsonNoSubtype(json);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    var a = <String, dynamic>{
      'date': date?.toIso8601String(),
      'doors': doors?.toJson(),
      'begin': begin?.toJson(),
      'price': price,
      'summary': summary,
      'description': description,
      'tickets': tickets,
      'lineup': _lineup.toJson(),
    };
    a.addEntries([
      _series.toJson("series"),
      _location.toJson("location"),
      _organisation.toJson("organisation"),
    ]);
    a.addAll(super.toJson());
    return a;
  }

  factory Event.create(int id) => Event(
    opportunity: Opportunity.create(id),
    series: ToOne(),
    lineup: ToMany(entities: []),
    location: ToOne(),
    organisation: ToOne(),
  );

  @override
  String get typeDisplay => "Veranstaltung";
  @override
  IconData get typeIcon => Icons.festival;
}
