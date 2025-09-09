import 'package:ayron_crm/data/model/organisation.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_info_box.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_name_field.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_social_media.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_state_input.dart';
import 'package:ayron_crm/ui/details/details_view.dart';
import 'package:ayron_crm/ui/opportunity_contact/opportunity_contact_page.dart';
import 'package:ayron_crm/ui/organisation/organisation_details_viewmodel.dart';
import 'package:flutter/material.dart';

class OrganisationDetails
    extends
        DetailsView<
          Organisation,
          OrganisationDetails,
          OrganisationDetailsViewmodel
        > {
  const OrganisationDetails({super.key, required super.viewmodel});

  @override
  State<OrganisationDetails> createState() => _OrganisationDetailsState();
}

class _OrganisationDetailsState
    extends
        DetailsState<
          Organisation,
          OrganisationDetails,
          OrganisationDetailsViewmodel
        > {
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
        final organisation = widget.viewmodel.entity;
        if (organisation != null) {
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
                        text: "Organisation ",
                        style: TextStyle(fontWeight: FontWeight.w200),
                      ),
                      TextSpan(
                        text: organisation.name.isEmpty
                            ? "#${organisation.id}"
                            : organisation.name,
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
                        OpportunityNameField(opportunity: organisation),
                        SizedBox(height: Dimens.vdivide),
                        OpportunityStateInput(opportunity: organisation),
                        SizedBox(height: Dimens.vdivide),
                        OpportunityInfoBox(opportunity: organisation),
                        SizedBox(height: Dimens.vgap),
                        TextFormField(
                          controller: TextEditingController(
                            text: organisation.publicShorttext,
                          ),
                          onChanged: (value) =>
                              organisation.publicShorttext = value,
                          decoration: InputDecoration(
                            label: Text("Kurztext für Website"),
                          ),
                          maxLines: 3,
                          minLines: 3,
                        ),
                        SizedBox(height: Dimens.vdivide),
                        OpportunitySocialMedia(opportunity: organisation),
                        SizedBox(height: Dimens.fabGap),
                      ],
                    ),
                  ),
                  OpportunityContactPage(opportunity: organisation),
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
  String get typeDisplay => "Organisation";
}
