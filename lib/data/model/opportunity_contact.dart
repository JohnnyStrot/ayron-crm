import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/model/to_one.dart';

class OpportunityContact implements WeakEntity {
  OpportunityContact({
    required ToOne<Opportunity> opportunity,
    required ToOne<Contact> contact,
    this.role = "",
  }) : _contact = contact,
       _opportunity = opportunity;

  ToOne<Contact> _contact;
  Contact? get contact => _contact.entity;
  int? get contactId => _contact.id;

  ToOne<Opportunity> _opportunity;
  Opportunity? get opportunity => _opportunity.entity;
  int? get opportunityId => _opportunity.id;

  String role;

  factory OpportunityContact.fromJson(Map<String, dynamic> json) =>
      OpportunityContact(
        opportunity: ToOne.fromJson(json, Opportunity.fromJson, "opportunity"),
        contact: ToOne.fromJson(json, Contact.fromJson, "contact"),
        role: json["role"] ?? "",
      );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{'role': role};
    map.addEntries([
      _contact.toJson("contact"),
      _opportunity.toJson("opportunity"),
    ]);
    return map;
  }
}
