import 'dart:convert';

import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/data/repositories/data_repository_remote.dart';
import 'package:ayron_crm/data/repositories/opportunity/opportunity_repository.dart';
import 'package:ayron_crm/utils/result.dart';

class OpportunityRepositoryRemote extends DataRepositoryRemote<Opportunity>
    implements OpportunityRepository {
  OpportunityRepositoryRemote({required super.apiService});

  @override
  Future<Result<ResultList<Opportunity>>> getOpportunities({
    Map<String, dynamic>? filter,
    String? order,
    bool? orderDesc,
    int? skip,
    int? take,
    bool past = false,
    bool active = false,
  }) async {
    var params = <String, dynamic>{};

    if (skip != null) params["skip"] = skip;
    if (take != null) params["take"] = take;
    if (order != null) params["order"] = order;
    if (orderDesc != null) params["order_desc"] = orderDesc;
    if (filter != null) params.addAll(filter);

    return await apiService
        .get(
          past
              ? "opportunity/past"
              : active
              ? "opportunity/active"
              : "opportunity",
          params: params,
        )
        .then((response) {
          var res = jsonDecode(response.body);

          List<Opportunity> entities = (res["entities"] as List<dynamic>).map((
            entityJson,
          ) {
            return Opportunity.fromJson(entityJson);
          }).toList();
          int count = res["count"];

          return Result<ResultList<Opportunity>>.ok((
            entities: entities,
            count: count,
          ));
        })
        .catchError((err) {
          return Result<ResultList<Opportunity>>.error(Exception(err));
        });
  }

  @override
  Opportunity Function(Map<String, dynamic> json) get fromJson =>
      Opportunity.fromJson;

  @override
  String get typeApiEndpoint => "Opportunity";

  @override
  String get typeName => "Gelegenheit";
}
