import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/model/opportunity_state.dart';
import 'package:ayron_crm/data/repositories/event/event_repository.dart';
import 'package:ayron_crm/ui/list_widgets/data_list_viewmodel.dart';
import 'package:flutter_command/flutter_command.dart';

class EventListViewmodel extends DataListViewmodel<Event> {
  EventListViewmodel({required EventRepository eventRepository})
    : super(repository: eventRepository) {
    nameChanged = Command.createAsyncNoResult((s) async {
      _searchName = s;
      exLoadEntities();
    });
    stateChanged = Command.createAsyncNoResult((s) async {
      _searchState = s;
      exLoadEntities();
    });
  }

  late final Command<String?, void> nameChanged;
  late final Command<OpportunityState?, void> stateChanged;

  String? _searchName;
  OpportunityState? _searchState;

  @override
  searchValues() => <String, dynamic>{
    "name": _searchName,
    "state": _searchState,
  };
}
