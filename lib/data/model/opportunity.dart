import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/contact_protocol.dart';
import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/model/event_series.dart';
import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/data/model/opportunity_contact.dart';
import 'package:ayron_crm/data/model/opportunity_state.dart';
import 'package:ayron_crm/data/model/organisation.dart';
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
      case "band":
        return Band.fromJson(json);
      case "contact":
        return Contact.fromJson(json);
      case "event_series":
        return EventSeries.fromJson(json);
      case "gig":
        return Gig.fromJson(json);
      case "organisation":
        return Organisation.fromJson(json);
      case "event":
        return Event.fromJson(json);
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
        stateText: (json['state_text'] ?? "") as String,
        createdAt: json['created_at'] == null
            ? DateTime.now()
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? DateTime.now()
            : DateTime.parse(json['updated_at'] as String),
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
    'state_text': stateText,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'instagram': instagram,
    'xtwitter': xtwitter,
    'facebook': facebook,
    'reddit': reddit,
    'web': web,
    'youtube': youtube,
    'contacts': _contacts.toJson(),
    'protocols': _protocols.toJson(),
  };

  factory Opportunity.create(int id) => Opportunity(
    id: id,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    contacts: ToMany(entities: []),
    protocols: ToMany(entities: []),
  );

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

  @override
  String get displayShort => name;
}
