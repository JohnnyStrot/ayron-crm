import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/data/model/song.dart';
import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/model/to_one.dart';

class Setlist implements WeakEntity {
  Setlist({
    required ToOne<Song> song,
    required ToOne<Gig> gig,
    this.text = "",
    this.order = -1,
    this.optional = false,
    this.encore = false,
  }) : _gig = gig,
       _song = song;

  ToOne<Gig> _gig;
  Gig? get gig => _gig.entity;
  int? get gigId => _gig.id;

  ToOne<Song> _song;
  Song? get song => _song.entity;
  int? get songId => _song.id;

  String text;
  int order;
  bool optional;
  bool encore;

  factory Setlist.fromJson(Map<String, dynamic> json) => Setlist(
    song: ToOne.fromJson(json, Song.fromJson, "song"),
    gig: ToOne.fromJson(json, Gig.fromJson, "gig"),
    text: (json["text"] ?? "") as String,
    order: (json["order"] as num).toInt(),
    optional: json["optional"] as bool,
    encore: json["encore"] as bool,
  );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{
      'text': text,
      'order': order,
      'optional': optional,
      'encore': encore,
    };
    map.addEntries([_gig.toJson("gig"), _song.toJson("song")]);
    return map;
  }
}
