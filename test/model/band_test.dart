import 'dart:convert';

import 'package:ayron_crm/data/model/band_member.dart';
import 'package:test/test.dart';

void main() {
  test('Band Member with null associations should be created', () {
    var b = BandMember.fromJson(
      jsonDecode('{"band": null, "member": null, "instrument": "Harfe"}'),
    );
    expect(b.instrument, "Harfe");
    expect(b.band, isNull);
    expect(b.bandId, isNull);
    expect(b.member, isNull);
    expect(b.memberId, isNull);
  });
  test('Band Member with associated band should be created', () {
    var json =
        '{"band": {"id": 0, "name": "Ayran"}, "member": null, "instrument": ""}';

    var b = BandMember.fromJson(jsonDecode(json));

    expect(b.band, isNotNull);
    expect(b.band!.name, "Ayran");
  });
  test('Band Member with associated member should be created', () {
    var json =
        '{"band": null, "member": {"id": 0, "name": "Johannes"}, "instrument": ""}';

    var b = BandMember.fromJson(jsonDecode(json));

    expect(b.member, isNotNull);
    expect(b.member!.name, "Johannes");
  });
  test(
    'Band Member with associated member, given only id, should be created',
    () {
      var json = '{"band": null, "member_id": 0, "instrument": ""}';

      var b = BandMember.fromJson(jsonDecode(json));

      expect(b.member, isNull);
      expect(b.memberId, isNotNull);
      expect(b.memberId, 0);
    },
  );
}
