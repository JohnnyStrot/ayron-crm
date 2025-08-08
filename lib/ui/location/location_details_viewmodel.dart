import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/repositories/location/location_repository.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter_command/flutter_command.dart';

class LocationDetailsViewmodel {
  LocationDetailsViewmodel({required LocationRepository locationRepository})
    : _locationRepository = locationRepository {
    loadLocation = Command.createAsync((id) async {
      final val = await _locationRepository.getLocation(id);
      switch (val) {
        case Ok<Location>():
          _location = val.value;
        case Error<Location>():
          _location = null;
      }
      return val;
    }, initialValue: Result.ok(null));
    createLocation = Command.createAsyncNoParam(() async {
      final val = await _locationRepository.createLocation();
      switch (val) {
        case Ok<Location>():
          _location = val.value;
        case Error<Location>():
          _location = null;
      }
      return val;
    }, initialValue: Result.ok(null));
    saveLocation = Command.createAsyncNoParam(() {
      if (location == null) {
        return Future.value(Result.error(Exception("Location is null")));
      }
      return _locationRepository.saveLocation(location!);
    }, initialValue: Result.ok(null));
  }

  final LocationRepository _locationRepository;

  late final Command<int, Result<Location?>> loadLocation;
  late final Command<void, Result<Location?>> createLocation;
  late final Command<void, Result<void>> saveLocation;

  bool get loading =>
      loadLocation.isExecuting.value || createLocation.isExecuting.value;

  Location? _location;

  Location? get location => _location;

  void setName(String? name) {
    _location?.name = name ?? "";
  }
}
