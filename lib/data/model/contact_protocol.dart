import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/to_one.dart';

class ContactProtocol implements StrongEntity {
  ContactProtocol({
    required this.id,
    required this.timestamp,
    this.type = "",
    this.user = "",
    this.content = "",
    required ToOne<Opportunity> opportunity,
    required ToOne<Contact> contact,
  }) : _contact = contact,
       _opportunity = opportunity;

  @override
  int id;
  DateTime timestamp;
  String type;
  String user;
  String content;

  ToOne<Opportunity> _opportunity;
  Opportunity? get opportunity => _opportunity.entity;
  int? get opportunityId => _opportunity.id;

  ToOne<Contact> _contact;
  Contact? get contact => _contact.entity;
  int? get contactId => _contact.id;

  factory ContactProtocol.fromJson(Map<String, dynamic> json) =>
      ContactProtocol(
        id: (json['id'] as num).toInt(),
        timestamp: json["timestamp"] == null
            ? DateTime.now()
            : DateTime.parse(json["timestamp"]),
        type: json["type"] ?? "",
        user: json["user"] ?? "",
        content: json["content"] ?? "",
        opportunity: ToOne.fromJson(json, Opportunity.fromJson, "opportunity"),
        contact: ToOne.fromJson(json, Contact.fromJson, "contact"),
      );

  @override
  Map<String, dynamic> toJson() {
    var a = <String, dynamic>{
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'user': user,
      'content': content,
    };
    a.addEntries([
      _opportunity.toJson("opportunity"),
      _contact.toJson("contact"),
    ]);
    return a;
  }
}
