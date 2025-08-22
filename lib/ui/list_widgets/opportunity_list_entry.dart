import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class OpportunityListEntry<T extends Opportunity>
    extends StatelessWidget {
  const OpportunityListEntry({
    super.key,
    required this.opportunity,
    required this.onDelete,
  });

  final T opportunity;

  final void Function(T loc) onDelete;

  String get route;

  String opportunityToString(T opp) => opp.name;

  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          opportunityToString(opportunity),
          overflow: TextOverflow.ellipsis,
          style: TextTheme.of(context).displaySmall!.copyWith(
            fontSize: TextTheme.of(context).bodyLarge!.fontSize,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final action = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            context.push("$route/${opportunity.id}");
          },
          icon: Icon(Icons.edit),
        ),
        IconButton(
          onPressed: () {
            onDelete(opportunity);
          },
          icon: Icon(Icons.delete),
        ),
      ],
    );
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.fromLTRB(
          bottom: BorderSide(
            color: ColorScheme.of(context).primary.withAlpha(60),
            style: BorderStyle.solid,
          ),
          left: BorderSide(
            color: opportunity.state.color,
            style: BorderStyle.solid,
            width: 5.0,
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: 10, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: buildContent(context)),
          action,
        ],
      ),
    );
  }
}
