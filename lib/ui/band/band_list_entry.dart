import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/list_widgets/opportunity_list_entry.dart';

class BandListEntry extends OpportunityListEntry<Band> {
  const BandListEntry({super.key, required Band band, required super.onDelete})
    : super(opportunity: band);

  @override
  String get route => Routes.bands;
}
