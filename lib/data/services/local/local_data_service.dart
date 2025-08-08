import 'dart:convert';

import 'package:ayron_crm/config/assets.dart';
import 'package:ayron_crm/data/model/entity.dart';
import 'package:flutter/services.dart';

class LocalDataService {
  Future<List<T>> getEntities<T extends StrongEntity>(
    String asset,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final json = await _loadStringAsset(Assets.locations);
    return json.map<T>(fromJson).toList();
  }

  Future<List<Map<String, dynamic>>> _loadStringAsset(String asset) async {
    final localData = await rootBundle.loadString(asset);
    return (jsonDecode(localData) as List).cast<Map<String, dynamic>>();
  }
}
