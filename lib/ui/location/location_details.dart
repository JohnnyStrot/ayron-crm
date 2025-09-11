import 'package:ayron_crm/data/model/location.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/address_input.dart';
import 'package:ayron_crm/ui/core/ui/image_upload.dart';
import 'package:ayron_crm/ui/core/ui/image_view.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_info_box.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_name_field.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_social_media.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_state_input.dart';
import 'package:ayron_crm/ui/details/details_view.dart';
import 'package:ayron_crm/ui/gig/create_gig_button.dart';
import 'package:ayron_crm/ui/location/location_details_viewmodel.dart';
import 'package:ayron_crm/ui/opportunity_contact/opportunity_contact_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationDetails
    extends DetailsView<Location, LocationDetails, LocationDetailsViewmodel> {
  const LocationDetails({super.key, required super.viewmodel});

  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState
    extends DetailsState<Location, LocationDetails, LocationDetailsViewmodel> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.viewmodel.createEntity,
        widget.viewmodel.loadEntity,
        widget.viewmodel.saveEntity,
      ]),
      builder: (context, _) {
        final location = widget.viewmodel.entity;
        if (location != null) {
          return DefaultTabController(
            initialIndex: 0,
            length: 2,
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
                        text: "Location ",
                        style: TextStyle(fontWeight: FontWeight.w200),
                      ),
                      TextSpan(
                        text: location.name.isEmpty
                            ? "#${location.id}"
                            : location.name,
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
                    Tab(text: "Kontakte"),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  Form(
                    key: formKey,
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.of(context).paddingScreenVertical,
                        horizontal: Dimens.of(context).paddingScreenHorizontal,
                      ),
                      children: [
                        OpportunityNameField(opportunity: location),
                        SizedBox(height: Dimens.vdivide),
                        OpportunityStateInput(opportunity: location),
                        SizedBox(height: Dimens.vdivide),
                        AddressInput(addressable: location),
                        SizedBox(height: Dimens.vdivide),
                        OpportunityInfoBox(opportunity: location),
                        SizedBox(height: Dimens.vgap),
                        TextFormField(
                          controller: TextEditingController(
                            text: location.publicShorttext,
                          ),
                          onChanged: (value) =>
                              location.publicShorttext = value,
                          decoration: InputDecoration(
                            label: Text("Kurztext für Website"),
                          ),
                          maxLines: 3,
                          minLines: 3,
                        ),
                        SizedBox(height: Dimens.vdivide),
                        Row(
                          spacing: Dimens.hgap,
                          children: [
                            Expanded(
                              child: ImageView(
                                type: "location",
                                attr: "logo",
                                id: location.id,
                                label: "Logo",
                                image: location.logo,
                                apiService: context.read(),
                              ),
                            ),
                            Expanded(
                              child: ImageView(
                                type: "location",
                                attr: "images",
                                id: location.id,
                                label: "Bilder",
                                images: location.images,
                                apiService: context.read(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimens.vdivide),
                        OpportunitySocialMedia(opportunity: location),
                        SizedBox(height: Dimens.vgap),
                        TextFormField(
                          validator: (value) =>
                              value == null || (value.length <= 512)
                              ? null
                              : "Max. 512 Zeichen",
                          controller: TextEditingController(
                            text: location.googlemaps,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Google Maps"),
                          ),
                          onChanged: (value) {
                            location.googlemaps = value;
                          },
                        ),
                        SizedBox(height: Dimens.fabGap),
                      ],
                    ),
                  ),
                  OpportunityContactPage(opportunity: location),
                ],
              ),
            ),
          );
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }

  @override
  String get typeDisplay => "Location";
}
