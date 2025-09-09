import 'package:ayron_crm/data/model/event.dart';
import 'package:ayron_crm/ui/contact_protocol/protocol_list.dart';
import 'package:ayron_crm/ui/core/callable_change_notifier.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/opportunity_contact/opportunity_contact_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventContactPage extends StatelessWidget {
  EventContactPage({super.key, required this.event})
    : updateProtocols = CallableChangeNotifier();

  final Event event;
  final CallableChangeNotifier updateProtocols;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Dimens.vdivide),
          child: OpportunityContactList(
            opportunity: event,
            repository: context.read(),
            opcoRepository: context.read(),
            updateProtocols: updateProtocols,
          ),
        ),
        if (event.location != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Dimens.vdivide),
            child: OpportunityContactList(
              opportunity: event.location!,
              label: Text(
                "zur Location",
                style: TextTheme.of(context).headlineSmall!.copyWith(
                  fontSize: TextTheme.of(context).bodyLarge!.fontSize,
                ),
              ),
              repository: context.read(),
              opcoRepository: context.read(),
              updateProtocols: updateProtocols,
              protocolOpportunity: event,
            ),
          ),
        if (event.organisation != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Dimens.vdivide),
            child: OpportunityContactList(
              opportunity: event.organisation!,
              label: Text(
                "zur Organisation",
                style: TextTheme.of(context).headlineSmall!.copyWith(
                  fontSize: TextTheme.of(context).bodyLarge!.fontSize,
                ),
              ),
              repository: context.read(),
              opcoRepository: context.read(),
              updateProtocols: updateProtocols,
              protocolOpportunity: event,
            ),
          ),
        if (event.series != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Dimens.vdivide),
            child: OpportunityContactList(
              opportunity: event.series!,
              label: Text(
                "zur Veranstaltungsreihe",
                style: TextTheme.of(context).headlineSmall!.copyWith(
                  fontSize: TextTheme.of(context).bodyLarge!.fontSize,
                ),
              ),
              repository: context.read(),
              opcoRepository: context.read(),
              updateProtocols: updateProtocols,
              protocolOpportunity: event,
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
          protocols: event.protocols,
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
