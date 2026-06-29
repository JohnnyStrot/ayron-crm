import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/protocol.dart';
import 'package:ayron_crm/data/repositories/contact_protocol/contact_protocol_repository.dart';
import 'package:ayron_crm/ui/contact_protocol/protocol_details.dart';
import 'package:ayron_crm/ui/core/callable_change_notifier.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ExpansionProtocolItem {
  _ExpansionProtocolItem({required this.protocol}) : isExpanded = false;

  Protocol protocol;
  bool isExpanded;
}

class ProtocolList extends StatefulWidget {
  const ProtocolList({
    super.key,
    required this.repository,
    this.opportunity,
    this.contact,
    this.showContact = true,
    this.showOpp = true,
    this.updateProtocols,
  });

  final bool showContact;
  final bool showOpp;

  final ContactProtocolRepository repository;

  final Opportunity? opportunity;
  final Contact? contact;

  final CallableChangeNotifier? updateProtocols;

  @override
  State<ProtocolList> createState() => _ProtocolListState();
}

class _ProtocolListState extends State<ProtocolList> {
  List<Protocol> _protocols = [];
  List<_ExpansionProtocolItem> _items = [];

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _updateProtocols();
    if (widget.updateProtocols != null) {
      widget.updateProtocols!.addListener(_updateProtocols);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.updateProtocols != null) {
      widget.updateProtocols!.removeListener(_updateProtocols);
    }
    super.dispose();
  }

  void _update() async {
    if (widget.updateProtocols != null) {
      widget.updateProtocols!.change();
    } else {
      _updateProtocols();
    }
  }

  void _updateProtocols() {
    Future<Result<List<Protocol>>> res;
    if (widget.opportunity != null) {
      res = widget.repository.getProtocolsOpportunity(widget.opportunity!);
    } else if (widget.contact != null) {
      res = widget.repository.getProtocolsContact(widget.contact!);
    } else {
      res = Future.value(Result.ok([]));
    }

    res.then((res) {
      switch (res) {
        case Ok<List<Protocol>>():
          _protocols = res.value;
        case Error<List<Protocol>>():
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Fehler beim Laden der Protokolle")),
            );
          }
          _protocols = [];
      }

      _protocols.sort((a, b) => a.timestamp.isBefore(b.timestamp) ? 1 : -1);
      _createItems();
    });
  }

  void _createItems() {
    setState(() {
      _items = _protocols
          .map((e) => _ExpansionProtocolItem(protocol: e))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return Center(
        child: Text(
          "Keine Protokolle",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) =>
          setState(() => _items[panelIndex].isExpanded = isExpanded),
      children: _items.map(_toPanel).toList(),
    );
  }

  ExpansionPanel _toPanel(_ExpansionProtocolItem item) {
    Protocol prot = item.protocol;
    return ExpansionPanel(
      isExpanded: item.isExpanded,
      headerBuilder: (context, isExpanded) => Padding(
        padding: const EdgeInsets.only(
          left: Dimens.paddingHorizontal,
          top: Dimens.vgap,
          bottom: Dimens.vgap,
        ),
        child: Row(
          spacing: Dimens.hgap,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(prot.timestamp.toIso8601String().substring(0, 10)),
            ),
            Expanded(
              flex: 5,
              child: Column(
                spacing: Dimens.vgap / 2.0,
                children: [
                  Row(
                    spacing: 2.0,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(child: Icon(prot.icon)),
                      Expanded(
                        flex: 3,
                        child: Text(prot.type, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  if (widget.showContact &&
                      prot.contacts != null &&
                      prot.contacts!.isNotEmpty)
                    Row(
                      spacing: 2.0,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(child: Icon(prot.contacts!.first.displayIcon)),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "${prot.contacts!.first.displayShort}${prot.contacts!.length > 1 ? " +${prot.contacts!.length - 1}" : ""}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (widget.showOpp &&
                      prot.opportunities != null &&
                      prot.opportunities!.isNotEmpty)
                    Row(
                      spacing: 2.0,
                      children: [
                        Expanded(
                          child: Icon(prot.opportunities!.first.typeIcon),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "${prot.opportunities!.first.displayShort}${prot.opportunities!.length > 1 ? " +${prot.opportunities!.length - 1}" : ""}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.paddingHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(prot.content),
            Row(
              children: [
                Text(
                  prot.user,
                  style: TextTheme.of(
                    context,
                  ).bodySmall!.copyWith(fontStyle: FontStyle.italic),
                ),
                Expanded(child: SizedBox()),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: Dimens.contentMaxWidth,
                            ),
                            child: ProtocolDetails(
                              repository: context.read(),
                              id: prot.id,
                            ),
                          ),
                        ),
                      ),
                    ).then((val) {
                      setState(() {
                        _update();
                      });
                    });
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () async {
                    var result = await widget.repository.deleteEntity(prot.id);
                    switch (result) {
                      case Ok<void>():
                        setState(() {
                          if (_protocols.isNotEmpty) {
                            _protocols.remove(prot);
                            _update();
                          }
                          _items.remove(item);
                        });
                      case Error<void>():
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Fehler beim Löschen")),
                          );
                        }
                    }
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
}
