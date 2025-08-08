import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/model/opportunity_state.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:flutter/foundation.dart';

import '../../../utils/result.dart';

abstract class LocationRepository extends ChangeNotifier
    implements DataRepository<Location> {
  Future<Result<List<Location>>> getLocations({
    String? name,
    String? city,
    OpportunityState? state,
  });

  Future<Result<Location>> getLocation(int id);
  Future<Result<Location>> createLocation();
  Future<Result<void>> saveLocation(Location location);
  Future<Result<void>> deleteLocation(int id);

  @override
  Future<Result<Location>> createEntity() => createLocation();
  @override
  Future<Result<Location>> getEntity(int id) => getLocation(id);
  @override
  Future<Result<List<Location>>> getEntities(search) =>
      getLocations(name: search.name, city: search.city, state: search.state);
  @override
  Future<Result<void>> deleteEntity(int id) => deleteLocation(id);
  @override
  Future<Result<void>> saveEntity(Location entity) => saveLocation(entity);
}
