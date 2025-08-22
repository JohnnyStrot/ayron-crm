import 'package:ayron_crm/data/model/event_series.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_state_select.dart';
import 'package:ayron_crm/ui/list_widgets/data_list_view.dart';
import 'package:ayron_crm/ui/series/series_list_entry.dart';
import 'package:ayron_crm/ui/series/series_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

class EventSeriesListView
    extends
        DataListView<
          EventSeries,
          EventSeriesListViewmodel,
          EventSeriesListView
        > {
  const EventSeriesListView({super.key, required super.viewmodel});

  @override
  State<EventSeriesListView> createState() => _EventSeriesListViewState();
}

class _EventSeriesListViewState
    extends
        DataListViewState<
          EventSeries,
          EventSeriesListViewmodel,
          EventSeriesListView
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
  Widget buildEntry(BuildContext context, EventSeries entity) {
    return EventSeriesListEntry(series: entity, onDelete: (org) => delete(org));
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
  String get entityDisplay => "Veranstaltungsreihe";

  @override
  String get route => Routes.series;
}
