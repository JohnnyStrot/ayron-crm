import 'package:ayron_crm/data/model/addressable.dart';
import 'package:ayron_crm/data/model/band_member.dart';
import 'package:ayron_crm/data/model/contact_protocol.dart';
import 'package:ayron_crm/data/model/opportunity_contact.dart';
import 'package:ayron_crm/data/model/to_many.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:flutter/material.dart';

import 'opportunity.dart';

class Contact extends Opportunity implements Addressable {
  Contact({
    required Opportunity opportunity,
    this.postcode = "",
    this.city = "",
    this.street = "",
    this.houseNumber = "",
    this.email = "",
    this.tel = "",
    required ToMany<ContactProtocol> contactProtocols,
    required ToMany<OpportunityContact> opportunities,
    required ToMany<BandMember> bands,
  }) : _contactProtocols = contactProtocols,
       _opportunities = opportunities,
       _bands = bands,
       super.copyFrom(opportunity);

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    opportunity: Opportunity.fromJsonNoSubtype(json),
    postcode: (json['postcode'] ?? "") as String,
    city: (json['city'] ?? "") as String,
    street: (json['street'] ?? "") as String,
    houseNumber: (json['house_number'] ?? "") as String,
    email: (json['email'] ?? "") as String,
    tel: (json['tel'] ?? "") as String,
    contactProtocols: ToMany.fromJson(
      json["contact_protocols"],
      ContactProtocol.fromJson,
    ),
    opportunities: ToMany.fromJson(
      json["opportunities"],
      OpportunityContact.fromJson,
    ),
    bands: ToMany.fromJson(json["bands"], BandMember.fromJson),
  );

  @override
  String postcode;
  @override
  String city;
  @override
  String street;
  @override
  String houseNumber;
  String email;
  String tel;

  ToMany<ContactProtocol> _contactProtocols;
  List<ContactProtocol> get contactProtocols => _contactProtocols.entities;

  ToMany<OpportunityContact> _opportunities;
  List<OpportunityContact> get opportunities => _opportunities.entities;

  ToMany<BandMember> _bands;
  List<BandMember> get bands => _bands.entities;

  @override
  Map<String, dynamic> toJson() {
    var a = <String, dynamic>{
      'postcode': postcode,
      'city': city,
      'street': street,
      'house_number': houseNumber,
      'email': email,
      'tel': tel,
      'opportunities': _opportunities.toJson(),
      'bands': _bands.toJson(),
    };
    a.addAll(super.toJson());
    return a;
  }

  factory Contact.create(int id) => Contact(
    opportunity: Opportunity.create(id),
    bands: ToMany(entities: []),
    contactProtocols: ToMany(entities: []),
    opportunities: ToMany(entities: []),
  );

  @override
  String get displayShort => name.isEmpty
      ? email.isEmpty
            ? instagram.isEmpty
                  ? tel
                  : instagram
            : email
      : name;

  IconData get displayIcon => name.isEmpty
      ? email.isEmpty
            ? instagram.isEmpty
                  ? Icons.phone
                  : Icons.alternate_email
            : Icons.mail
      : Icons.person;

  @override
  String get typeDisplay => "Kontakt";

  @override
  IconData get typeIcon => Icons.person;

  @override
  String get route => Routes.contacts;

  @override
  String get address => [
    [
      if (street.isNotEmpty) street,
      if (houseNumber.isNotEmpty) houseNumber,
    ].join(" "),
    [if (postcode.isNotEmpty) postcode, if (city.isNotEmpty) city].join(" "),
  ].join(", ");
}
