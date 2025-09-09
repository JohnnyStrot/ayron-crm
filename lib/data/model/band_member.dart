import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/model/to_one.dart';

class BandMember implements WeakEntity {
  BandMember({
    required ToOne<Band> band,
    required ToOne<Contact> contact,
    this.instrument = "",
  }) : _contact = contact,
       _band = band;

  ToOne<Contact> _contact;
  Contact? get contact => _contact.entity;
  set contact(Contact? l) {
    _contact.entity = l;
  }

  int? get contactId => _contact.id;

  ToOne<Band> _band;
  Band? get band => _band.entity;
  int? get bandId => _band.id;
  set band(Band? l) {
    _band.entity = l;
  }

  String instrument;

  factory BandMember.fromJson(Map<String, dynamic> json) => BandMember(
    band: ToOne.fromJson(json, Band.fromJson, "band"),
    contact: ToOne.fromJson(json, Contact.fromJson, "contact"),
    instrument: json["instrument"] ?? "",
  );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{'instrument': instrument};
    map.addEntries([_contact.toJson("contact"), _band.toJson("band")]);
    return map;
  }
}
