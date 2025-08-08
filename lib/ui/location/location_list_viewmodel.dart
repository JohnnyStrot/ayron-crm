import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/repositories/location/location_repository.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class LocationListViewmodel extends ChangeNotifier {
  LocationListViewmodel({required LocationRepository locationRepository})
    : _locationRepository = locationRepository,
      _locations = [] {
    _locationRepository.getLocations().then((c) {
      switch (c) {
        case Ok<List<Location>>():
          _locations = c.value;
        case Error<List<Location>>():
          _log.warning(c.error);
      }
      notifyListeners();
    });
  }

  final _log = Logger('LocationListViewmodel');

  final LocationRepository _locationRepository;

  List<Location> _locations;

  List<Location> get locations => _locations;
}
