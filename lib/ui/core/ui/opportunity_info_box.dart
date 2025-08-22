import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:flutter/material.dart';

class OpportunityInfoBox extends StatelessWidget {
  const OpportunityInfoBox({super.key, required this.opportunity});

  final Opportunity opportunity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Dimens.vgap,
      children: [
        Text("Info", style: TextTheme.of(context).headlineSmall),
        TextFormField(
          minLines: 5,
          maxLines: 8,
          controller: TextEditingController(text: opportunity.info),
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            label: Text("Info"),
            alignLabelWithHint: true,
          ),
          onChanged: (value) {
            opportunity.info = value;
          },
        ),
      ],
    );
  }
}
