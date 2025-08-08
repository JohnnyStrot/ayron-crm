import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/model/opportunity_state.dart';
import 'package:ayron_crm/data/repositories/location/location_repository.dart';
import 'package:ayron_crm/ui/list_widgets/data_list_viewmodel.dart';
import 'package:flutter_command/flutter_command.dart';

class LocationListViewmodel extends DataListViewmodel<Location> {
  LocationListViewmodel({required LocationRepository locationRepository})
    : super(repository: locationRepository) {
    nameChanged = Command.createAsyncNoResult((s) async {
      _searchName = s;
      exLoadEntities();
    });
    cityChanged = Command.createAsyncNoResult((s) async {
      _searchCity = s;
      exLoadEntities();
    });
    stateChanged = Command.createAsyncNoResult((s) async {
      _searchState = s;
      exLoadEntities();
    });
  }

  late final Command<String?, void> nameChanged;
  late final Command<String?, void> cityChanged;
  late final Command<OpportunityState?, void> stateChanged;

  String? _searchName;
  String? _searchCity;
  OpportunityState? _searchState;

  @override
  searchValues() => <String, dynamic>{
    "name": _searchName,
    "city": _searchCity,
    "state": _searchState,
  };
}
