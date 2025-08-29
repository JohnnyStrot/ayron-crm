import 'package:ayron_crm/data/model/contact_protocol.dart';
import 'package:flutter/material.dart';

class ProtocolList extends StatelessWidget {
  const ProtocolList({super.key, required this.protocols});

  final List<ContactProtocol> protocols;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList.radio(children: protocols.map(toPanel).toList());
  }

  ExpansionPanelRadio toPanel(ContactProtocol prot) {
    return ExpansionPanelRadio(
      value: "",
      headerBuilder: (context, isExpanded) =>
          Row(children: [Text(prot.contact?.displayShort ?? "")]),
      body: Column(children: [Text(prot.content)]),
    );
  }
}
