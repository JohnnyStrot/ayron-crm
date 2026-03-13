import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/protocol.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/utils/result.dart';

abstract class ContactProtocolRepository extends DataRepository<Protocol> {
  Future<Result<List<Protocol>>> getProtocolsContact(Contact contact);
  Future<Result<List<Protocol>>> getProtocolsOpportunity(
    Opportunity opportunity,
  );
}
