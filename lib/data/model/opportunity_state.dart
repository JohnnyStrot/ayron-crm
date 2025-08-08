import 'dart:ui';

enum OpportunityState {
  none("Kein", "", Color.fromARGB(0, 0, 0, 0)),
  open("Offen", "", Color.fromARGB(0, 0, 0, 0)),
  contacted("Kontaktiert", "", Color.fromARGB(0, 0, 0, 0)),
  application("Bewerbung", "", Color.fromARGB(0, 0, 0, 0)),
  closed("Geschlossen", "", Color.fromARGB(0, 0, 0, 0)),
  applied("Beworben", "", Color.fromARGB(0, 0, 0, 0)),
  rejected("Abgelehnt", "", Color.fromARGB(0, 0, 0, 0)),
  ignored("Ignoriert", "", Color.fromARGB(0, 0, 0, 0)),
  accepted("Angenommen", "", Color.fromARGB(0, 0, 0, 0)),
  scheduled("Feststehend", "", Color.fromARGB(0, 0, 0, 0)),
  played("Gespielt", "", Color.fromARGB(0, 0, 0, 0)),
  canceled("Abgesagt", "", Color.fromARGB(0, 0, 0, 0));

  const OpportunityState(this.displayString, this.serializeString, this.color);

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
}
