import 'package:ayron_crm/data/model/organisation.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/list_widgets/opportunity_list_entry.dart';

class OrganisationListEntry extends OpportunityListEntry<Organisation> {
  const OrganisationListEntry({
    super.key,
    required Organisation organisation,
    required super.onDelete,
  }) : super(opportunity: organisation);

  @override
  String get route => Routes.organisations;
}
