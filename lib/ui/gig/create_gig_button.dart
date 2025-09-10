import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/model/event_series.dart';
import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/data/model/organisation.dart';
import 'package:ayron_crm/data/repositories/gig/gig_repository.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateGigButton extends StatelessWidget {
  const CreateGigButton({
    super.key,
    this.organisation,
    this.series,
    this.location,
    this.event,
    required this.repository,
  });

  final GigRepository repository;
  final Organisation? organisation;
  final EventSeries? series;
  final Location? location;
  final Event? event;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {
        repository
            .createGig(
              organisation: organisation,
              location: location,
              series: series,
              event: event,
            )
            .then((res) {
              if (context.mounted) {
                switch (res) {
                  case Ok<Gig>():
                    context.push("${Routes.gigs}/${res.value.id}");
                  case Error<Gig>():
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Gig konnte nicht erstellt werden"),
                      ),
                    );
                }
              }
            });
      },
      icon: Icon(Icons.stadium),
      label: Text("Gig"),
    );
  }
}
