import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/opportunity_state.dart';
import 'package:ayron_crm/data/model/to_many.dart';
import 'package:ayron_crm/data/repositories/location/location_repository.dart';
import 'package:ayron_crm/data/services/local/local_data_service.dart';

import '../../../utils/result.dart';

class LocationRepositoryLocal extends LocationRepository {
  LocationRepositoryLocal({required LocalDataService localDataService})
    : _localDataService = localDataService,
      _locations = List.empty(growable: true);

  final LocalDataService _localDataService;

  List<Location> _locations;
  bool _initialized = false;

  @override
  Future<Result<List<Location>>> getLocations({
    String? name,
    String? city,
    OpportunityState? state,
  }) async {
    if (!_initialized) {
      _initialized = true;
      _locations.addAll(await _localDataService.getLocations());
    }
    try {
      final locations = _locations
          .where(
            (c) =>
                (name == null
                    ? true
                    : c.name.toLowerCase().contains(name.toLowerCase())) &&
                (city == null
                    ? true
                    : c.city.toLowerCase().contains(city.toLowerCase())) &&
                (state == null ? true : c.state == state),
          )
          .toList();

      return Result.ok(locations);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result<Location>> createLocation() async {
    Location l = Location(
      opportunity: Opportunity(
        id: _locations.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        contacts: ToMany(entities: []),
        protocols: ToMany(entities: []),
      ),
      events: ToMany(entities: []),
    );
    _locations.add(l);
    return Result.ok(l);
  }

  @override
  Future<Result<Location>> getLocation(int id) async {
    if (!_initialized) {
      _initialized = true;
      _locations.addAll(await _localDataService.getLocations());
    }
    final location = _locations.where((c) => c.id == id).firstOrNull;
    if (location == null) {
      return Result.error(Exception("Location with id $id not found"));
    } else {
      return Result.ok(location);
    }
  }

  @override
  Future<Result<void>> saveLocation(Location location) async {
    final loc = _locations.indexed
        .where((c) => c.$2.id == location.id)
        .firstOrNull;
    if (loc == null) {
      return Result.error(
        Exception("Location with id ${location.id} not found"),
      );
    }
    _locations[loc.$1] = location;
    return Result.ok(null);
  }

  @override
  Future<Result<void>> deleteLocation(int id) async {
    final loc = _locations.indexed.where((c) => c.$2.id == id).firstOrNull;
    if (loc == null) {
      return Result.error(Exception("Location with id ${id} not found"));
    }
    _locations.removeAt(loc.$1);
    return Result.ok(null);
  }
}
