import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/data/model/lineup.dart';
import 'package:ayron_crm/data/model/to_one.dart';
import 'package:ayron_crm/ui/band/band_picker.dart';
import 'package:ayron_crm/ui/band/band_select.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/timeofdaypicker.dart';
import 'package:ayron_crm/utils/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LineupList extends StatefulWidget {
  const LineupList({super.key, required Event event}) : _event = event;

  final Event _event;

  @override
  State<LineupList> createState() => _LineupListState();
}

class _LineupExpansion {
  _LineupExpansion({required this.lineup}) : isExpanded = false;

  Lineup lineup;
  bool isExpanded;
}

class _LineupListState extends State<LineupList> {
  _LineupListState() : _elements = List.empty();

  List<_LineupExpansion> _elements;

  @override
  void initState() {
    super.initState();
    _createElements();
  }

  void _createElements() {
    _elements = widget._event.lineup
        .map((l) => _LineupExpansion(lineup: l))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Lineup", style: TextTheme.of(context).headlineSmall),
            IconButton.filled(
              onPressed: () {
                setState(() {
                  Lineup l = Lineup(band: ToOne(), event: ToOne());
                  widget._event.lineup.add(l);
                  _elements.add(_LineupExpansion(lineup: l));
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

  ExpansionPanel buildPanel(BuildContext context, _LineupExpansion exp) {
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
                /* child: BandSelect(
                  repository: context.read(),
                  initialValue: exp.lineup.band,
                  onSelect: (l) => exp.lineup.band = l,
                ),*/
                child: Row(
                  children: [
                    Expanded(child: Text(exp.lineup.stagetime?.toJson() ?? "")),
                    Expanded(flex: 4, child: Text(exp.lineup.band?.name ?? "")),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () => setState(() {
                    widget._event.lineup.remove(exp.lineup);
                    _elements.removeWhere(
                      (element) => element.lineup == exp.lineup,
                    );
                  }),
                  icon: Icon(Icons.delete),
                ),
              ),
            ],
          ),
        );
      },
      body: buildEntryBody(context, exp.lineup),
    );
  }

  Widget buildEntryBody(BuildContext context, Lineup entity) {
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
                child: BandPicker(
                  repository: context.read(),
                  onSelect: (l) => setState(() {
                    entity.band = l;
                  }),
                  initialValue: entity.band,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: TextEditingController(text: entity.stage),
                  onChanged: (value) => entity.stage = value,
                  decoration: InputDecoration(label: Text("Stage")),
                  validator: (value) => value == null || (value.length <= 32)
                      ? null
                      : "Max. 32 Zeichen",
                ),
              ),
            ],
          ),
          Row(
            spacing: Dimens.hgap,
            children: [
              Expanded(
                child: TimeOfDayPicker(
                  onTimeOfDay: (time) => entity.soundcheckTime = time,
                  label: "Soundcheck",
                  initialValue: entity.soundcheckTime,
                ),
              ),
              Expanded(
                child: TimeOfDayPicker(
                  onTimeOfDay: (time) => entity.stagetime = time,
                  label: "Stagetime",
                  initialValue: entity.stagetime,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
