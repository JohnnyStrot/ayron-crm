import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/repositories/location/location_repository.dart';
import 'package:ayron_crm/ui/details/details_viewmodel.dart';

class LocationDetailsViewmodel
    extends DetailsViewmodel<Location, LocationDetailsViewmodel> {
  LocationDetailsViewmodel({required LocationRepository locationRepository})
    : super(repository: locationRepository);

  @override
  String get typeName => "Location";
}
