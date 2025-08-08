import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter_command/flutter_command.dart';

abstract class DataListViewmodel<T extends StrongEntity> {
  DataListViewmodel({required DataRepository<T> repository})
    : _repository = repository,
      _entities = [] {
    loadEntities = Command.createAsyncNoParam(
      _load,
      initialValue: Result.ok([]),
    );
    deleteEntity = Command.createAsync((entity) async {
      final res = await _repository.deleteEntity(entity.id);
      switch (res) {
        case Error<void>():
          return res;
        case Ok<void>():
          _entities.remove(entity);
          return res;
      }
    }, initialValue: Result.ok(null));

    loadEntities();
  }

  final DataRepository<T> _repository;
  List<T> _entities;
  List<T> get entities => _entities;

  late final Command<void, Result<List<T>>> loadEntities;
  late final Command<T, Result<void>> deleteEntity;

  Future<Result<List<T>>> _load() async {
    final result = await _repository.getEntities(searchValues());
    switch (result) {
      case Ok<List<T>>():
        _entities = result.value;
      case Error<List<T>>():
    }
    return result;
  }

  dynamic searchValues();
}
