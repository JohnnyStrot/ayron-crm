import 'dart:convert';

import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/model/event_series.dart';
import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/model/organisation.dart';
import 'package:ayron_crm/data/repositories/data_repository_remote.dart';
import 'package:ayron_crm/data/repositories/gig/gig_repository.dart';
import 'package:ayron_crm/utils/result.dart';

class GigRepositoryRemote extends DataRepositoryRemote<Gig>
    implements GigRepository {
  GigRepositoryRemote({required super.apiService});

  @override
  Gig Function(Map<String, dynamic> json) get fromJson => Gig.fromJson;

  @override
  String get typeName => "Gig";

  @override
  String get typeApiEndpoint => "gig";

  @override
  Future<Result<List<Gig>>> getUpcoming() {
    return apiService
        .get("$typeApiEndpoint/upcoming")
        .then((res) {
          List<Gig> gigs = (jsonDecode(res.body) as List<dynamic>)
              .map((e) => Gig.fromJson(e))
              .toList();
          return Result<List<Gig>>.ok(gigs);
        })
        .catchError((err) {
          return Result<List<Gig>>.error(Exception(err));
        });
  }

  @override
  Future<Result<Gig>> createGig({
    Organisation? organisation,
    Location? location,
    EventSeries? series,
    Event? event,
  }) {
    return apiService
        .post(typeApiEndpoint, {
          if (organisation != null) "organisation": organisation.toJson(),
          if (series != null) "series": series.toJson(),
          if (location != null) "location": location.toJson(),
          if (event != null) "event": event.toJson(),
        })
        .then((res) {
          Gig gig = Gig.fromJson(jsonDecode(res.body));
          return Result<Gig>.ok(gig);
        })
        .catchError((err) {
          return Result<Gig>.error(Exception(err));
        });
    ;
  }
}
