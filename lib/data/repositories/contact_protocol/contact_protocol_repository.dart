import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/protocol.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/utils/result.dart';

abstract class ContactProtocolRepository {
  Future<Result<int>> save(Protocol prot);
  Future<Result<int>> create({Contact? contact, Opportunity? opportunity});
  Future<Result<void>> delete(int id);
  Future<Result<List<Protocol>>> getProtocols(Contact contact);
}
