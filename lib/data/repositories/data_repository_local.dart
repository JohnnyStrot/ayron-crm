import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/data/services/local/local_data_service.dart';

import '../../../utils/result.dart';

abstract class DataRepositoryLocal<T extends StrongEntity>
    implements DataRepository<T> {
  DataRepositoryLocal({required LocalDataService localDataService})
    : _localDataService = localDataService,
      _entities = List.empty(growable: true);

  final LocalDataService _localDataService;

  final List<T> _entities;
  bool _initialized = false;

  String get typeName;
  String get assetFile;
  T Function(Map<String, dynamic> json) get fromJson;
  bool filter(T entity, Map<String, dynamic> search);
  T newEntity(int id);

  @override
  Future<Result<List<T>>> getEntities(Map<String, dynamic> search) async {
    if (!_initialized) {
      _initialized = true;
      _entities.addAll(
        await _localDataService.getEntities<T>(assetFile, fromJson),
      );
    }
    try {
      final entities = _entities.where((c) => filter(c, search)).toList();
      return Result.ok(entities);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result<T>> createEntity() async {
    T entity = newEntity(
      _entities.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1,
    );
    _entities.add(entity);
    return Result.ok(entity);
  }

  @override
  Future<Result<T>> getEntity(int id) async {
    if (!_initialized) {
      _initialized = true;
      _entities.addAll(
        await _localDataService.getEntities(assetFile, fromJson),
      );
    }
    final entity = _entities.where((c) => c.id == id).firstOrNull;
    if (entity == null) {
      return Result.error(Exception("$typeName with id $id not found"));
    } else {
      return Result.ok(entity);
    }
  }

  @override
  Future<Result<void>> saveEntity(T entity) async {
    final en = _entities.indexed.where((c) => c.$2.id == entity.id).firstOrNull;
    if (en == null) {
      return Result.error(
        Exception("$typeName with id ${entity.id} not found"),
      );
    }
    _entities[en.$1] = entity;
    return Result.ok(null);
  }

  @override
  Future<Result<void>> deleteEntity(int id) async {
    final entity = _entities.indexed.where((c) => c.$2.id == id).firstOrNull;
    if (entity == null) {
      return Result.error(Exception("$typeName with id $id not found"));
    }
    _entities.removeAt(entity.$1);
    return Result.ok(null);
  }
}
