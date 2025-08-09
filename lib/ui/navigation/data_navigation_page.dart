import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/navigation_page_card.dart';
import 'package:flutter/material.dart';

class DataNavigationPage extends StatelessWidget {
  const DataNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(Dimens.hgap),
      crossAxisSpacing: Dimens.hgap,
      mainAxisSpacing: Dimens.vgap,
      crossAxisCount: 2,
      children: [
        NavigationPageCard(
          route: Routes.gigs,
          label: "Gigs",
          icon: Icons.stadium,
        ),
        NavigationPageCard(
          route: Routes.events,
          label: "Veranstaltungen",
          icon: Icons.festival,
        ),
        NavigationPageCard(
          route: Routes.events,
          label: "Veranstaltungsreihen",
          icon: Icons.event_repeat,
        ),
        NavigationPageCard(
          route: Routes.bands,
          label: "Bands",
          icon: Icons.piano,
        ),
        NavigationPageCard(
          route: Routes.locations,
          label: "Locations",
          icon: Icons.location_on,
        ),
        NavigationPageCard(
          route: Routes.contacts,
          label: "Kontakte",
          icon: Icons.person,
        ),
        NavigationPageCard(
          route: Routes.organisations,
          label: "Organisationen",
          icon: Icons.groups,
        ),
        NavigationPageCard(
          route: Routes.songs,
          label: "Songs",
          icon: Icons.music_note,
        ),
      ],
    );
  }
}
