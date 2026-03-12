import 'package:ayron_crm/data/model/gig.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/datepicker.dart';
import 'package:ayron_crm/ui/core/ui/image_view.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_info_box.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_name_field.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_social_media.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_state_input.dart';
import 'package:ayron_crm/ui/core/ui/timeofdaypicker.dart';
import 'package:ayron_crm/ui/details/details_view.dart';
import 'package:ayron_crm/ui/event/event_contact_page.dart';
import 'package:ayron_crm/ui/event/lineup_list.dart';
import 'package:ayron_crm/ui/gig/gig_details_viewmodel.dart';
import 'package:ayron_crm/ui/gig/gig_setlist.dart';
import 'package:ayron_crm/ui/location/location_select.dart';
import 'package:ayron_crm/ui/organisation/organisation_select.dart';
import 'package:ayron_crm/ui/series/series_select.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GigDetails extends DetailsView<Gig, GigDetails, GigDetailsViewmodel> {
  const GigDetails({super.key, required super.viewmodel});

  @override
  State<GigDetails> createState() => _GigDetailsState();
}

class _GigDetailsState
    extends DetailsState<Gig, GigDetails, GigDetailsViewmodel> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: formKey,
      child: ListenableBuilder(
        listenable: Listenable.merge([
          widget.viewmodel.createEntity,
          widget.viewmodel.loadEntity,
          widget.viewmodel.saveEntity,
        ]),
        builder: (context, _) {
          final gig = widget.viewmodel.entity;
          if (gig != null) {
            return DefaultTabController(
              initialIndex: 0,
              length: 4,
              child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: submit,
                  child: Icon(Icons.save),
                ),
                appBar: AppBar(
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Gig ",
                          style: TextStyle(fontWeight: FontWeight.w200),
                        ),
                        TextSpan(
                          text: gig.name.isEmpty ? "#${gig.id}" : gig.name,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      style: TextTheme.of(context).headlineSmall!.copyWith(
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  bottom: const TabBar(
                    tabs: <Widget>[
                      Tab(text: "Info"),
                      Tab(text: "Public"),
                      Tab(text: "Kontakte"),
                      Tab(text: "Setlist"),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    ListView(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.of(context).paddingScreenVertical,
                        horizontal: Dimens.of(context).paddingScreenHorizontal,
                      ),
                      children: [
                        OpportunityNameField(opportunity: gig),
                        SizedBox(height: Dimens.vdivide),
                        Column(
                          spacing: Dimens.vgap,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Datepicker(
                              initialValue: gig.date,
                              label: "Datum",
                              onDate: (date) {
                                gig.date = date;
                              },
                            ),
                            LocationSelect(
                              repository: context.read(),
                              onSelect: (l) => gig.location = l,
                              initialValue: gig.location,
                            ),
                            OrganisationSelect(
                              repository: context.read(),
                              onSelect: (o) => gig.organisation = o,
                              initialValue: gig.organisation,
                            ),
                            EventSeriesSelect(
                              repository: context.read(),
                              onSelect: (s) => gig.series = s,
                              initialValue: gig.series,
                            ),
                          ],
                        ),
                        SizedBox(height: Dimens.vdivide),
                        OpportunityStateInput(opportunity: gig),
                        SizedBox(height: Dimens.vdivide),
                        OpportunityInfoBox(opportunity: gig),
                        SizedBox(height: Dimens.fabGap),
                      ],
                    ),
                    ListView(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.of(context).paddingScreenVertical,
                        horizontal: Dimens.of(context).paddingScreenHorizontal,
                      ),
                      children: [
                        OpportunityNameField(opportunity: gig),
                        SizedBox(height: Dimens.vgap),
                        Row(
                          spacing: Dimens.hgap,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Switch(
                              value: gig.showOnWebsite,
                              onChanged: (value) => setState(() {
                                gig.showOnWebsite = value;
                              }),
                            ),
                            Text("Zeige auf Website"),
                          ],
                        ),
                        SizedBox(height: Dimens.vgap),
                        Row(
                          spacing: Dimens.hgap,
                          children: [
                            Expanded(
                              child: TimeOfDayPicker(
                                label: "Einlass",
                                onTimeOfDay: (t) => gig.doors = t,
                                initialValue: gig.doors,
                              ),
                            ),
                            Expanded(
                              child: TimeOfDayPicker(
                                label: "Beginn",
                                onTimeOfDay: (t) => gig.begin = t,
                                initialValue: gig.begin,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimens.vgap),
                        Row(
                          spacing: Dimens.hgap,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: TextEditingController(
                                  text: gig.price,
                                ),
                                onChanged: (value) => gig.price = value,
                                decoration: InputDecoration(
                                  label: Text("Eintrittspreis"),
                                ),
                                validator: (value) =>
                                    value == null || (value.length <= 30)
                                    ? null
                                    : "Max. 30 Zeichen",
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: TextEditingController(
                                  text: gig.tickets,
                                ),
                                onChanged: (value) => gig.tickets = value,
                                decoration: InputDecoration(
                                  label: Text("Ticket-Link"),
                                ),
                                validator: (value) =>
                                    value == null || (value.length <= 512)
                                    ? null
                                    : "Max. 512 Zeichen",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimens.vdivide),
                        TextFormField(
                          controller: TextEditingController(text: gig.summary),
                          onChanged: (value) => gig.summary = value,
                          decoration: InputDecoration(label: Text("Kurztext")),
                          maxLines: 3,
                          minLines: 3,
                        ),
                        SizedBox(height: Dimens.vgap),
                        TextFormField(
                          controller: TextEditingController(
                            text: gig.description,
                          ),
                          onChanged: (value) => gig.description = value,
                          decoration: InputDecoration(
                            label: Text("Beschreibung"),
                          ),
                          maxLines: 6,
                          minLines: 6,
                        ),
                        SizedBox(height: Dimens.vgap),
                        TextFormField(
                          controller: TextEditingController(
                            text: gig.flashback,
                          ),
                          onChanged: (value) => gig.flashback = value,
                          decoration: InputDecoration(label: Text("Rückblick")),
                          maxLines: 6,
                          minLines: 6,
                        ),
                        SizedBox(height: Dimens.vdivide),
                        LineupList(event: gig),
                        SizedBox(height: Dimens.vdivide),
                        OpportunitySocialMedia(opportunity: gig),
                        SizedBox(height: Dimens.vdivide),
                        Row(
                          children: [
                            Expanded(
                              child: ImageView(
                                type: "gig",
                                attr: "thumbnail",
                                id: gig.id,
                                label: "Thumbnail",
                                image: gig.thumbnail,
                                apiService: context.read(),
                              ),
                            ),
                            Expanded(
                              child: ImageView(
                                type: "gig",
                                attr: "poster",
                                id: gig.id,
                                label: "Poster",
                                image: gig.poster,
                                apiService: context.read(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimens.vgap),
                        ImageView(
                          type: "gig",
                          attr: "banner",
                          id: gig.id,
                          label: "Banner",
                          image: gig.banner,
                          apiService: context.read(),
                          imageAspectRatio: 7.0 / 4.0,
                        ),
                        SizedBox(height: Dimens.vgap),
                        ImageView(
                          type: "gig",
                          attr: "images",
                          id: gig.id,
                          label: "Bilder",
                          images: gig.images,
                          imageAspectRatio: 4.0 / 3.0,
                          apiService: context.read(),
                        ),
                        SizedBox(height: Dimens.fabGap),
                      ],
                    ),
                    EventContactPage(event: gig),
                    GigSetlist(
                      gig: gig,
                      repository: context.read(),
                      apiService: context.read(),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  String get typeDisplay => "Gig";
}
