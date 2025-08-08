import 'package:ayron_crm/data/model/song.dart';
import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/model/to_one.dart';

class SongRating implements WeakEntity {
  SongRating({
    required ToOne<Song> song,
    this.user = "",
    this.rating,
    this.ability,
  }) : _song = song;

  ToOne<Song> _song;
  Song? get song => _song.entity;
  int? get songId => _song.id;

  String user;
  int? rating;
  int? ability;

  factory SongRating.fromJson(Map<String, dynamic> json) => SongRating(
    song: ToOne.fromJson(json, Song.fromJson, "song"),
    user: (json["text"] ?? "") as String,
    rating: json["order"] == null ? null : (json["order"] as num).toInt(),
    ability: json["order"] == null ? null : (json["order"] as num).toInt(),
  );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{
      'user': user,
      'rating': rating,
      'ability': ability,
    };
    map.addEntries([_song.toJson("song")]);
    return map;
  }
}
