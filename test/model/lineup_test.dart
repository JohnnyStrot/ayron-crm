import 'dart:convert';

import 'package:ayron_crm/data/model/lineup.dart';
import 'package:test/test.dart';

void main() {
  test('Lineup with null associations and null times should be created', () {
    var l = Lineup.fromJson(
      jsonDecode('{"band": null, "event": null, "stagetime": null}'),
    );
    expect(l.stage, "");
    expect(l.stagetime, isNull);
  });

  test('Lineup with association ids and null times should be created', () {
    var l = Lineup.fromJson(
      jsonDecode('{"band_id": 0, "event_id": 0, "stagetime": null}'),
    );
    expect(l.stage, "");
    expect(l.stagetime, isNull);
    expect(l.bandId, 0);
    expect(l.band, isNull);
  });
}
