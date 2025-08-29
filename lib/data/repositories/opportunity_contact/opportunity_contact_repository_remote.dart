import 'package:ayron_crm/data/model/opportunity_contact.dart';
import 'package:ayron_crm/data/repositories/opportunity_contact/opportunity_contact_repository.dart';
import 'package:ayron_crm/data/services/api/api_service.dart';
import 'package:ayron_crm/utils/result.dart';

class OpportunityContactRepositoryRemote extends OpportunityContactRepository {
  OpportunityContactRepositoryRemote({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  @override
  Future<Result<void>> saveOpCo(OpportunityContact opco) async {
    return await _apiService
        .put(
          "opportunity-contact/${opco.opportunityId}/${opco.contactId}",
          opco.toJson(),
        )
        .then((response) {
          return Result<void>.ok(null);
        })
        .catchError((err) {
          return Result<void>.error(Exception(err));
        });
  }

  @override
  Future<Result<void>> deleteOpCo(int opportunityId, int contactId) async {
    return await _apiService
        .delete("opportunity-contact/$opportunityId/$contactId", {})
        .then((response) {
          return Result<void>.ok(null);
        })
        .catchError((err) {
          return Result<void>.error(Exception(err));
        });
  }
}
