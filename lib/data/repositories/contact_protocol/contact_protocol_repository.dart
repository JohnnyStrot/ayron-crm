import 'package:ayron_crm/data/model/contact_protocol.dart';
import 'package:ayron_crm/utils/result.dart';

abstract class ContactProtocolRepository {
  Future<Result<void>> save(ContactProtocol prot);
  Future<Result<void>> delete(int id);
}
