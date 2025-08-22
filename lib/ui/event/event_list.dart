import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_state_select.dart';
import 'package:ayron_crm/ui/list_widgets/data_list_view.dart';
import 'package:ayron_crm/ui/event/event_list_entry.dart';
import 'package:ayron_crm/ui/event/event_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

class EventListView
    extends DataListView<Event, EventListViewmodel, EventListView> {
  const EventListView({super.key, required super.viewmodel});

  @override
  State<EventListView> createState() => _EventListViewState();
}

class _EventListViewState
    extends DataListViewState<Event, EventListViewmodel, EventListView> {
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    nameController
        .debounce(Durations.medium2)
        .listen((text, _) => widget.viewmodel.nameChanged(text.text));
    super.initState();
  }

  @override
  Widget buildEntry(BuildContext context, Event entity) {
    return EventListEntry(event: entity, onDelete: (org) => delete(org));
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
  String get entityDisplay => "Veranstaltung";

  @override
  String get route => Routes.events;
}
