import 'package:ayron_crm/config/assets.dart';
import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/data/repositories/data_repository_local.dart';
import 'package:ayron_crm/data/repositories/gig/gig_repository.dart';

class GigRepositoryLocal extends DataRepositoryLocal<Gig>
    implements GigRepository {
  GigRepositoryLocal({required super.localDataService});

  @override
  String get assetFile => Assets.gigs;

  @override
  bool filter(Gig entity, Map<String, dynamic> search) {
    return (search["name"] == null
            ? true
            : entity.name.toLowerCase().contains(
                search["name"].toLowerCase(),
              )) &&
        (search["state"] == null ? true : entity.state == search["state"]);
  }

  @override
  Gig Function(Map<String, dynamic> json) get fromJson => Gig.fromJson;

  @override
  Gig newEntity(int id) => Gig.create(id);

  @override
  String get typeName => "Gig";
}
