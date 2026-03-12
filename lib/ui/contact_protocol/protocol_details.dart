import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/protocol.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/to_many.dart';
import 'package:ayron_crm/data/model/to_one.dart';
import 'package:ayron_crm/data/repositories/contact_protocol/contact_protocol_repository.dart';
import 'package:ayron_crm/ui/contact/contact_pick_button.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/datepicker.dart';
import 'package:ayron_crm/ui/core/ui/timeofdaypicker.dart';
import 'package:ayron_crm/ui/opportunity/opportunity_pick_button.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProtocolDetails extends StatefulWidget {
  const ProtocolDetails({
    super.key,
    required this.repository,
    this.protocol,
    this.contact,
    this.opportunity,
  });

  final ContactProtocolRepository repository;
  final Protocol? protocol;
  final Contact? contact;
  final Opportunity? opportunity;

  @override
  State<ProtocolDetails> createState() => _ProtocolDetailsState();
}

class _ProtocolDetailsState extends State<ProtocolDetails> {
  Protocol? _protocol;

  @override
  void initState() {
    if (widget.protocol != null) {
      _protocol = widget.protocol;
    } else {
      widget.repository
          .create(contact: widget.contact, opportunity: widget.opportunity)
          .then((res) {
            switch (res) {
              case Ok<int>():
                setState(() {
                  _protocol = Protocol(
                    id: res.value,
                    timestamp: DateTime.now(),
                    opportunities: ToMany(
                      entities: widget.opportunity == null
                          ? []
                          : [widget.opportunity!],
                    ),
                    contacts: ToMany(
                      entities: widget.contact == null ? [] : [widget.contact!],
                    ),
                  );
                  if (widget.opportunity != null) {
                    widget.opportunity!.protocols.add(_protocol!);
                  }
                  if (widget.contact != null) {
                    widget.contact!.contactProtocols.add(_protocol!);
                  }
                });
              case Error<int>():
                setState(() {
                  if (mounted && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Fehler beim Erstellen")),
                    );
                  }
                });
            }
          });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_protocol == null) {
      return Center(child: CircularProgressIndicator());
    }

    var tec = TextEditingController(text: _protocol!.type);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => submit(context),
        child: Icon(Icons.save),
      ),
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Protokoll ",
                style: TextStyle(fontWeight: FontWeight.w200),
              ),
              TextSpan(
                text:
                    "#${_protocol?.id ?? ""} ${_protocol!.contacts != null && _protocol!.contacts!.isNotEmpty ? ("${_protocol!.contacts!.first.displayShort}${_protocol!.contacts!.length > 1 ? "+${_protocol!.contacts!.length - 1}" : ""}") : ""}",
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
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: Dimens.paddingVertical,
          horizontal: Dimens.paddingHorizontal,
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Dimens.vgap,
            children: [
              Text("Gelegenheiten"),
              Row(
                children: [
                  OpportunityPickButton(
                    repository: context.read(),
                    onSelect: (op) {
                      if (_protocol != null && op != null) {
                        setState(() {
                          _protocol?.opportunities?.add(op);
                        });
                      }
                    },
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (Opportunity op in _protocol?.opportunities ?? [])
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: InputChip(
                                label: Text(op.name),
                                avatar: Icon(op.typeIcon),
                                deleteIcon: Icon(Icons.delete),
                                onDeleted: () => setState(
                                  () => _protocol?.opportunities!.remove(op),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Text("Kontakte"),
              Row(
                children: [
                  ContactPickButton(
                    repository: context.read(),
                    onSelect: (c) {
                      if (_protocol != null && c != null) {
                        setState(() {
                          _protocol?.contacts?.add(c);
                        });
                      }
                    },
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (Contact c in _protocol?.contacts ?? [])
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: InputChip(
                                label: Text(c.displayShort),
                                avatar: Icon(c.displayIcon),
                                deleteIcon: Icon(Icons.delete),
                                onDeleted: () => setState(
                                  () => _protocol?.contacts!.remove(c),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: Dimens.hgap,
                children: [
                  Expanded(
                    child: Datepicker(
                      onDate: (date) {
                        if (date != null) {
                          _protocol!.timestamp = date.copyWith(
                            hour: _protocol!.timestamp.hour,
                            minute: _protocol!.timestamp.minute,
                            second: 0,
                            microsecond: 0,
                            millisecond: 0,
                          );
                        }
                      },
                      initialValue: _protocol!.timestamp,
                      label: "Datum",
                      nullable: false,
                    ),
                  ),
                  Expanded(
                    child: TimeOfDayPicker(
                      onTimeOfDay: (time) {
                        if (time != null) {
                          _protocol!.timestamp = _protocol!.timestamp.copyWith(
                            hour: time.hour,
                            minute: time.minute,
                            second: 0,
                            microsecond: 0,
                            millisecond: 0,
                          );
                        }
                      },
                      label: "Uhrzeit",
                      nullable: false,
                      initialValue: TimeOfDay.fromDateTime(
                        _protocol!.timestamp,
                      ),
                    ),
                  ),
                ],
              ),
              TypeAheadField<String>(
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: tec,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      prefixIcon: ListenableBuilder(
                        listenable: tec,
                        builder: (context, child) {
                          return Icon(Protocol.getIcon(tec.text));
                        },
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Typ',
                    ),
                    onSubmitted: (value) {
                      _protocol!.type = value;
                    },
                  );
                },
                itemBuilder: (context, value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimens.vgap,
                      horizontal: Dimens.hgap,
                    ),
                    child: Row(
                      spacing: Dimens.hgap,
                      children: [Icon(Protocol.getIcon(value)), Text(value)],
                    ),
                  );
                },
                onSelected: (value) {
                  setState(() {
                    _protocol!.type = value;
                  });
                  tec.text = value;
                },
                suggestionsCallback: (search) => Future.value([
                  "E-Mail",
                  "Gespräch",
                  "Telefon",
                  "Textnachricht",
                  "Schriftlich",
                ]),
              ),
              TextField(
                minLines: 8,
                maxLines: 8,
                controller: TextEditingController(text: _protocol!.content),
                decoration: InputDecoration(label: Text("Inhalt")),
                onChanged: (value) => _protocol!.content = value,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void submit(BuildContext context) async {
    if (_protocol == null) return;
    var res = await widget.repository.save(_protocol!);
    if (mounted && context.mounted) {
      switch (res) {
        case Ok<int>():
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Protokoll gespeichert")));
        case Error<int>():
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Fehler beim Speichern")));
      }
    }
  }
}
