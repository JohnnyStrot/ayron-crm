import 'package:ayron_crm/ui/auth/logout/logout_button.dart';
import 'package:ayron_crm/ui/auth/logout/logout_viewmodel.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../routing/routes.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.child});

  final Widget child;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const List<NavBarCategory> navbarCategories = [
    NavBarCategory(
      icon: Icon(Icons.dashboard_outlined),
      activeIcon: Icon(Icons.dashboard),
      label: 'Übersicht',
      location: Routes.overview,
      subItems: [
        NavBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
          location: Routes.dashboard,
        ),
        NavBarItem(
          icon: Icon(Icons.phishing_outlined),
          activeIcon: Icon(Icons.phishing),
          label: 'Aktive Gelegenheiten',
          location: Routes.activeOpportunities,
        ),
      ],
    ),
    NavBarCategory(
      icon: Icon(Icons.analytics_outlined),
      activeIcon: Icon(Icons.analytics),
      label: 'Analysis',
      location: Routes.analysis,
      subItems: [
        NavBarItem(
          icon: Icon(Icons.assignment_outlined),
          activeIcon: Icon(Icons.assignment),
          label: 'Alle Gelegenheiten',
          location: Routes.allOpportunities,
        ),
        NavBarItem(
          icon: Icon(Icons.pending_actions_outlined),
          activeIcon: Icon(Icons.pending_actions),
          label: 'Vergangene Gelegenheiten',
          location: Routes.pastOpportunities,
        ),
      ],
    ),
    NavBarCategory(
      icon: Icon(Icons.table_chart_outlined),
      activeIcon: Icon(Icons.table_chart),
      label: 'Data',
      location: Routes.data,
      subItems: [
        NavBarItem(
          icon: Icon(Icons.stadium_outlined),
          activeIcon: Icon(Icons.stadium),
          label: 'Gigs',
          location: Routes.gigs,
        ),
        NavBarItem(
          icon: Icon(Icons.festival),
          activeIcon: Icon(Icons.festival),
          label: 'Veranstaltungen',
          location: Routes.events,
        ),
        NavBarItem(
          icon: Icon(Icons.event_repeat_outlined),
          activeIcon: Icon(Icons.event_repeat),
          label: 'Veranstaltungsreihen',
          location: Routes.series,
        ),
        NavBarItem(
          icon: Icon(Icons.piano_outlined),
          activeIcon: Icon(Icons.piano),
          label: 'Bands',
          location: Routes.bands,
        ),
        NavBarItem(
          icon: Icon(Icons.location_on_outlined),
          activeIcon: Icon(Icons.location_on),
          label: 'Locations',
          location: Routes.locations,
        ),
        NavBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Kontakte',
          location: Routes.contacts,
        ),
        NavBarItem(
          icon: Icon(Icons.groups_outlined),
          activeIcon: Icon(Icons.groups),
          label: 'Organisationen',
          location: Routes.organisations,
        ),
        NavBarItem(
          icon: Icon(Icons.music_note_outlined),
          activeIcon: Icon(Icons.music_note),
          label: 'Songs',
          location: Routes.songs,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 900;

    return Row(
      children: [
        if (!displayMobileLayout)
          const AppDrawer(navbarCategories: navbarCategories, mobile: false),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: displayMobileLayout
                  ? Text(
                      "Ayron-CRM",
                      style: TextTheme.of(context).headlineSmall!.copyWith(
                        color: ColorScheme.of(context).onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : null,
              actions: [
                LogoutButton(
                  viewModel: LogoutViewModel(authRepository: context.read()),
                ),
              ],
              backgroundColor: ColorScheme.of(context).primaryContainer,
              actionsPadding: EdgeInsets.only(right: 10),
              leading: displayMobileLayout
                  ? DrawerButton(color: ColorScheme.of(context).onPrimary)
                  : null,
            ),
            body: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: widget.child,
                ),
              ),
            ),
            drawer: displayMobileLayout
                ? AppDrawer(navbarCategories: navbarCategories, mobile: true)
                : null,
          ),
        ),
      ],
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.navbarCategories,
    required this.mobile,
  });

  final List<NavBarCategory> navbarCategories;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: Border(),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: ColorScheme.of(context).primary,
              image: DecorationImage(
                image: NetworkImage(
                  "https://ayronband.de/images/home-dark.jpeg",
                ),
              ),
            ),
            child: Text(
              "Ayron-CRM",
              style: TextTheme.of(context).displayMedium!.copyWith(
                color: ColorScheme.of(context).onPrimary,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          for (var cat in navbarCategories)
            Column(children: [cat.tile(context, mobile), Divider()]),
        ],
      ),
    );
  }
}

class NavBarCategory extends NavBarItem {
  final List<NavBarItem> subItems;

  const NavBarCategory({
    required this.subItems,
    required super.location,
    required super.icon,
    required super.label,
    super.activeIcon,
  });

  @override
  Widget tile(BuildContext context, bool mobile) {
    final matched = GoRouter.of(
      context,
    ).state.matchedLocation.startsWith(location);
    return ExpansionTile(
      shape: Border(),
      title: Text(
        label,
        style: TextStyle(fontWeight: matched ? FontWeight.bold : null),
      ),
      leading: matched ? activeIcon : icon,
      children: [
        for (var nav in subItems)
          Padding(
            padding: const EdgeInsets.only(left: Dimens.vgap),
            child: nav.tile(context, mobile),
          ),
      ],
    );
  }
}

class NavBarItem {
  final String location;
  final String label;
  final Widget icon;
  final Widget activeIcon;

  const NavBarItem({
    required this.location,
    required this.icon,
    required this.label,
    Widget? activeIcon,
  }) : activeIcon = activeIcon ?? icon;

  Widget tile(BuildContext context, bool mobile) {
    final matched = GoRouter.of(
      context,
    ).state.matchedLocation.startsWith(location);
    return ListTile(
      title: Text(
        label,
        style: TextStyle(fontWeight: matched ? FontWeight.bold : null),
      ),
      leading: matched ? activeIcon : icon,
      onTap: () {
        if (mobile) {
          context.pop();
        }
        context.go(location);
      },
    );
  }
}
