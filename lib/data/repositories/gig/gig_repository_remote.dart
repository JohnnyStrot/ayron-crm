import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/data/repositories/data_repository_remote.dart';
import 'package:ayron_crm/data/repositories/gig/gig_repository.dart';

class GigRepositoryRemote extends DataRepositoryRemote<Gig>
    implements GigRepository {
  GigRepositoryRemote({required super.apiService});

  @override
  Gig Function(Map<String, dynamic> json) get fromJson => Gig.fromJson;

  @override
  String get typeName => "Gig";

  @override
  String get typeApiEndpoint => "gig";
}
