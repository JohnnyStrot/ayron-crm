import 'package:ayron_crm/data/model/song.dart';
import 'package:ayron_crm/data/repositories/song/song_repository.dart';
import 'package:ayron_crm/ui/details/details_viewmodel.dart';

class SongDetailsViewmodel
    extends DetailsViewmodel<Song, SongDetailsViewmodel> {
  SongDetailsViewmodel({required SongRepository songRepository})
    : super(repository: songRepository);

  @override
  String get typeName => "Song";
}
