import 'package:ayron_crm/data/model/contact_protocol.dart';
import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/model/opportunity_contact.dart';
import 'package:ayron_crm/data/model/opportunity_state.dart';
import 'package:ayron_crm/data/model/to_many.dart';

import 'location.dart';

class Opportunity extends StrongEntity {
  Opportunity({
    required this.id,
    this.name = "",
    this.info = "",
    this.state = OpportunityState.none,
    this.stateText = "",
    required this.createdAt,
    required this.updatedAt,
    this.instagram = "",
    this.xtwitter = "",
    this.facebook = "",
    this.reddit = "",
    this.web = "",
    this.youtube = "",
    required ToMany<OpportunityContact> contacts,
    required ToMany<ContactProtocol> protocols,
  }) : _contacts = contacts,
       _protocols = protocols;

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    switch (json["__class__"]) {
      case "location":
        return Location.fromJson(json);
      default:
        return Opportunity.fromJsonNoSubtype(json);
    }
  }

  factory Opportunity.fromJsonNoSubtype(Map<String, dynamic> json) =>
      Opportunity(
        id: (json['id'] as num).toInt(),
        name: (json['name'] ?? "") as String,
        info: (json['info'] ?? "") as String,
        state: OpportunityState.fromJson((json['state'] ?? "") as String),
        stateText: (json['stateText'] ?? "") as String,
        createdAt: json['createdAt'] == null
            ? DateTime.now()
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? DateTime.now()
            : DateTime.parse(json['updatedAt'] as String),
        instagram: (json['instagram'] ?? "") as String,
        xtwitter: (json['xtwitter'] ?? "") as String,
        facebook: (json['facebook'] ?? "") as String,
        reddit: (json['reddit'] ?? "") as String,
        web: (json['web'] ?? "") as String,
        youtube: (json['youtube'] ?? "") as String,
        contacts: ToMany.fromJson(
          json["contacts"],
          OpportunityContact.fromJson,
        ),
        protocols: ToMany.fromJson(json["protocols"], ContactProtocol.fromJson),
      );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'info': info,
    'state': state.toJson,
    'stateText': stateText,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'instagram': instagram,
    'xtwitter': xtwitter,
    'facebook': facebook,
    'reddit': reddit,
    'web': web,
    'youtube': youtube,
    'contacts': _contacts.toJson(),
    'protocols': _protocols.toJson(),
  };

  Opportunity.copyFrom(Opportunity copyFrom)
    : this(
        id: copyFrom.id,
        name: copyFrom.name,
        info: copyFrom.info,
        state: copyFrom.state,
        stateText: copyFrom.stateText,
        createdAt: copyFrom.createdAt,
        updatedAt: copyFrom.updatedAt,
        instagram: copyFrom.instagram,
        xtwitter: copyFrom.xtwitter,
        facebook: copyFrom.facebook,
        reddit: copyFrom.reddit,
        web: copyFrom.web,
        youtube: copyFrom.youtube,
        contacts: copyFrom._contacts,
        protocols: copyFrom._protocols,
      );

  @override
  int id;
  String name;
  String info;
  OpportunityState state;
  String stateText;
  DateTime createdAt;
  DateTime updatedAt;
  String instagram;
  String xtwitter;
  String facebook;
  String reddit;
  String web;
  String youtube;

  ToMany<OpportunityContact> _contacts;
  List<OpportunityContact> get contacts => _contacts.entities;

  ToMany<ContactProtocol> _protocols;
  List<ContactProtocol> get protocols => _protocols.entities;
}
