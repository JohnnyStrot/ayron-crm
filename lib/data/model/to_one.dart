import 'package:ayron_crm/data/model/entity.dart';

class ToOne<T extends StrongEntity> {
  int? get id => entity == null ? _id : entity!.id;
  T? _entity;
  T? get entity => _entity;
  set entity(T? ent) {
    this._entity = ent;
    _id = ent?.id;
  }

  int? _id;

  ToOne({T? entity, int? id}) : _entity = entity, _id = id;

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
