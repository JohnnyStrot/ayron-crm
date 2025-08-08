import 'package:ayron_crm/data/model/entity.dart';

class ToOne<T extends StrongEntity> {
  int? get id => entity == null ? _id : entity!.id;
  T? entity;

  int? _id;

  ToOne({this.entity, int? id}) : _id = id;

  factory ToOne.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
    String attribute,
  ) => json[attribute] != null
      ? ToOne(entity: fromJson(json[attribute]))
      : ToOne(id: json["${attribute}_id"] as int?);

  MapEntry<String, dynamic> toJson(String attribute) =>
      MapEntry<String, dynamic>(
        entity == null ? "${attribute}_id" : attribute,
        entity ?? _id,
      );
}
