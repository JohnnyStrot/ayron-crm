import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/model/opportunity_state.dart';
import 'package:ayron_crm/data/repositories/location/location_repository.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:logging/logging.dart';

class LocationListViewmodel extends ChangeNotifier {
  LocationListViewmodel({required LocationRepository locationRepository})
    : _locationRepository = locationRepository,
      _locations = [] {
    loadLocations = Command.createAsyncNoParam(
      _load,
      initialValue: Result.ok([]),
    );
    deleteLocation = Command.createAsync((location) async {
      final res = await _locationRepository.deleteLocation(location.id);
      switch (res) {
        case Error<void>():
          return res;
        case Ok<void>():
          locations.remove(location);
          return res;
      }
    }, initialValue: Result.ok(null));

    nameChanged = Command.createSyncNoResult((s) {
      _searchName = s;
      loadLocations();
    });
    cityChanged = Command.createSyncNoResult((s) {
      _searchCity = s;
      loadLocations();
    });
    stateChanged = Command.createSyncNoResult((s) {
      _searchState = s;
      loadLocations();
    });
    loadLocations();
  }

  final _log = Logger('LocationListViewmodel');

  final LocationRepository _locationRepository;

  late final Command<void, Result<List<Location>>> loadLocations;
  late final Command<Location, Result<void>> deleteLocation;

  late final Command<String?, void> nameChanged;
  late final Command<String?, void> cityChanged;
  late final Command<OpportunityState?, void> stateChanged;

  List<Location> _locations;

  List<Location> get locations => _locations;

  String? _searchName;
  String? _searchCity;
  OpportunityState? _searchState;

  Future<Result<List<Location>>> _load() async {
    final result = await _locationRepository.getLocations(
      name: _searchName,
      city: _searchCity,
      state: _searchState,
    );
    switch (result) {
      case Ok<List<Location>>():
        _locations = result.value;
      case Error<List<Location>>():
        _log.warning(result.error);
    }
    notifyListeners();
    return result;
  }
}
