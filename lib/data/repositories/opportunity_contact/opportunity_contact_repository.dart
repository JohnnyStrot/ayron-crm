import 'package:ayron_crm/data/model/opportunity_contact.dart';
import 'package:ayron_crm/utils/result.dart';

abstract class OpportunityContactRepository {
  Future<Result<void>> saveOpCo(OpportunityContact opco);
  Future<Result<void>> deleteOpCo(int opportunityId, int contactId);
}
