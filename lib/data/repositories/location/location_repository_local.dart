import 'package:ayron_crm/config/assets.dart';
import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/repositories/data_repository_local.dart';
import 'package:ayron_crm/data/repositories/location/location_repository.dart';

class LocationRepositoryLocal extends DataRepositoryLocal<Location>
    implements LocationRepository {
  LocationRepositoryLocal({required super.localDataService});

  @override
  String get assetFile => Assets.locations;

  @override
  bool filter(Location entity, Map<String, dynamic> search) {
    return (search["name"] == null
            ? true
            : entity.name.toLowerCase().contains(
                search["name"].toLowerCase(),
              )) &&
        (search["city"] == null
            ? true
            : entity.city.toLowerCase().contains(
                search["city"].toLowerCase(),
              )) &&
        (search["state"] == null ? true : entity.state == search["state"]);
  }

  @override
  Location Function(Map<String, dynamic> json) get fromJson =>
      Location.fromJson;

  @override
  Location newEntity(int id) => Location.create(id);

  @override
  String get typeName => "Location";
}
