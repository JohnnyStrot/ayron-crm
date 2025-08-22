import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/data/repositories/gig/gig_repository.dart';
import 'package:ayron_crm/ui/details/details_viewmodel.dart';

class GigDetailsViewmodel extends DetailsViewmodel<Gig, GigDetailsViewmodel> {
  GigDetailsViewmodel({required GigRepository gigRepository})
    : super(repository: gigRepository);

  @override
  String get typeName => "Gig";
}
