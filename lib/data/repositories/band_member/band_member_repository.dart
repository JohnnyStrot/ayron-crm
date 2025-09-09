import 'package:ayron_crm/data/model/band_member.dart';
import 'package:ayron_crm/utils/result.dart';

abstract class BandMemberRepository {
  Future<Result<void>> saveBandMember(BandMember bandMembmer);
  Future<Result<void>> deleteBandMember(int bandId, int contactId);
}
