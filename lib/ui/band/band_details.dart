import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/ui/band/band_details_viewmodel.dart';
import 'package:ayron_crm/ui/band/member_list.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_info_box.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_name_field.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_social_media.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_state_input.dart';
import 'package:ayron_crm/ui/details/details_view.dart';
import 'package:flutter/material.dart';

class BandDetails extends DetailsView<Band, BandDetails, BandDetailsViewmodel> {
  const BandDetails({super.key, required super.viewmodel});

  @override
  State<BandDetails> createState() => _BandDetailsState();
}

class _BandDetailsState
    extends DetailsState<Band, BandDetails, BandDetailsViewmodel> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.viewmodel.createEntity,
        widget.viewmodel.loadEntity,
        widget.viewmodel.saveEntity,
      ]),
      builder: (context, _) {
        final band = widget.viewmodel.entity;
        if (band != null) {
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
                        text: "Band ",
                        style: TextStyle(fontWeight: FontWeight.w200),
                      ),
                      TextSpan(
                        text: band.name.isEmpty ? "#${band.id}" : band.name,
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
                        OpportunityNameField(opportunity: band),
                        SizedBox(height: Dimens.vgap),
                        TextFormField(
                          controller: TextEditingController(text: band.genre),
                          onChanged: (value) => band.genre = value,
                          decoration: InputDecoration(label: Text("Genre")),
                          validator: (value) =>
                              value == null || (value.length <= 52)
                              ? null
                              : "Max. 52 Zeichen",
                        ),
                        SizedBox(height: Dimens.vgap),
                        TextFormField(
                          controller: TextEditingController(text: band.city),
                          onChanged: (value) => band.city = value,
                          decoration: InputDecoration(label: Text("Stadt")),
                          validator: (value) =>
                              value == null || (value.length <= 50)
                              ? null
                              : "Max. 50 Zeichen",
                        ),
                        SizedBox(height: Dimens.vdivide),
                        OpportunityStateInput(opportunity: band),
                        SizedBox(height: Dimens.vdivide),
                        MemberList(band: band),
                        SizedBox(height: Dimens.vdivide),
                        OpportunityInfoBox(opportunity: band),
                        SizedBox(height: Dimens.vgap),
                        TextFormField(
                          controller: TextEditingController(
                            text: band.publicShorttext,
                          ),
                          onChanged: (value) => band.publicShorttext = value,
                          decoration: InputDecoration(
                            label: Text("Kurztext für Website"),
                          ),
                          maxLines: 3,
                          minLines: 3,
                        ),
                        SizedBox(height: Dimens.vdivide),
                        OpportunitySocialMedia(opportunity: band),
                        SizedBox(height: Dimens.fabGap),
                      ],
                    ),
                  ),
                  Center(child: Text("It's rainy here")),
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
  String get typeDisplay => "Band";
}
