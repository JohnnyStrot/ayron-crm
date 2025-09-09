import 'package:ayron_crm/ui/gig/upcoming_list.dart';
import 'package:ayron_crm/ui/song/repertoire_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 1, child: UpcomingList(repository: context.read())),
        Expanded(flex: 1, child: RepertoireList(repository: context.read())),
      ],
    );
  }
}
