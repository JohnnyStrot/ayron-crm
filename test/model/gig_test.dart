import 'dart:convert';

import 'package:ayron_crm/data/model/gig.dart';
import 'package:test/test.dart';

void main() {
  test('Gig with id should be created from JSON', () {
    var b = Gig.fromJson(jsonDecode('{"id": 0}'));
    expect(b.id, 0);
  });
}
