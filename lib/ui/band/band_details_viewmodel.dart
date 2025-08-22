import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/data/repositories/band/band_repository.dart';
import 'package:ayron_crm/ui/details/details_viewmodel.dart';

class BandDetailsViewmodel
    extends DetailsViewmodel<Band, BandDetailsViewmodel> {
  BandDetailsViewmodel({required BandRepository bandRepository})
    : super(repository: bandRepository);

  @override
  String get typeName => "Band";
}
