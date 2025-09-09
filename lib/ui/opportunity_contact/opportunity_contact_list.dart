import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/data/model/band_member.dart';
import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/contact_protocol.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/opportunity_contact.dart';
import 'package:ayron_crm/data/model/to_one.dart';
import 'package:ayron_crm/data/repositories/band_member/band_member_repository.dart';
import 'package:ayron_crm/data/repositories/contact/contact_repository.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/data/repositories/opportunity_contact/opportunity_contact_repository.dart';
import 'package:ayron_crm/ui/contact_protocol/protocol_details.dart';
import 'package:ayron_crm/ui/contact_protocol/protocol_list.dart';
import 'package:ayron_crm/ui/core/callable_change_notifier.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class _OpportunityContactList<T extends Opportunity>
    extends StatefulWidget {
  final T opportunity;

  final ContactRepository repository;
  final CallableChangeNotifier? updateProtocols;

  /// When pressing the protocol add button,
  /// this opportunity is added to the protocol if not null.
  /// If null, the opportunity field is used.
  final Opportunity? protocolOpportunity;

  const _OpportunityContactList({
    super.key,
    required this.repository,
    required this.opportunity,
    this.updateProtocols,
    this.protocolOpportunity,
    this.label,
  });

  final Widget? label;
  String get textSemantics;

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

class _ExpansionItem<O> {
  _ExpansionItem({required this.item, this.isExpanded = false});

  O item;
  bool isExpanded;
}

abstract class _ContactListState<
  T extends Opportunity,
  W extends _OpportunityContactList<T>,
  O
>
    extends State<W> {
  @override
  void dispose() {
    super.dispose();
  }

  late List<_ExpansionItem<O>> _items;
  List<_ExpansionItem<O>> get opportunityContacts => _items;
  void saveOpCo(Contact contact, String text);
  void deleteOpCo(int opportunityId, int contactId);
  Contact? getContact(O opCo);
  String getText(O opCo);

  ExpansionPanel panelFromOpCo(_ExpansionItem<O> item) {
    Contact? contact = getContact(item.item);
    String text = getText(item.item);
    if (contact == null) {
      return ExpansionPanel(
        headerBuilder: (context, isExpanded) => Text("null"),
        body: Text("null"),
      );
    }
    return ExpansionPanel(
      isExpanded: item.isExpanded,
      headerBuilder: (context, isExpanded) => Padding(
        padding: const EdgeInsets.only(
          top: Dimens.vgap,
          bottom: Dimens.vgap,
          left: Dimens.hgap,
        ),
        child: Row(
          spacing: Dimens.hgap / 2.0,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(contact.displayIcon),
            Expanded(
              flex: 3,
              child: Text(
                contact.displayShort,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (getText(item.item).isNotEmpty)
              Expanded(
                flex: 1,
                child: Text(
                  text,
                  style: TextTheme.of(context).bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            IconButton(
              alignment: Alignment.centerRight,
              onPressed: () {
                addProtocol(getContact(item.item));
              },
              icon: Icon(Icons.playlist_add),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          right: Dimens.hgap,
          bottom: Dimens.vgap,
          left: Dimens.hgap,
        ),
        child: Column(
          spacing: Dimens.vgap,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: Dimens.hgap,
              alignment: WrapAlignment.end,
              children: [
                if (contact.email.isNotEmpty)
                  Row(
                    spacing: 5.0,
                    children: [Icon(Icons.mail), Text(contact.email)],
                  ),
                if (contact.tel.isNotEmpty)
                  Row(
                    spacing: 5.0,
                    children: [Icon(Icons.phone), Text(contact.tel)],
                  ),
                if (contact.instagram.isNotEmpty)
                  Row(
                    spacing: 5.0,
                    children: [
                      Icon(Icons.alternate_email),
                      Text(contact.instagram),
                    ],
                  ),
              ],
            ),
            Text(contact.info, overflow: TextOverflow.visible),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    addProtocol(contact);
                  },
                  icon: Icon(Icons.playlist_add),
                ),
                IconButton(
                  onPressed: () {
                    showProtocols(
                      "Protokoll ${contact.displayShort}",
                      contact: contact,
                    );
                  },
                  icon: Icon(Icons.list),
                ),
                IconButton(
                  onPressed: () {
                    deleteOpCo(widget.opportunity.id, contact.id);
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.paddingHorizontal,
            vertical: Dimens.paddingVertical,
          ),
          child: Row(
            spacing: Dimens.hgap,
            children: [
              widget.label ??
                  Text("Kontakte", style: TextTheme.of(context).headlineSmall),
              dropdown,
            ],
          ),
        ),
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              opportunityContacts[index].isExpanded = isExpanded;
            });
          },
          materialGapSize: 1.0,
          children: opportunityContacts.map(panelFromOpCo).toList(),
        ),
      ],
    );
  }

  void addContact({required Contact? contact}) async {
    if (contact != null) {
      var text = "";
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("${widget.textSemantics} von ${contact.displayShort}"),
            content: TextFormField(
              onChanged: (value) => text = value,
              decoration: InputDecoration(label: Text(widget.textSemantics)),
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
      saveOpCo(contact, text);
    }
  }

  void showProtocols(
    String title, {
    List<ContactProtocol>? protocols,
    Contact? contact,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(title, overflow: TextOverflow.ellipsis),
        contentPadding: EdgeInsetsGeometry.only(
          bottom: Dimens.paddingVertical,
          top: Dimens.paddingVertical,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: Dimens.paddingHorizontal),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Schließen"),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimens.vgap),
          ProtocolList(
            protocols: protocols,
            contact: contact,
            repository: context.read(),
            showContact: false,
            showOpp: true,
          ),
          SizedBox(height: Dimens.vdivide),
        ],
      ),
    );
  }

  void addProtocol(Contact? contact) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => ProtocolDetails(
          repository: context.read(),
          contact: contact,
          opportunity: widget.protocolOpportunity ?? widget.opportunity,
        ),
      ),
    );
    if (widget.updateProtocols != null) {
      widget.updateProtocols!.change();
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

class _OpportunityContactListState
    extends
        _ContactListState<
          Opportunity,
          OpportunityContactList,
          OpportunityContact
        > {
  @override
  void initState() {
    _items = widget.opportunity.contacts
        .map((c) => _ExpansionItem(item: c))
        .toList();
    super.initState();
  }

  @override
  void saveOpCo(Contact contact, String text) {
    OpportunityContact opco = OpportunityContact(
      opportunity: ToOne(id: widget.opportunity.id),
      contact: ToOne(entity: contact),
      role: text,
    );
    widget.opcoRepository.saveOpCo(opco).then((value) {
      if (value is Ok<void>) {
        setState(() {
          widget.opportunity.contacts.add(opco);
          opportunityContacts.add(_ExpansionItem(item: opco));
        });
      }
    });
  }

  @override
  void deleteOpCo(int? opportunityId, int? contactId) {
    if (opportunityId != null && contactId != null) {
      widget.opcoRepository.deleteOpCo(opportunityId, contactId).then((v) {
        if (v is Ok<void>) {
          setState(() {
            opportunityContacts.removeWhere(
              (c) =>
                  c.item.opportunityId == opportunityId &&
                  c.item.contactId == contactId,
            );
          });
        }
      });
    }
  }

  @override
  Contact? getContact(OpportunityContact opCo) {
    return opCo.contact;
  }

  @override
  String getText(OpportunityContact opCo) {
    return opCo.role;
  }

  late List<_ExpansionItem<OpportunityContact>> _items;

  @override
  List<_ExpansionItem<OpportunityContact>> get opportunityContacts => _items;
}

class OpportunityContactList extends _OpportunityContactList<Opportunity> {
  final OpportunityContactRepository opcoRepository;

  const OpportunityContactList({
    super.key,
    required super.opportunity,
    required super.repository,
    required this.opcoRepository,
    super.updateProtocols,
    super.protocolOpportunity,
    super.label,
  });

  @override
  String get textSemantics => "Rolle";

  @override
  State<StatefulWidget> createState() => _OpportunityContactListState();
}

class _BandMemberListState
    extends _ContactListState<Band, BandMemberList, BandMember> {
  @override
  void initState() {
    _items = widget.opportunity.members
        .map((c) => _ExpansionItem(item: c))
        .toList();
    super.initState();
  }

  @override
  void saveOpCo(Contact contact, String text) {
    BandMember member = BandMember(
      band: ToOne(id: widget.opportunity.id),
      contact: ToOne(entity: contact),
      instrument: text,
    );
    widget.bandMemberRepository.saveBandMember(member).then((value) {
      if (value is Ok<void>) {
        setState(() {
          widget.opportunity.members.add(member);
          opportunityContacts.add(_ExpansionItem(item: member));
        });
      }
    });
  }

  @override
  void deleteOpCo(int? bandId, int? contactId) {
    if (bandId != null && contactId != null) {
      widget.bandMemberRepository.deleteBandMember(bandId, contactId).then((v) {
        if (v is Ok<void>) {
          setState(() {
            opportunityContacts.removeWhere(
              (c) => c.item.bandId == bandId && c.item.contactId == contactId,
            );
          });
        }
      });
    }
  }

  @override
  Contact? getContact(BandMember mem) {
    return mem.contact;
  }

  @override
  String getText(BandMember mem) {
    return mem.instrument;
  }
}

class BandMemberList extends _OpportunityContactList<Band> {
  final BandMemberRepository bandMemberRepository;

  const BandMemberList({
    super.key,
    required super.opportunity,
    required super.repository,
    required this.bandMemberRepository,
    super.updateProtocols,
    super.protocolOpportunity,
    super.label,
  });

  @override
  String get textSemantics => "Instrument";

  @override
  State<StatefulWidget> createState() => _BandMemberListState();
}
