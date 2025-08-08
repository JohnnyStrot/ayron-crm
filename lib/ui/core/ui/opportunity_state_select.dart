import 'dart:collection';

import 'package:ayron_crm/data/model/opportunity_state.dart';
import 'package:flutter/material.dart';

class OpportunityStateSelect extends StatefulWidget {
  const OpportunityStateSelect({
    super.key,
    required void Function(OpportunityState?) onSelected,
  }) : _onSelected = onSelected;

  final void Function(OpportunityState?) _onSelected;

  @override
  State<OpportunityStateSelect> createState() => _OpportunityStateSelectState();
}

typedef MenuEntry = DropdownMenuEntry<OpportunityState?>;

class _OpportunityStateSelectState extends State<OpportunityStateSelect> {
  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    OpportunityState.values
        .map<MenuEntry>(
          (OpportunityState state) =>
              MenuEntry(value: state, label: state.displayString),
        )
        .followedBy([MenuEntry(value: null, label: "")]),
  );
  OpportunityState? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<OpportunityState?>(
      label: Text("Status"),
      initialSelection: dropdownValue,
      width: 10000,
      inputDecorationTheme: InputDecorationTheme(
        suffixIconConstraints: BoxConstraints(maxHeight: 48, maxWidth: 48),
        border: OutlineInputBorder(),
      ),
      trailingIcon: dropdownValue == null
          ? null
          : IconButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  dropdownValue = null;
                  widget._onSelected(null);
                });
              },
              icon: Icon(Icons.clear),
            ),
      onSelected: (OpportunityState? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value;
          widget._onSelected(value);
        });
      },
      dropdownMenuEntries: menuEntries,
    );
  }
}
