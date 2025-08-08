import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/model/setlist.dart';
import 'package:ayron_crm/data/model/song_rating.dart';
import 'package:ayron_crm/data/model/to_many.dart';
import 'package:ayron_crm/utils/datetime_extension.dart';

class Song implements StrongEntity {
  Song({
    required this.id,
    this.name = "",
    this.author = "",
    this.duration,
    this.bpm,
    this.tuning = "",
    this.key = "",
    this.mood = "",
    this.showOnWebsite = false,
    this.spotify = "",
    this.youtube = "",
    this.ytmusic = "",
    this.applemusic = "",
    this.amazonmusic = "",
    this.publicText = "",
    this.lyrics = "",
    this.interpretation = "",
    this.inRepertoire = false,
    required ToMany<Setlist> setlists,
    required ToMany<SongRating> ratings,
  }) : _setlists = setlists,
       _ratings = ratings;

  factory Song.fromJson(Map<String, dynamic> json) => Song(
    id: (json["id"] as num).toInt(),
    name: (json['name'] ?? "") as String,
    author: (json['author'] ?? "") as String,
    duration: json['duration'] == null
        ? null
        : DurationParse.parse(json['duration']),
    bpm: json['bpm'] == null ? null : (json['bpm'] as num).toInt(),
    tuning: (json['tuning'] ?? "") as String,
    key: (json['key'] ?? "") as String,
    mood: (json['mood'] ?? "") as String,
    showOnWebsite: (json['showOnWebsite'] ?? false) as bool,
    spotify: (json['spotfiy'] ?? "") as String,
    youtube: (json['youtube'] ?? "") as String,
    ytmusic: (json['ytmusic'] ?? "") as String,
    applemusic: (json['applemusic'] ?? "") as String,
    amazonmusic: (json['amazonmusic'] ?? "") as String,
    publicText: (json['publicText'] ?? "") as String,
    lyrics: (json['lyrics'] ?? "") as String,
    interpretation: (json['interpretation'] ?? "") as String,
    inRepertoire: (json['showOnWebsite'] ?? false) as bool,
    setlists: ToMany.fromJson(json["setlists"], Setlist.fromJson),
    ratings: ToMany.fromJson(json["ratings"], SongRating.fromJson),
  );

  @override
  int id;
  String name;
  String author;
  Duration? duration;
  int? bpm;
  String tuning;
  String key;
  String mood;
  bool showOnWebsite;
  String spotify;
  String youtube;
  String ytmusic;
  String applemusic;
  String amazonmusic;
  String publicText;
  String lyrics;
  String interpretation;
  bool inRepertoire;

  ToMany<Setlist> _setlists;
  List<Setlist> get setlists => _setlists.entities;

  ToMany<SongRating> _ratings;
  List<SongRating> get ratings => _ratings.entities;

  @override
  String get displayShort => name;

  @override
  Map<String, dynamic> toJson() {
    var a = <String, dynamic>{
      'id': id,
      'name': name,
      'author': author,
      'duration': duration?.toJson(),
      'bpm': bpm,
      'tuning': tuning,
      'key': key,
      'mood': mood,
      'showOnWebsite': showOnWebsite,
      'spotify': spotify,
      'youtube': youtube,
      'ytmusic': ytmusic,
      'applemusic': applemusic,
      'amazonmusic': amazonmusic,
      'publicText': publicText,
      'lyrics': lyrics,
      'interpretation': interpretation,
      'inRepertoire': inRepertoire,
      'setlist': _setlists.toJson(),
      'ratings': _ratings.toJson(),
    };
    return a;
  }
}
