import 'package:ayron_crm/data/model/band_member.dart';
import 'package:ayron_crm/data/model/lineup.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/to_many.dart';

class Band extends Opportunity {
  Band({
    required Opportunity opportunity,
    this.publicShorttext = "",
    this.genre = "",
    this.city = "",
    required ToMany<BandMember> members,
    required ToMany<Lineup> events,
  }) : _members = members,
       _events = events,
       super.copyFrom(opportunity);

  String publicShorttext;
  String genre;
  String city;

  ToMany<BandMember> _members;
  List<BandMember> get members => _members.entities;

  ToMany<Lineup> _events;
  List<Lineup> get events => _events.entities;

  factory Band.fromJson(Map<String, dynamic> json) => Band(
    opportunity: Opportunity.fromJsonNoSubtype(json),
    publicShorttext: (json["public_shorttext"] ?? "") as String,
    genre: (json["genre"] ?? "") as String,
    city: (json["city"] ?? "") as String,
    members: ToMany.fromJson(json["members"], BandMember.fromJson),
    events: ToMany.fromJson(json["events"], Lineup.fromJson),
  );

  @override
  Map<String, dynamic> toJson() {
    var a = <String, dynamic>{
      'public_shorttext': publicShorttext,
      'genre': genre,
      'city': city,
      'members': _members.toJson(),
      'events': _events.toJson(),
    };
    a.addAll(super.toJson());
    return a;
  }

  factory Band.create(int id) => Band(
    opportunity: Opportunity.create(id),
    members: ToMany(entities: []),
    events: ToMany(entities: []),
  );
}
