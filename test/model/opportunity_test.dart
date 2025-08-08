import 'dart:convert';

import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:test/test.dart';

void main() {
  test('Opportunity with minimal info should be created from JSON', () {
    var b = Opportunity.fromJson(jsonDecode('{"id": 0}'));
    print(jsonEncode(b.toJson()));
  });
}
