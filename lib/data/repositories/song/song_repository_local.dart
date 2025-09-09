import 'package:ayron_crm/config/assets.dart';
import 'package:ayron_crm/data/model/song.dart';
import 'package:ayron_crm/data/repositories/data_repository_local.dart';
import 'package:ayron_crm/data/repositories/song/song_repository.dart';
import 'package:ayron_crm/utils/result.dart';

class SongRepositoryLocal extends DataRepositoryLocal<Song>
    implements SongRepository {
  SongRepositoryLocal({required super.localDataService});

  @override
  String get assetFile => Assets.songs;

  @override
  bool filter(Song entity, Map<String, dynamic>? search) {
    if (search == null) return true;
    return (search["name"] == null
            ? true
            : entity.name.toLowerCase().contains(
                search["name"].toLowerCase(),
              )) &&
        (search["author"] == null ? true : entity.author == search["author"]);
  }

  @override
  Song Function(Map<String, dynamic> json) get fromJson => Song.fromJson;

  @override
  Song newEntity(int id) => Song.create(id);

  @override
  String get typeName => "Song";

  @override
  Future<Result<List<Song>>> getRepertoire() {
    return Future.value(Result.ok([]));
  }
}
