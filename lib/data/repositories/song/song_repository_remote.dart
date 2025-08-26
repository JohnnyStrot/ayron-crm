import 'package:ayron_crm/data/model/song.dart';
import 'package:ayron_crm/data/repositories/data_repository_remote.dart';
import 'package:ayron_crm/data/repositories/song/song_repository.dart';

class SongRepositoryRemote extends DataRepositoryRemote<Song>
    implements SongRepository {
  SongRepositoryRemote({required super.apiService});

  @override
  Song Function(Map<String, dynamic> json) get fromJson => Song.fromJson;

  @override
  String get typeName => "Song";

  @override
  String get typeApiEndpoint => "song";
}
