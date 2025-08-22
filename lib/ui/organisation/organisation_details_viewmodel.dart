import 'package:ayron_crm/data/model/organisation.dart';
import 'package:ayron_crm/data/repositories/organisation/organisation_repository.dart';
import 'package:ayron_crm/ui/details/details_viewmodel.dart';

class OrganisationDetailsViewmodel
    extends DetailsViewmodel<Organisation, OrganisationDetailsViewmodel> {
  OrganisationDetailsViewmodel({
    required OrganisationRepository organisationRepository,
  }) : super(repository: organisationRepository);

  @override
  String get typeName => "Organisation";
}
