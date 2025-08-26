import 'package:ayron_crm/data/model/organisation.dart';
import 'package:ayron_crm/data/repositories/data_repository_remote.dart';
import 'package:ayron_crm/data/repositories/organisation/organisation_repository.dart';

class OrganisationRepositoryRemote extends DataRepositoryRemote<Organisation>
    implements OrganisationRepository {
  OrganisationRepositoryRemote({required super.apiService});

  @override
  Organisation Function(Map<String, dynamic> json) get fromJson =>
      Organisation.fromJson;

  @override
  String get typeName => "Organisation";

  @override
  String get typeApiEndpoint => "organisation";
}
