import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_state_select.dart';
import 'package:ayron_crm/ui/list_widgets/data_list_view.dart';
import 'package:ayron_crm/ui/location/location_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

import 'location_list_viewmodel.dart';

class LocationListView
    extends DataListView<Location, LocationListViewmodel, LocationListView> {
  const LocationListView({super.key, required super.viewmodel});

  @override
  State<LocationListView> createState() => _LocationListViewState();
}

class _LocationListViewState
    extends
        DataListViewState<Location, LocationListViewmodel, LocationListView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    nameController
        .debounce(Durations.medium2)
        .listen((text, _) => widget.viewmodel.nameChanged(text.text));
    cityController
        .debounce(Durations.medium2)
        .listen((text, _) => widget.viewmodel.cityChanged(text.text));
    super.initState();
  }

  @override
  Widget buildEntry(BuildContext context, Location entity) {
    return LocationListEntry(location: entity, onDelete: (loc) => delete(loc));
  }

  @override
  Widget buildSearch(BuildContext context) {
    return Column(
      spacing: Dimens.vgap,
      children: [
        Row(
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
              child: TextField(
                controller: cityController,
                decoration: InputDecoration(
                  label: Text("Stadt"),
                  suffixIcon: IconButton(
                    onPressed: () {
                      cityController.clear();
                    },
                    icon: Icon(Icons.clear),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        Row(
          spacing: Dimens.paddingHorizontal,
          children: [
            Expanded(
              child: OpportunityStateSelect(
                onSelected: (value) => widget.viewmodel.stateChanged(value),
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  @override
  String get entityDisplay => "Location";

  @override
  String get route => Routes.locations;
}
