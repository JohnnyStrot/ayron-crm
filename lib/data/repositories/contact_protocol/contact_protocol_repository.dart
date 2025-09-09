import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/contact_protocol.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/utils/result.dart';

abstract class ContactProtocolRepository {
  Future<Result<int>> save(ContactProtocol prot);
  Future<Result<int>> create({Contact? contact, Opportunity? opportunity});
  Future<Result<void>> delete(int id);
  Future<Result<List<ContactProtocol>>> getProtocols(Contact contact);
}
