import 'package:ayron_crm/data/model/band_member.dart';
import 'package:ayron_crm/data/repositories/band_member/band_member_repository.dart';
import 'package:ayron_crm/data/services/api/api_service.dart';
import 'package:ayron_crm/utils/result.dart';

class BandMemberRepositoryRemote extends BandMemberRepository {
  BandMemberRepositoryRemote({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  @override
  Future<Result<void>> saveBandMember(BandMember bandMember) async {
    return await _apiService
        .put(
          "band-member/${bandMember.bandId}/${bandMember.contactId}",
          bandMember.toJson(),
        )
        .then((response) {
          return Result<void>.ok(null);
        })
        .catchError((err) {
          return Result<void>.error(Exception(err));
        });
  }

  @override
  Future<Result<void>> deleteBandMember(int bandId, int contactId) async {
    return await _apiService
        .delete("band-member/$bandId/$contactId", {})
        .then((response) {
          return Result<void>.ok(null);
        })
        .catchError((err) {
          return Result<void>.error(Exception(err));
        });
  }
}
