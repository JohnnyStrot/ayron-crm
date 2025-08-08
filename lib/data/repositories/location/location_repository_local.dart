import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/repositories/location/location_repository.dart';
import 'package:ayron_crm/data/services/local/local_data_service.dart';

import '../../../utils/result.dart';

class LocationRepositoryLocal extends LocationRepository {
  LocationRepositoryLocal({required LocalDataService localDataService})
    : _localDataService = localDataService;

  final LocalDataService _localDataService;

  @override
  Future<Result<List<Location>>> getLocations() async {
    try {
      final locations = (await _localDataService.getLocations()).toList();

      return Result.ok(locations);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
