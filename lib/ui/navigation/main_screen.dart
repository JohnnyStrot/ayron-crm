import 'package:ayron_crm/ui/auth/logout/logout_button.dart';
import 'package:ayron_crm/ui/auth/logout/logout_viewmodel.dart';
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
  static const List<NavBarItem> tabs = [
    NavBarItem(
      icon: Icon(Icons.dashboard_outlined),
      activeIcon: Icon(Icons.dashboard),
      label: 'Overview',
      initialLocation: Routes.overview,
    ),
    NavBarItem(
      icon: Icon(Icons.analytics_outlined),
      activeIcon: Icon(Icons.analytics),
      label: 'Analysis',
      initialLocation: Routes.analysis,
    ),
    NavBarItem(
      icon: Icon(Icons.table_chart_outlined),
      activeIcon: Icon(Icons.table_chart),
      label: 'Data',
      initialLocation: Routes.data,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final String loc = GoRouterState.of(context).matchedLocation;
    const labelStyle = TextStyle(fontFamily: 'Roboto');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ayron-CRM",
          style: TextTheme.of(context).headlineSmall!.copyWith(
            color: ColorScheme.of(context).onPrimaryContainer,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          LogoutButton(
            viewModel: LogoutViewModel(authRepository: context.read()),
          ),
        ],
        backgroundColor: ColorScheme.of(context).primaryContainer,
        actionsPadding: EdgeInsets.only(right: 10),
      ),
      body: SafeArea(child: widget.child),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: labelStyle,
        unselectedLabelStyle: labelStyle,
        selectedItemColor: const Color(0xFF434343),
        selectedFontSize: 12,
        unselectedItemColor: const Color(0xFF838383),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          _goOtherTab(context, index);
        },
        currentIndex: loc.startsWith(Routes.overview)
            ? 0
            : loc.startsWith(Routes.analysis)
            ? 1
            : loc.startsWith(Routes.data)
            ? 2
            : 0,
        items: tabs,
      ),
    );
  }

  void _goOtherTab(BuildContext context, int index) {
    String location = tabs[index].initialLocation;
    setState(() {});
    if (index == tabs.length) {
      context.go("/");
    } else {
      context.go(location);
    }
  }
}

class NavBarItem extends BottomNavigationBarItem {
  final String initialLocation;

  const NavBarItem({
    required this.initialLocation,
    required super.icon,
    super.label,
    Widget? activeIcon,
  }) : super(activeIcon: activeIcon ?? icon);
}
