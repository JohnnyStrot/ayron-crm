import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:flutter/material.dart';

class OpportunitySocialMedia extends StatelessWidget {
  const OpportunitySocialMedia({super.key, required this.opportunity});

  final Opportunity opportunity;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.vgap,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Social Media", style: TextTheme.of(context).headlineSmall),
        Row(
          spacing: Dimens.hgap,
          children: [
            Expanded(
              flex: 1,
              child: TextFormField(
                validator: (value) => value == null || (value.length <= 256)
                    ? null
                    : "Max. 256 Zeichen",
                controller: TextEditingController(text: opportunity.instagram),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Instagram"),
                ),
                onChanged: (value) {
                  opportunity.instagram = value;
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                validator: (value) => value == null || (value.length <= 256)
                    ? null
                    : "Max. 256 Zeichen",
                controller: TextEditingController(text: opportunity.facebook),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Facebook"),
                ),
                onChanged: (value) {
                  opportunity.facebook = value;
                },
              ),
            ),
          ],
        ),
        Row(
          spacing: Dimens.hgap,
          children: [
            Expanded(
              flex: 1,
              child: TextFormField(
                validator: (value) => value == null || (value.length <= 256)
                    ? null
                    : "Max. 256 Zeichen",
                controller: TextEditingController(text: opportunity.reddit),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Reddit"),
                ),
                onChanged: (value) {
                  opportunity.reddit = value;
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                validator: (value) => value == null || (value.length <= 256)
                    ? null
                    : "Max. 256 Zeichen",
                controller: TextEditingController(text: opportunity.xtwitter),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("X / Twitter"),
                ),
                onChanged: (value) {
                  opportunity.xtwitter = value;
                },
              ),
            ),
          ],
        ),
        Row(
          spacing: Dimens.hgap,
          children: [
            Expanded(
              flex: 1,
              child: TextFormField(
                validator: (value) => value == null || (value.length <= 512)
                    ? null
                    : "Max. 512 Zeichen",
                controller: TextEditingController(text: opportunity.web),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Web"),
                ),
                onChanged: (value) {
                  opportunity.web = value;
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                validator: (value) => value == null || (value.length <= 256)
                    ? null
                    : "Max. 256 Zeichen",
                controller: TextEditingController(text: opportunity.youtube),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("YouTube"),
                ),
                onChanged: (value) {
                  opportunity.youtube = value;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
