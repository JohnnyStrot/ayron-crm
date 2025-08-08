import 'package:ayron_crm/data/model/addressable.dart';
import 'package:ayron_crm/data/model/band_member.dart';
import 'package:ayron_crm/data/model/contact_protocol.dart';
import 'package:ayron_crm/data/model/opportunity_contact.dart';
import 'package:ayron_crm/data/model/to_many.dart';

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
    houseNumber: (json['houseNumber'] ?? "") as String,
    email: (json['email'] ?? "") as String,
    tel: (json['tel'] ?? "") as String,
    contactProtocols: ToMany.fromJson(
      json["contactProtocols"],
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
      'houseNumber': houseNumber,
      'email': email,
      'tel': tel,
      'contactProtocols': _contactProtocols.toJson(),
      'opportunities': _opportunities.toJson(),
      'bands': _bands.toJson(),
    };
    a.addAll(super.toJson());
    return a;
  }
}
