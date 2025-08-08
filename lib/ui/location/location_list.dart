import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_state_select.dart';
import 'package:ayron_crm/ui/location/location_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:go_router/go_router.dart';

import 'location_list_viewmodel.dart';

class LocationList extends StatefulWidget {
  const LocationList({super.key, required LocationListViewmodel viewmodel})
    : _viewmodel = viewmodel;

  final LocationListViewmodel _viewmodel;

  @override
  State<LocationList> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    nameController
        .debounce(Durations.medium2)
        .listen((text, _) => widget._viewmodel.nameChanged(text.text));
    cityController
        .debounce(Durations.medium2)
        .listen((text, _) => widget._viewmodel.cityChanged(text.text));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var builder = ListenableBuilder(
      listenable: Listenable.merge([
        widget._viewmodel.loadLocations,
        widget._viewmodel.deleteLocation,
      ]),
      builder: (context, child) {
        final locs = widget._viewmodel.locations;
        final scrollView = CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(bottom: Dimens.paddingVertical),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final location = locs[index];
                  return Padding(
                    padding: EdgeInsets.only(top: index > 0 ? 10 : 0),
                    child: LocationListEntry(
                      location: location,
                      onDelete: (loc) => _delete(loc),
                    ),
                  );
                }, childCount: locs.length),
              ),
            ),
          ],
        );
        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              minHeight: 5,
              backgroundColor: ColorScheme.of(context).surfaceContainer,
              value: widget._viewmodel.loadLocations.isExecuting.value
                  ? null
                  : 0,
            ),
            Expanded(child: scrollView),
          ],
        );
      },
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push("${Routes.locations}${Routes.create}");
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.of(context).paddingScreenHorizontal,
          vertical: Dimens.of(context).paddingScreenVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: Dimens.paddingVertical,
          children: [
            Text("Locations", style: TextTheme.of(context).headlineSmall),
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
                    onSelected: (value) =>
                        widget._viewmodel.stateChanged(value),
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
            Expanded(child: builder),
          ],
        ),
      ),
    );
  }

  void _delete(Location loc) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Wirklich löschen?'),
          content: Text('Willst du wirklich die Location ${loc.name} löschen?'),
          actions: [
            TextButton(
              onPressed: () {
                widget._viewmodel.deleteLocation(loc);

                ctx.pop();
              },
              child: const Text('Ja'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                ctx.pop();
              },
              child: const Text('Nein'),
            ),
          ],
        );
      },
    );
  }
}
