import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/contact_protocol.dart';
import 'package:ayron_crm/data/repositories/contact_protocol/contact_protocol_repository.dart';
import 'package:ayron_crm/ui/contact_protocol/protocol_details.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ExpansionProtocolItem {
  _ExpansionProtocolItem({required this.protocol}) : isExpanded = false;

  ContactProtocol protocol;
  bool isExpanded;
}

class ProtocolList extends StatefulWidget {
  const ProtocolList({
    super.key,
    required this.repository,
    this.protocols,
    this.contact,
    this.showContact = true,
    this.showOpp = true,
    this.updateProtocols,
  });

  final bool showContact;
  final bool showOpp;

  final ContactProtocolRepository repository;

  final List<ContactProtocol>? protocols;
  final Contact? contact;

  final Listenable? updateProtocols;

  @override
  State<ProtocolList> createState() => _ProtocolListState();
}

class _ProtocolListState extends State<ProtocolList> {
  List<_ExpansionProtocolItem> _items = [];

  @override
  void initState() {
    _createItems();
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

  void _updateProtocols() {
    widget.protocols!.sort(
      (a, b) => a.timestamp.isBefore(b.timestamp) ? 1 : -1,
    );
    _createItems();
  }

  void _createItems() {
    if (widget.protocols != null) {
      setState(() {
        _items = widget.protocols!
            .map((e) => _ExpansionProtocolItem(protocol: e))
            .toList();
      });
    } else if (widget.contact != null) {
      widget.repository.getProtocols(widget.contact!).then((res) {
        switch (res) {
          case Ok<List<ContactProtocol>>():
            setState(() {
              _items = res.value
                  .map((e) => _ExpansionProtocolItem(protocol: e))
                  .toList();
            });
          case Error<List<ContactProtocol>>():
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Fehler beim Laden der Protokolle")),
              );
            }
        }
      });
    }
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
    ContactProtocol prot = item.protocol;
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
                  if (widget.showContact && prot.contact != null)
                    Row(
                      spacing: 2.0,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(child: Icon(prot.contact!.displayIcon)),
                        Expanded(
                          flex: 3,
                          child: Text(
                            prot.contact!.displayShort,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (widget.showOpp && prot.opportunity != null)
                    Row(
                      spacing: 2.0,
                      children: [
                        Expanded(child: Icon(prot.opportunity!.typeIcon)),
                        Expanded(
                          flex: 3,
                          child: Text(
                            prot.opportunity!.displayShort,
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
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => ProtocolDetails(
                          repository: context.read(),
                          protocol: prot,
                        ),
                      ),
                    );
                    setState(() {
                      widget.protocols!.sort(
                        (a, b) => a.timestamp.isBefore(b.timestamp) ? 1 : -1,
                      );
                      _createItems();
                    });
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () async {
                    var result = await widget.repository.delete(prot.id);
                    switch (result) {
                      case Ok<void>():
                        setState(() {
                          if (widget.protocols != null) {
                            widget.protocols!.remove(prot);
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
