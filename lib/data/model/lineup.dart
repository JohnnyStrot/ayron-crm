import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/model/to_one.dart';
import 'package:ayron_crm/utils/datetime_extension.dart';
import 'package:flutter/material.dart';

class Lineup implements WeakEntity {
  Lineup({
    required ToOne<Band> band,
    required ToOne<Event> event,
    this.soundcheckTime,
    this.stagetime,
    this.stage = "",
  }) : _event = event,
       _band = band;

  ToOne<Event> _event;
  Event? get event => _event.entity;
  int? get eventId => _event.id;

  ToOne<Band> _band;
  Band? get band => _band.entity;
  int? get bandId => _band.id;

  TimeOfDay? soundcheckTime;
  TimeOfDay? stagetime;
  String stage;

  factory Lineup.fromJson(Map<String, dynamic> json) => Lineup(
    band: ToOne.fromJson(json, Band.fromJson, "band"),
    event: ToOne.fromJson(json, Event.fromJson, "event"),
    soundcheckTime: json["soundcheckTime"] == null
        ? null
        : TimeOfDayParse.parse(json["soundcheckTime"]),
    stagetime: json["stagetime"] == null
        ? null
        : TimeOfDayParse.parse(json["stagetime"]),
    stage: (json["stage"] ?? "") as String,
  );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{
      'soundcheckTime': soundcheckTime?.toJson(),
      'stagetime': stagetime?.toJson(),
      'stage': stage,
    };
    map.addEntries([_event.toJson("event"), _band.toJson("band")]);
    return map;
  }
}
