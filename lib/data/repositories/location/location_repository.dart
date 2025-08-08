import 'package:ayron_crm/data/model/location.dart';
import 'package:flutter/foundation.dart';

import '../../../utils/result.dart';

abstract class LocationRepository extends ChangeNotifier {
  Future<Result<List<Location>>> getLocations();
}
