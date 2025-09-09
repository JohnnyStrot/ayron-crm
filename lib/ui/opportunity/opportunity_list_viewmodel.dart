import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/opportunity_state.dart';
import 'package:ayron_crm/data/repositories/opportunity/opportunity_repository.dart';
import 'package:ayron_crm/ui/list_widgets/data_list_viewmodel.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter_command/flutter_command.dart';

class OpportunityListViewmodel extends DataListViewmodel<Opportunity> {
  OpportunityListViewmodel({
    required OpportunityRepository opportunityRepository,
    this.past = false,
    this.active = false,
  }) : super(repository: opportunityRepository) {
    nameChanged = Command.createAsyncNoResult((s) async {
      _searchName = s;
      exLoadEntities();
    });
    stateChanged = Command.createAsyncNoResult((s) async {
      _searchState = s;
      exLoadEntities();
    });
  }

  @override
  Future<Result<({int count, List<Opportunity> entities})>> getEntities(
    int pageKey,
  ) => (repository as OpportunityRepository).getOpportunities(
    filter: searchValues(),
    take: take,
    skip: (pageKey - 1) * take,
    past: past,
    active: active,
  );

  bool past;
  bool active;

  late final Command<String?, void> nameChanged;
  late final Command<OpportunityState?, void> stateChanged;

  String? _searchName;
  OpportunityState? _searchState;

  @override
  searchValues() {
    var search = <String, dynamic>{};
    if (_searchName != null) {
      search["name"] = _searchName;
    }
    if (_searchState != null) {
      search["state"] = _searchState!.toJson;
    }
    return search;
  }
}
