import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/data/repositories/band/band_repository.dart';
import 'package:ayron_crm/data/repositories/data_repository_remote.dart';

class BandRepositoryRemote extends DataRepositoryRemote<Band>
    implements BandRepository {
  BandRepositoryRemote({required super.apiService});

  @override
  Band Function(Map<String, dynamic> json) get fromJson => Band.fromJson;

  @override
  String get typeName => "Band";

  @override
  String get typeApiEndpoint => "band";
}
