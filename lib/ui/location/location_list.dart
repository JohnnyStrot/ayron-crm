import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/location/location_list_entry.dart';
import 'package:flutter/material.dart';

import 'location_list_viewmodel.dart';

class LocationList extends StatelessWidget {
  const LocationList({super.key, required LocationListViewmodel viewmodel})
    : _viewmodel = viewmodel;

  final LocationListViewmodel _viewmodel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewmodel,
      builder: (context, _) {
        final locs = _viewmodel.locations;
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                top: Dimens.paddingVertical,
                left: Dimens.of(context).paddingScreenHorizontal,
                right: Dimens.of(context).paddingScreenHorizontal,
                bottom: Dimens.paddingVertical,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final location = locs[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < locs.length - 1 ? 20 : 0,
                    ),
                    child: LocationListEntry(location: location),
                  );
                }, childCount: locs.length),
              ),
            ),
          ],
        );
      },
    );
  }
}
