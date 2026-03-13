import 'dart:convert';

import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/protocol.dart';
import 'package:ayron_crm/data/repositories/contact_protocol/contact_protocol_repository.dart';
import 'package:ayron_crm/data/repositories/data_repository_remote.dart';
import 'package:ayron_crm/utils/result.dart';

class ContactProtocolRepositoryRemote extends DataRepositoryRemote<Protocol>
    implements ContactProtocolRepository {
  ContactProtocolRepositoryRemote({required super.apiService});

  @override
  Future<Result<List<Protocol>>> getProtocolsContact(Contact contact) async {
    return await apiService
        .get("contact-protocol/contact/${contact.id}")
        .then((response) {
          return Result<List<Protocol>>.ok(
            (jsonDecode(response.body) as List<dynamic>)
                .map((prot) => Protocol.fromJson(prot))
                .toList(),
          );
        })
        .catchError((err) {
          return Result<List<Protocol>>.error(Exception(err));
        });
  }

  @override
  Future<Result<List<Protocol>>> getProtocolsOpportunity(
    Opportunity opportunity,
  ) async {
    return await apiService
        .get("contact-protocol/opportunity/${opportunity.id}")
        .then((response) {
          return Result<List<Protocol>>.ok(
            (jsonDecode(response.body) as List<dynamic>)
                .map((prot) => Protocol.fromJson(prot))
                .toList(),
          );
        })
        .catchError((err) {
          return Result<List<Protocol>>.error(Exception(err));
        });
  }

  @override
  Protocol Function(Map<String, dynamic> json) get fromJson =>
      Protocol.fromJson;

  @override
  String get typeApiEndpoint => "contact-protocol";

  @override
  String get typeName => "Protokoll";
}
