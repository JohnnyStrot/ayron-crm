import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/model/event_series.dart';
import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/model/organisation.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/utils/result.dart';

abstract class GigRepository extends DataRepository<Gig> {
  Future<Result<List<Gig>>> getUpcoming();
  Future<Result<Gig>> createGig({
    Organisation? organisation,
    Location? location,
    EventSeries? series,
    Event? event,
  });
}
