import 'package:ayron_crm/utils/result.dart';

abstract interface class DataRepository<T> {
  Future<Result<List<T>>> getEntities(Map<String, dynamic> search);

  Future<Result<T>> getEntity(int id);
  Future<Result<T>> createEntity();
  Future<Result<void>> saveEntity(T entity);
  Future<Result<void>> deleteEntity(int id);
}
