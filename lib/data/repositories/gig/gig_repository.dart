import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/utils/result.dart';

abstract class GigRepository extends DataRepository<Gig> {
  Future<Result<List<Gig>>> getUpcoming();
}
