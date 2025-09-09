import 'dart:convert';

import 'package:ayron_crm/data/model/band_member.dart';
import 'package:test/test.dart';

void main() {
  test('Band Member with null associations should be created', () {
    var b = BandMember.fromJson(
      jsonDecode('{"band": null, "contact": null, "instrument": "Harfe"}'),
    );
    expect(b.instrument, "Harfe");
    expect(b.band, isNull);
    expect(b.bandId, isNull);
    expect(b.contact, isNull);
    expect(b.contactId, isNull);
  });
  test('Band Member with associated band should be created', () {
    var json =
        '{"band": {"id": 0, "name": "Ayran"}, "contact": null, "instrument": ""}';

    var b = BandMember.fromJson(jsonDecode(json));

    expect(b.band, isNotNull);
    expect(b.band!.name, "Ayran");
  });
  test('Band Member with associated member should be created', () {
    var json =
        '{"band": null, "contact": {"id": 0, "name": "Johannes"}, "instrument": ""}';

    var b = BandMember.fromJson(jsonDecode(json));

    expect(b.contact, isNotNull);
    expect(b.contact!.name, "Johannes");
  });
  test(
    'Band Member with associated member, given only id, should be created',
    () {
      var json = '{"band": null, "contact_id": 0, "instrument": ""}';

      var b = BandMember.fromJson(jsonDecode(json));

      expect(b.contact, isNull);
      expect(b.contactId, isNotNull);
      expect(b.contactId, 0);
    },
  );
}
