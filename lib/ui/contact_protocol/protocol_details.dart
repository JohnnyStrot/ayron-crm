import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/model/contact_protocol.dart';
import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/to_one.dart';
import 'package:ayron_crm/data/repositories/contact_protocol/contact_protocol_repository.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/datepicker.dart';
import 'package:ayron_crm/ui/core/ui/timeofdaypicker.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';

class ProtocolDetails extends StatefulWidget {
  const ProtocolDetails({
    super.key,
    required this.repository,
    this.protocol,
    this.contact,
    this.opportunity,
  });

  final ContactProtocolRepository repository;
  final ContactProtocol? protocol;
  final Contact? contact;
  final Opportunity? opportunity;

  @override
  State<ProtocolDetails> createState() => _ProtocolDetailsState();
}

class _ProtocolDetailsState extends State<ProtocolDetails> {
  ContactProtocol? _protocol;

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
                  _protocol = ContactProtocol(
                    id: res.value,
                    timestamp: DateTime.now(),
                    opportunity: ToOne(entity: widget.opportunity),
                    contact: ToOne(entity: widget.contact),
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
                    (_protocol!.contact?.displayShort) ??
                    "#${_protocol?.id ?? ""}",
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
            spacing: Dimens.vgap,
            children: [
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
                          return Icon(ContactProtocol.getIcon(tec.text));
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
                      children: [
                        Icon(ContactProtocol.getIcon(value)),
                        Text(value),
                      ],
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
