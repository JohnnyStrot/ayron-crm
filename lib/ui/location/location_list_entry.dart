import 'package:ayron_crm/data/model/location.dart';
import 'package:flutter/material.dart';

class LocationListEntry extends StatelessWidget {
  const LocationListEntry({super.key, required this.location});

  final Location location;

  @override
  Widget build(BuildContext context) {
    return Text(location.name);
  }
}
