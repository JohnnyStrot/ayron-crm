import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/ui/contact/contact_details_viewmodel.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/address_input.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_info_box.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_name_field.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_social_media.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_state_input.dart';
import 'package:ayron_crm/ui/details/details_view.dart';
import 'package:flutter/material.dart';

class ContactDetails
    extends DetailsView<Contact, ContactDetails, ContactDetailsViewmodel> {
  const ContactDetails({super.key, required super.viewmodel});

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState
    extends DetailsState<Contact, ContactDetails, ContactDetailsViewmodel> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.viewmodel.createEntity,
        widget.viewmodel.loadEntity,
        widget.viewmodel.saveEntity,
      ]),
      builder: (context, _) {
        final contact = widget.viewmodel.entity;
        if (contact != null) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: submit,
              child: Icon(Icons.save),
            ),
            body: Form(
              key: formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: Dimens.of(context).paddingScreenVertical,
                  horizontal: Dimens.of(context).paddingScreenHorizontal,
                ),
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Kontakt ",
                          style: TextStyle(fontWeight: FontWeight.w200),
                        ),
                        TextSpan(
                          text: contact.displayShort.isEmpty
                              ? "#${contact.id}"
                              : contact.displayShort,
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
                  SizedBox(height: Dimens.vgap),
                  OpportunityNameField(opportunity: contact),
                  SizedBox(height: Dimens.vgap),
                  TextFormField(
                    controller: TextEditingController(text: contact.email),
                    onChanged: (value) => contact.email = value,
                    decoration: InputDecoration(label: Text("E-Mail")),
                    validator: (value) => value == null || (value.length <= 72)
                        ? null
                        : "Max. 52 Zeichen",
                  ),
                  SizedBox(height: Dimens.vgap),
                  TextFormField(
                    controller: TextEditingController(text: contact.tel),
                    onChanged: (value) => contact.tel = value,
                    decoration: InputDecoration(label: Text("Tel.")),
                    validator: (value) => value == null || (value.length <= 20)
                        ? null
                        : "Max. 52 Zeichen",
                  ),
                  SizedBox(height: Dimens.vdivide),
                  AddressInput(addressable: contact),
                  SizedBox(height: Dimens.vdivide),
                  OpportunityStateInput(opportunity: contact),
                  SizedBox(height: Dimens.vdivide),
                  OpportunitySocialMedia(opportunity: contact),
                  SizedBox(height: Dimens.vdivide),
                  OpportunityInfoBox(opportunity: contact),
                  SizedBox(height: Dimens.fabGap),
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
  String get typeDisplay => "Kontakt";
}
