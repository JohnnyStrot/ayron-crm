import 'package:ayron_crm/config/assets.dart';
import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/data/repositories/data_repository_local.dart';
import 'package:ayron_crm/data/repositories/band/band_repository.dart';

class BandRepositoryLocal extends DataRepositoryLocal<Band>
    implements BandRepository {
  BandRepositoryLocal({required super.localDataService});

  @override
  String get assetFile => Assets.bands;

  @override
  bool filter(Band entity, Map<String, dynamic> search) {
    return (search["name"] == null
            ? true
            : entity.name.toLowerCase().contains(
                search["name"].toLowerCase(),
              )) &&
        (search["state"] == null ? true : entity.state == search["state"]);
  }

  @override
  Band Function(Map<String, dynamic> json) get fromJson => Band.fromJson;

  @override
  Band newEntity(int id) => Band.create(id);

  @override
  String get typeName => "Band";
}
