import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/datepicker.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_info_box.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_name_field.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_social_media.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_state_input.dart';
import 'package:ayron_crm/ui/core/ui/timeofdaypicker.dart';
import 'package:ayron_crm/ui/details/details_view.dart';
import 'package:ayron_crm/ui/event/event_details_viewmodel.dart';
import 'package:ayron_crm/ui/event/lineup_list.dart';
import 'package:ayron_crm/ui/location/location_select.dart';
import 'package:ayron_crm/ui/organisation/organisation_select.dart';
import 'package:ayron_crm/ui/series/series_select.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetails
    extends DetailsView<Event, EventDetails, EventDetailsViewmodel> {
  const EventDetails({super.key, required super.viewmodel});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState
    extends DetailsState<Event, EventDetails, EventDetailsViewmodel> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListenableBuilder(
        listenable: Listenable.merge([
          widget.viewmodel.createEntity,
          widget.viewmodel.loadEntity,
          widget.viewmodel.saveEntity,
        ]),
        builder: (context, _) {
          final event = widget.viewmodel.entity;
          if (event != null) {
            return DefaultTabController(
              initialIndex: 0,
              length: 3,
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
                          text: "Veranstaltung ",
                          style: TextStyle(fontWeight: FontWeight.w200),
                        ),
                        TextSpan(
                          text: event.name.isEmpty
                              ? "#${event.id}"
                              : event.name,
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
                        OpportunityNameField(opportunity: event),
                        SizedBox(height: Dimens.vdivide),
                        Column(
                          spacing: Dimens.vgap,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Datepicker(
                              initialValue: event.date,
                              label: "Datum",
                              onDate: (date) {
                                event.date = date;
                              },
                            ),
                            LocationSelect(
                              repository: context.read(),
                              onSelect: (l) => event.location = l,
                              initialValue: event.location,
                            ),
                            OrganisationSelect(
                              repository: context.read(),
                              onSelect: (o) => event.organisation = o,
                              initialValue: event.organisation,
                            ),
                            EventSeriesSelect(
                              repository: context.read(),
                              onSelect: (s) => event.series = s,
                              initialValue: event.series,
                            ),
                          ],
                        ),
                        SizedBox(height: Dimens.vdivide),
                        OpportunityStateInput(opportunity: event),
                        SizedBox(height: Dimens.vdivide),
                        OpportunityInfoBox(opportunity: event),
                        SizedBox(height: Dimens.fabGap),
                      ],
                    ),
                    ListView(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.of(context).paddingScreenVertical,
                        horizontal: Dimens.of(context).paddingScreenHorizontal,
                      ),
                      children: [
                        OpportunityNameField(opportunity: event),
                        SizedBox(height: Dimens.vgap),
                        Row(
                          spacing: Dimens.hgap,
                          children: [
                            Expanded(
                              child: TimeOfDayPicker(
                                label: "Einlass",
                                onTimeOfDay: (t) => event.doors = t,
                                initialValue: event.doors,
                              ),
                            ),
                            Expanded(
                              child: TimeOfDayPicker(
                                label: "Beginn",
                                onTimeOfDay: (t) => event.begin = t,
                                initialValue: event.begin,
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
                                  text: event.price,
                                ),
                                onChanged: (value) => event.price = value,
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
                                  text: event.tickets,
                                ),
                                onChanged: (value) => event.tickets = value,
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
                          controller: TextEditingController(
                            text: event.summary,
                          ),
                          onChanged: (value) => event.summary = value,
                          decoration: InputDecoration(label: Text("Kurztext")),
                          maxLines: 3,
                          minLines: 3,
                        ),
                        SizedBox(height: Dimens.vgap),
                        TextFormField(
                          controller: TextEditingController(
                            text: event.description,
                          ),
                          onChanged: (value) => event.description = value,
                          decoration: InputDecoration(
                            label: Text("Beschreibung"),
                          ),
                          maxLines: 6,
                          minLines: 6,
                        ),
                        SizedBox(height: Dimens.vdivide),
                        LineupList(event: event),
                        SizedBox(height: Dimens.vdivide),
                        OpportunitySocialMedia(opportunity: event),
                        SizedBox(height: Dimens.fabGap),
                      ],
                    ),
                    Text("rainy"),
                  ],
                ),
              ),
            );
          } else {
            return LinearProgressIndicator();
          }
        },
      ),
    );
  }

  @override
  String get typeDisplay => "Event";
}
