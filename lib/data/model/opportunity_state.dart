import 'package:flutter/material.dart';

enum OpportunityState {
  none("Kein", "Kein", Color.fromARGB(0, 201, 45, 45), null),
  open("Offen", "Offen", Color.fromARGB(255, 231, 41, 28), Icons.question_mark),
  contacted(
    "Kontaktiert",
    "Kontaktiert",
    Color.fromARGB(255, 235, 97, 17),
    Icons.question_answer,
  ),
  application(
    "Bewerbung",
    "Bewerbung",
    Color.fromARGB(255, 231, 41, 28),
    Icons.assignment,
  ),
  closed(
    "Geschlossen",
    "Geschlossen",
    Color.fromARGB(255, 109, 109, 109),
    Icons.block,
  ),
  applied(
    "Beworben",
    "Beworben",
    Color.fromARGB(255, 235, 97, 17),
    Icons.schedule,
  ),
  rejected(
    "Abgelehnt",
    "Abgelehnt",
    Color.fromARGB(255, 109, 109, 109),
    Icons.block,
  ),
  ignored(
    "Ignoriert",
    "Ignoriert",
    Color.fromARGB(255, 109, 109, 109),
    Icons.block,
  ),
  accepted(
    "Angenommen",
    "Angenommen",
    Color.fromARGB(255, 235, 221, 37),
    Icons.check,
  ),
  scheduled(
    "Feststehend",
    "Feststehend",
    Color.fromARGB(255, 99, 226, 14),
    Icons.event_available,
  ),
  played(
    "Gespielt",
    "Gespielt",
    Color.fromARGB(255, 175, 175, 175),
    Icons.celebration,
  ),
  canceled(
    "Abgesagt",
    "Abgesagt",
    Color.fromARGB(255, 175, 175, 175),
    Icons.event_busy,
  );

  const OpportunityState(
    this.displayString,
    this.serializeString,
    this.color,
    this.icon,
  );

  factory OpportunityState.fromJson(String? serialized) {
    for (var element in OpportunityState.values) {
      if (element.serializeString == serialized) {
        return element;
      }
    }
    return OpportunityState.none;
  }

  String get toJson => serializeString;

  final String displayString;
  final String serializeString;
  final Color color;
  final IconData? icon;
}
