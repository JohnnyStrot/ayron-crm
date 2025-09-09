import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/model/setlist.dart';
import 'package:ayron_crm/data/model/to_many.dart';
import 'package:ayron_crm/routing/routes.dart';
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
    soundcheckTime: json["soundcheck_time"] == null
        ? null
        : TimeOfDayParse.parse(json["soundcheck_time"]),
    stagetime: json["stagetime"] == null
        ? null
        : TimeOfDayParse.parse(json["stagetime"]),
    flashback: (json["flashback"] ?? "") as String,
    showOnWebsite: (json["show_on_website"] ?? false) as bool,
    setlist: ToMany.fromJson(json["setlist"], Setlist.fromJson),
  );

  @override
  Map<String, dynamic> toJson() {
    var a = <String, dynamic>{
      'soundcheck_time': soundcheckTime?.toJson(),
      'stagetime': stagetime?.toJson(),
      'flashback': flashback,
      'show_on_website': showOnWebsite,
      'setlist': _setlist.toJson(),
    };
    a.addAll(super.toJson());
    return a;
  }

  factory Gig.create(int id) => Gig(
    event: Event.create(id),
    setlist: ToMany(entities: []),
  );

  @override
  String get typeDisplay => "Gig";

  @override
  IconData get typeIcon => Icons.stadium;
  @override
  String get route => Routes.gigs;
}
