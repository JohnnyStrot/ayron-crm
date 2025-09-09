import 'package:ayron_crm/data/model/opportunity.dart';
import 'package:ayron_crm/ui/contact_protocol/protocol_list.dart';
import 'package:ayron_crm/ui/core/callable_change_notifier.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/opportunity_contact/opportunity_contact_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OpportunityContactPage extends StatelessWidget {
  OpportunityContactPage({super.key, required this.opportunity})
    : updateProtocols = CallableChangeNotifier();

  final Opportunity opportunity;
  final CallableChangeNotifier updateProtocols;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Dimens.vdivide),
          child: OpportunityContactList(
            opportunity: opportunity,
            repository: context.read(),
            opcoRepository: context.read(),
            updateProtocols: updateProtocols,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: Dimens.paddingHorizontal,
            right: Dimens.paddingHorizontal,
            bottom: Dimens.vgap,
          ),
          child: Text("Protokoll", style: TextTheme.of(context).headlineSmall),
        ),
        ProtocolList(
          protocols: opportunity.protocols,
          repository: context.read(),
          showContact: true,
          showOpp: false,
          updateProtocols: updateProtocols,
        ),
        SizedBox(height: Dimens.fabGap),
      ],
    );
  }
}
