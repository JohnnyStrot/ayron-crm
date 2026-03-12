import 'dart:convert';

import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/protocol.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/repositories/contact_protocol/contact_protocol_repository.dart';
import 'package:ayron_crm/data/services/api/api_service.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter/cupertino.dart';

class ContactProtocolRepositoryRemote extends ContactProtocolRepository {
  ContactProtocolRepositoryRemote({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  @override
  Future<Result<int>> save(Protocol prot) async {
    return await _apiService
        .put("contact-protocol/${prot.id}", prot.toJson())
        .then((response) {
          return Result<int>.ok(jsonDecode(response.body)["id"]);
        })
        .catchError((err) {
          print(err);
          return Result<int>.error(Exception(err));
        });
  }

  @override
  Future<Result<int>> create({
    Contact? contact,
    Opportunity? opportunity,
  }) async {
    return await _apiService
        .post("contact-protocol", {
          "opportunity": opportunity?.toJson(),
          "contact": contact?.toJson(),
        })
        .then((response) {
          return Result<int>.ok(jsonDecode(response.body)["id"]);
        })
        .catchError((err) {
          print(err);
          return Result<int>.error(Exception(err));
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

  @override
  Future<Result<List<Protocol>>> getProtocols(Contact contact) async {
    return await _apiService
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
}
