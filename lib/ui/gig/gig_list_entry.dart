import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/list_widgets/opportunity_list_entry.dart';

class GigListEntry extends OpportunityListEntry<Gig> {
  const GigListEntry({super.key, required Gig gig, required super.onDelete})
    : super(opportunity: gig);

  @override
  String get route => Routes.gigs;
}
