import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/repositories/data_repository_remote.dart';
import 'package:ayron_crm/data/repositories/location/location_repository.dart';

class LocationRepositoryRemote extends DataRepositoryRemote<Location>
    implements LocationRepository {
  LocationRepositoryRemote({required super.apiService});

  @override
  Location Function(Map<String, dynamic> json) get fromJson =>
      Location.fromJson;

  @override
  String get typeName => "Location";

  @override
  String get typeApiEndpoint => "location";
}
