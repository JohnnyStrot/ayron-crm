import 'dart:convert';

import 'package:ayron_crm/data/model/song.dart';
import 'package:ayron_crm/data/repositories/data_repository_remote.dart';
import 'package:ayron_crm/data/repositories/song/song_repository.dart';
import 'package:ayron_crm/utils/result.dart';

class SongRepositoryRemote extends DataRepositoryRemote<Song>
    implements SongRepository {
  SongRepositoryRemote({required super.apiService});

  @override
  Song Function(Map<String, dynamic> json) get fromJson => Song.fromJson;

  @override
  String get typeName => "Song";

  @override
  String get typeApiEndpoint => "song";

  @override
  Future<Result<List<Song>>> getRepertoire() {
    return apiService
        .get("$typeApiEndpoint/repertoire")
        .then((res) {
          List<Song> songs = (jsonDecode(res.body) as List<dynamic>)
              .map((e) => Song.fromJson(e))
              .toList();
          return Result<List<Song>>.ok(songs);
        })
        .catchError((err) {
          return Result<List<Song>>.error(Exception(err));
        });
  }
}
