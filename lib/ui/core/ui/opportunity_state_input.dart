import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/data/model/opportunity_state.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/opportunity_state_select.dart';
import 'package:flutter/material.dart';

class OpportunityStateInput extends StatelessWidget {
  const OpportunityStateInput({super.key, required this.opportunity});

  final Opportunity opportunity;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.vgap,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Status", style: TextTheme.of(context).headlineSmall),
        OpportunityStateSelect(
          initialValue: opportunity.state,
          onSelected: (value) {
            opportunity.state = value ?? OpportunityState.none;
          },
        ),
        TextFormField(
          minLines: 3,
          maxLines: 6,
          controller: TextEditingController(text: opportunity.stateText),
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            label: Text("Status-Text"),
            alignLabelWithHint: true,
          ),
          onChanged: (value) {
            opportunity.stateText = value;
          },
        ),
      ],
    );
  }
}
