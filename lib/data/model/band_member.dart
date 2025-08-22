import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/model/to_one.dart';

class BandMember implements WeakEntity {
  BandMember({
    required ToOne<Band> band,
    required ToOne<Contact> member,
    this.instrument = "",
  }) : _member = member,
       _band = band;

  ToOne<Contact> _member;
  Contact? get member => _member.entity;
  set member(Contact? l) {
    _member.entity = l;
  }

  int? get memberId => _member.id;

  ToOne<Band> _band;
  Band? get band => _band.entity;
  int? get bandId => _band.id;
  set band(Band? l) {
    _band.entity = l;
  }

  String instrument;

  factory BandMember.fromJson(Map<String, dynamic> json) => BandMember(
    band: ToOne.fromJson(json, Band.fromJson, "band"),
    member: ToOne.fromJson(json, Contact.fromJson, "member"),
    instrument: json["instrument"] ?? "",
  );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{'instrument': instrument};
    map.addEntries([_member.toJson("member"), _band.toJson("band")]);
    return map;
  }
}
