import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/opportunity_contact.dart';
import 'package:ayron_crm/data/model/to_one.dart';
import 'package:ayron_crm/data/repositories/contact/contact_repository.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/data/repositories/opportunity_contact/opportunity_contact_repository.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OpportunityContactList extends StatefulWidget {
  final Opportunity opportunity;

  final ContactRepository repository;
  final OpportunityContactRepository opcoRepository;

  const OpportunityContactList({
    super.key,
    required this.opportunity,
    required this.repository,
    required this.opcoRepository,
    this.label = "Kontakte",
  });

  final String label;

  @override
  State<OpportunityContactList> createState() => _OpportunityContactListState();

  Future<Result<List<Contact>>> getEntities(
    String filter,
    LoadProps? loadProps,
  ) {
    return repository
        .getEntities(
          filter: {"filter": filter},
          skip: loadProps?.skip,
          take: loadProps?.take,
          order: "name",
          orderDesc: false,
        )
        .then((v) {
          switch (v) {
            case Ok<ResultList<Contact>>():
              return Result.ok(v.value.entities);
            case Error<ResultList<Contact>>():
              return Result.error(v.error);
          }
        });
  }
}

class _OpportunityContactListState extends State<OpportunityContactList> {
  final CarouselController controller = CarouselController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget dropdown = DropdownSearch<Contact>(
      compareFn: (item1, item2) => item1.id == item2.id,
      onChanged: (contact) {
        addContact(contact: contact);
      },
      clickProps: ClickProps(borderRadius: BorderRadius.circular(50)),
      mode: Mode.custom,
      items: _getData,
      itemAsString: (item) => item.name,
      dropdownBuilder: (ctx, selectedItem) => Icon(Icons.add),
      popupProps: PopupProps.modalBottomSheet(
        cacheItems: true,
        modalBottomSheetProps: ModalBottomSheetProps(
          backgroundColor: ColorScheme.of(context).surfaceContainer,
        ),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(label: Text("Suche...")),
          padding: EdgeInsets.symmetric(
            vertical: Dimens.paddingVertical,
            horizontal: Dimens.paddingHorizontal,
          ),
        ),
        showSearchBox: true,
        itemBuilder: (context, item, isDisabled, isSelected) {
          return Padding(
            padding: EdgeInsetsGeometry.symmetric(
              vertical: Dimens.of(context).paddingScreenVertical,
              horizontal: Dimens.of(context).paddingScreenHorizontal,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: Dimens.hgap,
              children: [
                Expanded(
                  child: Text(
                    item.displayShort,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        item.tel,
                        style: TextTheme.of(context).bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.email,
                        style: TextTheme.of(context).bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.instagram.isNotEmpty ? "@${item.instagram}" : "",
                        style: TextTheme.of(context).bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.paddingHorizontal,
        vertical: Dimens.paddingVertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: Dimens.hgap,
            children: [
              Text(widget.label, style: TextTheme.of(context).headlineSmall),
              dropdown,
            ],
          ),
          SizedBox(
            height: 200.0,
            child: CarouselView.weighted(
              controller: controller,
              itemSnapping: true,
              flexWeights: const <int>[8, 1],
              enableSplash: false,
              children: [
                for (var c in widget.opportunity.contacts)
                  ContactCard(
                    contact: c,
                    onDelete: () {
                      if (c.opportunityId != null && c.contactId != null) {
                        widget.opcoRepository
                            .deleteOpCo(c.opportunityId!, c.contactId!)
                            .then((v) {
                              if (v is Ok<void>) {
                                setState(() {
                                  widget.opportunity.contacts.remove(c);
                                });
                              }
                            });
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addContact({required Contact? contact}) async {
    if (contact != null) {
      var text = "";
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Rolle von ${contact.displayShort}"),
            content: TextFormField(
              onChanged: (value) => text = value,
              decoration: InputDecoration(label: Text("Rolle")),
            ),
            actions: [
              FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.add),
                label: Text("Kontakt"),
              ),
            ],
          );
        },
      );
      OpportunityContact opco = OpportunityContact(
        opportunity: ToOne(id: widget.opportunity.id),
        contact: ToOne(entity: contact),
        role: text,
      );
      widget.opcoRepository.saveOpCo(opco).then((value) {
        if (value is Ok<void>) {
          setState(() {
            widget.opportunity.contacts.add(opco);
          });
        }
      });
    }
  }

  Future<List<Contact>> _getData(String filter, LoadProps? loadProps) {
    return widget.getEntities(filter, loadProps).then((result) {
      switch (result) {
        case Ok<List<Contact>>():
          return result.value;
        case Error<List<Contact>>():
          return Future.value([]);
      }
    });
  }
}

class ContactCard extends StatelessWidget {
  final OpportunityContact contact;

  final void Function() onDelete;

  const ContactCard({super.key, required this.contact, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Dimens.paddingVertical,
          horizontal: Dimens.paddingHorizontal,
        ),
        child: SizedBox(
          width: 230.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimens.paddingHorizontal,
                      ),
                      child: Icon(Icons.person),
                    ),
                    Text(
                      contact.contact?.displayShort ?? "",
                      style: TextTheme.of(context).headlineSmall!.copyWith(
                        fontSize: TextTheme.of(context).bodyMedium!.fontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      children: [
                        Text(
                          contact.contact?.email ?? "",
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          contact.contact?.tel ?? "",
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          contact.contact?.instagram != null &&
                                  (contact.contact?.instagram)!.isNotEmpty
                              ? "@${contact.contact?.instagram}"
                              : "",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ClipRect(
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (contact.contactId != null) {
                            context.push(
                              "${Routes.contacts}/${contact.contactId}",
                            );
                          }
                        },
                        icon: Icon(Icons.open_in_new),
                      ),
                      Expanded(child: SizedBox()),
                      IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.playlist_add),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.list)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
