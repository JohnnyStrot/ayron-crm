import 'package:ayron_crm/config/assets.dart';
import 'package:ayron_crm/data/model/organisation.dart';
import 'package:ayron_crm/data/repositories/data_repository_local.dart';

class OrganisationRepositoryLocal extends DataRepositoryLocal<Organisation> {
  OrganisationRepositoryLocal({required super.localDataService});

  @override
  String get assetFile => Assets.organisations;

  @override
  bool filter(Organisation entity, Map<String, dynamic> search) {
    return (search["name"] == null
            ? true
            : entity.name.toLowerCase().contains(
                search["name"].toLowerCase(),
              )) &&
        (search["state"] == null ? true : entity.state == search["state"]);
  }

  @override
  Organisation Function(Map<String, dynamic> json) get fromJson =>
      Organisation.fromJson;

  @override
  Organisation newEntity(int id) {
    return Organisation.create(id);
  }

  @override
  String get typeName => "Organisation";
}
