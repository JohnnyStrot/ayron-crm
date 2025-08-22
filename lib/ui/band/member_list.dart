import 'package:ayron_crm/data/model/band.dart';
import 'package:ayron_crm/data/model/band_member.dart';
import 'package:ayron_crm/data/model/to_one.dart';
import 'package:ayron_crm/ui/contact/contact_select.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemberList extends StatefulWidget {
  const MemberList({super.key, required Band band}) : _band = band;

  final Band _band;

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberExpansion {
  _MemberExpansion({required this.member}) : isExpanded = false;

  BandMember member;
  bool isExpanded;
}

class _MemberListState extends State<MemberList> {
  _MemberListState() : _elements = List.empty();

  List<_MemberExpansion> _elements;

  @override
  void initState() {
    super.initState();
    _createElements();
  }

  void _createElements() {
    _elements = widget._band.members
        .map((l) => _MemberExpansion(member: l))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Mitglieder", style: TextTheme.of(context).headlineSmall),
            IconButton.filled(
              onPressed: () {
                setState(() {
                  BandMember l = BandMember(band: ToOne(), member: ToOne());
                  widget._band.members.add(l);
                  _elements.add(_MemberExpansion(member: l));
                });
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: ExpansionPanelList(
            materialGapSize: Dimens.vgap,
            children: _elements.map((l) => buildPanel(context, l)).toList(),
            expansionCallback: (panelIndex, isExpanded) => setState(() {
              _elements[panelIndex].isExpanded = isExpanded;
            }),
          ),
        ),
      ],
    );
  }

  ExpansionPanel buildPanel(BuildContext context, _MemberExpansion exp) {
    return ExpansionPanel(
      isExpanded: exp.isExpanded,
      headerBuilder: (context, isExpanded) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimens.vgap,
            horizontal: Dimens.paddingHorizontal,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: Dimens.paddingHorizontal,
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  spacing: Dimens.hgap,
                  children: [
                    Text(
                      exp.member.member?.displayShort ?? "",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      exp.member.instrument,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () => setState(() {
                    widget._band.members.remove(exp.member);
                    _elements.removeWhere(
                      (element) => element.member == exp.member,
                    );
                  }),
                  icon: Icon(Icons.delete),
                ),
              ),
            ],
          ),
        );
      },
      body: buildEntryBody(context, exp.member),
    );
  }

  Widget buildEntryBody(BuildContext context, BandMember entity) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Dimens.paddingVertical,
        left: Dimens.paddingHorizontal,
        right: Dimens.paddingHorizontal,
      ),
      child: Column(
        spacing: Dimens.vgap,
        children: [
          Row(
            spacing: Dimens.hgap,
            children: [
              Expanded(
                child: ContactSelect(
                  repository: context.read(),
                  onSelect: (l) => setState(() {
                    entity.member = l;
                  }),
                  initialValue: entity.member,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: TextEditingController(text: entity.instrument),
                  onChanged: (value) => entity.instrument = value,
                  decoration: InputDecoration(label: Text("Instrument")),
                  validator: (value) => value == null || (value.length <= 128)
                      ? null
                      : "Max. 128 Zeichen",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
