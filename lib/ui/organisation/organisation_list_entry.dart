import 'package:ayron_crm/data/model/organisation.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/opportunity/opportunity_list_entry.dart';

class OrganisationListEntry extends OpportunityListEntry<Organisation> {
  const OrganisationListEntry({
    super.key,
    required Organisation organisation,
    required super.onDelete,
  }) : super(opportunity: organisation);

  @override
  String route(op) => Routes.organisations;
}
