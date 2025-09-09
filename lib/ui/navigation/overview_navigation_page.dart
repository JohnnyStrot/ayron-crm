import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/navigation_page_card.dart';
import 'package:flutter/material.dart';

class OverviewNavigationPage extends StatelessWidget {
  const OverviewNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(Dimens.hgap),
      childAspectRatio: 2,
      crossAxisSpacing: Dimens.hgap,
      mainAxisSpacing: Dimens.vgap,
      crossAxisCount: 2,
      children: [
        NavigationPageCard(
          route: Routes.dashboard,
          label: "Dashboard",
          icon: Icons.dashboard,
        ),
        NavigationPageCard(
          route: Routes.activeOpportunities,
          label: "Aktive Gelegenheiten",
          icon: Icons.phishing,
        ),
      ],
    );
  }
}
