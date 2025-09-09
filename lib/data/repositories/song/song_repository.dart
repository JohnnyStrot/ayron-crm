import 'package:ayron_crm/data/model/song.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/utils/result.dart';

abstract class SongRepository extends DataRepository<Song> {
  Future<Result<List<Song>>> getRepertoire();
}
