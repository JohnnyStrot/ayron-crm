import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/model/setlist.dart';
import 'package:ayron_crm/data/model/to_many.dart';
import 'package:ayron_crm/utils/datetime_extension.dart';
import 'package:flutter/material.dart';

class Gig extends Event {
  Gig({
    required Event event,
    this.soundcheckTime,
    this.stagetime,
    this.flashback = "",
    this.showOnWebsite = false,
    required ToMany<Setlist> setlist,
  }) : _setlist = setlist,
       super.copyFrom(event);

  TimeOfDay? soundcheckTime;
  TimeOfDay? stagetime;
  String flashback;
  bool showOnWebsite;

  ToMany<Setlist> _setlist;
  List<Setlist> get setlist => _setlist.entities;

  factory Gig.fromJson(Map<String, dynamic> json) => Gig(
    event: Event.fromJsonNoSubtype(json),
    soundcheckTime: json["soundcheckTime"] == null
        ? null
        : TimeOfDayParse.parse(json["soundcheckTime"]),
    stagetime: json["stagetime"] == null
        ? null
        : TimeOfDayParse.parse(json["stagetime"]),
    flashback: (json["flashback"] ?? "") as String,
    showOnWebsite: json["showOnWebsite"] as bool,
    setlist: ToMany.fromJson(json["setlist"], Setlist.fromJson),
  );

  @override
  Map<String, dynamic> toJson() {
    var a = <String, dynamic>{
      'soundcheckTime': soundcheckTime?.toJson(),
      'stagetime': stagetime?.toJson(),
      'flashback': flashback,
      'showOnWebsite': showOnWebsite,
      'setlist': _setlist.toJson(),
    };
    a.addAll(super.toJson());
    return a;
  }
}
