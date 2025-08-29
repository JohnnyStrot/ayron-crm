import 'package:ayron_crm/data/model/contact_protocol.dart';
import 'package:ayron_crm/data/model/opportunity_contact.dart';
import 'package:ayron_crm/data/repositories/contact_protocol/contact_protocol_repository.dart';
import 'package:ayron_crm/data/repositories/opportunity_contact/opportunity_contact_repository.dart';
import 'package:ayron_crm/data/services/api/api_service.dart';
import 'package:ayron_crm/utils/result.dart';

class ContactProtocolRepositoryRemote extends ContactProtocolRepository {
  ContactProtocolRepositoryRemote({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  @override
  Future<Result<void>> save(ContactProtocol prot) async {
    return await _apiService
        .put("contact-protocol/${prot.id}", prot.toJson())
        .then((response) {
          return Result<void>.ok(null);
        })
        .catchError((err) {
          return Result<void>.error(Exception(err));
        });
  }

  @override
  Future<Result<void>> delete(int id) async {
    return await _apiService
        .delete("contact-protocol/$id", {})
        .then((response) {
          return Result<void>.ok(null);
        })
        .catchError((err) {
          return Result<void>.error(Exception(err));
        });
  }
}
