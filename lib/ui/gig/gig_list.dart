import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_state_select.dart';
import 'package:ayron_crm/ui/list_widgets/data_list_view.dart';
import 'package:ayron_crm/ui/gig/gig_list_entry.dart';
import 'package:ayron_crm/ui/gig/gig_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

class GigListView extends DataListView<Gig, GigListViewmodel, GigListView> {
  const GigListView({super.key, required super.viewmodel});

  @override
  State<GigListView> createState() => _GigListViewState();
}

class _GigListViewState
    extends DataListViewState<Gig, GigListViewmodel, GigListView> {
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    nameController
        .debounce(Durations.medium2)
        .listen((text, _) => widget.viewmodel.nameChanged(text.text));
    super.initState();
  }

  @override
  Widget buildEntry(BuildContext context, Gig entity) {
    return GigListEntry(gig: entity, onDelete: (org) => delete(org));
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
        Expanded(
          child: OpportunityStateSelect(
            onSelected: (value) => widget.viewmodel.stateChanged(value),
          ),
        ),
      ],
    );
  }

  @override
  String get entityDisplay => "Gig";

  @override
  String get route => Routes.gigs;
}
