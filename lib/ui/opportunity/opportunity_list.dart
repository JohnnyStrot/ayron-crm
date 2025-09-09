import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_state_select.dart';
import 'package:ayron_crm/ui/list_widgets/data_list_view.dart';
import 'package:ayron_crm/ui/band/band_list_entry.dart';
import 'package:ayron_crm/ui/opportunity/opportunity_list_entry.dart';
import 'package:ayron_crm/ui/opportunity/opportunity_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

class OpportunityList
    extends
        DataListView<Opportunity, OpportunityListViewmodel, OpportunityList> {
  const OpportunityList({super.key, required super.viewmodel});

  @override
  State<OpportunityList> createState() => _OpportunityListViewState();
}

class _OpportunityListViewState
    extends
        DataListViewState<
          Opportunity,
          OpportunityListViewmodel,
          OpportunityList
        > {
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    nameController
        .debounce(Durations.medium2)
        .listen((text, _) => widget.viewmodel.nameChanged(text.text));
    super.initState();
  }

  @override
  Widget buildEntry(BuildContext context, Opportunity entity) {
    return _GenericOpportunityListEntry(
      opportunity: entity,
      onDelete: (org) => delete(org),
    );
  }

  @override
  Widget buildSearch(BuildContext context) {
    return Row(
      spacing: Dimens.paddingHorizontal,
      children: [
        Expanded(
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              label: Text("Name"),
              suffixIcon: IconButton(
                onPressed: () {
                  nameController.clear();
                },
                icon: Icon(Icons.clear),
              ),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        if (!widget.viewmodel.past && !widget.viewmodel.active)
          Expanded(
            child: OpportunityStateSelect(
              onSelected: (value) => widget.viewmodel.stateChanged(value),
            ),
          ),
      ],
    );
  }

  @override
  String get entityDisplay => widget.viewmodel.past
      ? "Vergangene Gelegenheiten"
      : widget.viewmodel.active
      ? "Aktive Gelegenheiten"
      : "Gelegenheiten";

  @override
  String get route => Routes.bands;
}

class _GenericOpportunityListEntry extends OpportunityListEntry {
  const _GenericOpportunityListEntry({
    required super.opportunity,
    required super.onDelete,
  });

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          spacing: 5,
          children: [
            Icon(opportunity.typeIcon),
            Text(
              opportunity.typeDisplay,
              style: TextTheme.of(context).bodyMedium,
            ),
            Expanded(child: SizedBox()),
            Text(
              opportunity.state.displayString,
              style: TextTheme.of(
                context,
              ).bodySmall!.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        Text(
          opportunityToString(opportunity),
          overflow: TextOverflow.ellipsis,
          style: TextTheme.of(context).displaySmall!.copyWith(
            fontSize: TextTheme.of(context).bodyLarge!.fontSize,
          ),
        ),
      ],
    );
  }
}
