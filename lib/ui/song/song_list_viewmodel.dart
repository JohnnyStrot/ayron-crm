import 'package:ayron_crm/data/model/song.dart';
import 'package:ayron_crm/data/repositories/song/song_repository.dart';
import 'package:ayron_crm/ui/list_widgets/data_list_viewmodel.dart';
import 'package:flutter_command/flutter_command.dart';

class SongListViewmodel extends DataListViewmodel<Song> {
  SongListViewmodel({required SongRepository songRepository})
    : super(repository: songRepository) {
    nameChanged = Command.createAsyncNoResult((s) async {
      _searchName = s;
      exLoadEntities();
    });
  }

  late final Command<String?, void> nameChanged;

  String? _searchName;

  @override
  searchValues() {
    var search = <String, dynamic>{};
    if (_searchName != null) {
      search["name"] = _searchName;
    }
    return search;
  }
}
