import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/utils/result.dart';

abstract class OpportunityRepository extends DataRepository<Opportunity> {
  Future<Result<ResultList<Opportunity>>> getOpportunities({
    Map<String, dynamic>? filter,
    String? order,
    bool? orderDesc,
    int? skip,
    int? take,
    bool past,
    bool active,
  });
}
