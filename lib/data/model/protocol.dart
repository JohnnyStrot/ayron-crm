import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/to_many.dart';
import 'package:flutter/material.dart';

class Protocol implements StrongEntity {
  Protocol({
    required this.id,
    required this.timestamp,
    this.type = "",
    this.user = "",
    this.content = "",
    required ToMany<Opportunity> opportunities,
    required ToMany<Contact> contacts,
  }) : _contacts = contacts,
       _opportunities = opportunities;

  @override
  int id;
  DateTime timestamp;
  String type;
  String user;
  String content;

  ToMany<Opportunity> _opportunities;
  List<Opportunity>? get opportunities => _opportunities.entities;

  ToMany<Contact> _contacts;
  List<Contact>? get contacts => _contacts.entities;

  IconData get icon => getIcon(type);

  static IconData getIcon(String type) {
    switch (type) {
      case "Telefon":
        return Icons.phone;
      case "Textnachricht":
        return Icons.chat;
      case "E-Mail":
        return Icons.mail;
      case "Gespräch":
        return Icons.spatial_audio;
      case "Schriftlich":
        return Icons.history_edu;
      case "Sprachnachricht":
        return Icons.voice_chat;
      default:
        return Icons.question_mark;
    }
  }

  @override
  String get displayShort => "$type #$id";

  factory Protocol.fromJson(Map<String, dynamic> json) => Protocol(
    id: (json['id'] as num).toInt(),
    timestamp: json["timestamp"] == null
        ? DateTime.now()
        : DateTime.parse(json["timestamp"]),
    type: json["type"] ?? "",
    user: json["user"] ?? "",
    content: json["content"] ?? "",
    opportunities: ToMany.fromJson(json["opportunities"], Opportunity.fromJson),
    contacts: ToMany.fromJson(json["contacts"], Contact.fromJson),
  );

  @override
  Map<String, dynamic> toJson() {
    var a = <String, dynamic>{
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'user': user,
      'content': content,
      "opportunities": _opportunities.toJson(),
      "contacts": _contacts.toJson(),
    };
    return a;
  }
}
