import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LocationListEntry extends StatelessWidget {
  const LocationListEntry({
    super.key,
    required this.location,
    required this.onDelete,
  });

  final Location location;

  final void Function(Location loc) onDelete;

  @override
  Widget build(BuildContext context) {
    final action = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            context.push("${Routes.locations}/${location.id}");
          },
          icon: Icon(Icons.edit),
        ),
        IconButton(
          onPressed: () {
            onDelete(location);
          },
          icon: Icon(Icons.delete),
        ),
      ],
    );
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.fromLTRB(
          bottom: BorderSide(
            color: ColorScheme.of(context).primary.withAlpha(60),
            style: BorderStyle.solid,
          ),
          left: BorderSide(
            color: location.state.color,
            style: BorderStyle.solid,
            width: 5.0,
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: 10, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  location.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextTheme.of(context).displaySmall!.copyWith(
                    fontSize: TextTheme.of(context).bodyLarge!.fontSize,
                  ),
                ),
                Text(location.city),
              ],
            ),
          ),
          action,
        ],
      ),
    );
  }
}
