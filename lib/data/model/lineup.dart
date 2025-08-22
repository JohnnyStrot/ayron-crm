import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/model/to_one.dart';
import 'package:ayron_crm/utils/datetime_extension.dart';
import 'package:flutter/material.dart';

class Lineup implements WeakEntity {
  Lineup({
    required ToOne<Band> band,
    required ToOne<Band> event,
    this.soundcheckTime,
    this.stagetime,
    this.stage = "",
  }) : _event = event,
       _band = band;

  ToOne<Band> _event;
  Band? get event => _event.entity;
  set event(Band? l) {
    _event.entity = l;
  }

  int? get eventId => _event.id;

  ToOne<Band> _band;
  Band? get band => _band.entity;
  set band(Band? l) {
    _band.entity = l;
  }

  int? get bandId => _band.id;

  TimeOfDay? soundcheckTime;
  TimeOfDay? stagetime;
  String stage;

  factory Lineup.fromJson(Map<String, dynamic> json) => Lineup(
    band: ToOne.fromJson(json, Band.fromJson, "band"),
    event: ToOne.fromJson(json, Band.fromJson, "event"),
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
