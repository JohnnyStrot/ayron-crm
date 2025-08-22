import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:flutter/material.dart';

class OpportunityNameField extends StatelessWidget {
  const OpportunityNameField({super.key, required this.opportunity});

  final Opportunity opportunity;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) =>
          value == null || (value.length <= 142) ? null : "Max. 142 Zeichen",
      decoration: InputDecoration(
        filled: true,
        label: Text("Name"),
        border: UnderlineInputBorder(),
      ),
      controller: TextEditingController(text: opportunity.name),
      onChanged: (value) => opportunity.name = value,
    );
  }
}
