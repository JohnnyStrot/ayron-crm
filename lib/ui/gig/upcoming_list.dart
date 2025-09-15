import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/data/repositories/gig/gig_repository.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/rounded_image_icon.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UpcomingList extends StatefulWidget {
  const UpcomingList({super.key, required this.repository});

  final GigRepository repository;

  @override
  State<UpcomingList> createState() => _UpcomingListState();
}

class _UpcomingListState extends State<UpcomingList> {
  _UpcomingListState() : upcomingGigs = [];

  List<Gig> upcomingGigs;

  @override
  void initState() {
    widget.repository.getUpcoming().then((res) {
      switch (res) {
        case Ok<List<Gig>>():
          setState(() {
            upcomingGigs = res.value;
          });
        case Error<List<Gig>>():
          if (mounted && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Fehler beim Laden der Gigs")),
            );
          }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimens.vgap,
        horizontal: Dimens.paddingHorizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.vgap,
        children: [
          Text("Anstehende Gigs", style: TextTheme.of(context).headlineSmall),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                Gig gig = upcomingGigs[index];
                return Card(
                  elevation: 0.5,
                  margin: EdgeInsets.symmetric(
                    vertical: Dimens.vgap / 2.0,
                    horizontal: Dimens.hgap,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.0),
                    onTap: () {
                      context.push("${Routes.gigs}/${gig.id}");
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.vgap,
                        horizontal: Dimens.hgap,
                      ),
                      child: Column(
                        spacing: Dimens.vgap,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runAlignment: WrapAlignment.spaceBetween,
                            children: [
                              Text(
                                gig.date?.toIso8601String().substring(0, 10) ??
                                    "",
                              ),
                              Text(gig.location?.address ?? ""),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: Dimens.hgap,
                            children: [
                              Text(
                                gig.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextTheme.of(context).headlineSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                              ),
                              if (gig.thumbnail != null)
                                RoundedImageIcon(
                                  size: 40,
                                  imageLocation:
                                      "gig/thumbnail/${gig.id}/${gig.thumbnail}",
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: upcomingGigs.length,
            ),
          ),
        ],
      ),
    );
  }
}
