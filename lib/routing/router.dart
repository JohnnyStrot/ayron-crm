import 'package:ayron_crm/data/repositories/auth/auth_repository.dart';
import 'package:ayron_crm/ui/auth/login/login_viewmodel.dart';
import 'package:ayron_crm/ui/location/location_list.dart';
import 'package:ayron_crm/ui/location/location_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ui/auth/login/login_screen.dart';
import '../ui/home/home_screen.dart';
import '../ui/home/home_viewmodel.dart';
import '../ui/navigation/main_screen.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter router(AuthRepository authRepository) => GoRouter(
  refreshListenable: authRepository,
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.home,
  debugLogDiagnostics: true,
  redirect: _redirect,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(child: MainScreen(child: child));
      },
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            final viewModel = HomeViewModel();
            return HomeScreen(viewModel: viewModel);
          },
        ),
        GoRoute(
          path: Routes.overview,
          builder: (context, state) {
            final viewModel = LocationListViewmodel(
              locationRepository: context.read(),
            );
            return LocationList(viewmodel: viewModel);
          },
        ),
        GoRoute(
          path: Routes.analysis,
          builder: (context, state) {
            final viewModel = HomeViewModel();
            return HomeScreen(viewModel: viewModel);
          },
        ),
        GoRoute(
          path: Routes.data,
          builder: (context, state) {
            final viewModel = HomeViewModel();
            return HomeScreen(viewModel: viewModel);
          },
        ),
      ],
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return LoginScreen(
          viewModel: LoginViewModel(authRepository: context.read()),
        );
      },
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  final loggedIn = await context.read<AuthRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == Routes.login;
  if (!loggedIn) {
    return Routes.login;
  }

  // if the user is logged in but still on the login page, send them to
  // the home page
  if (loggingIn) {
    return Routes.home;
  }

  // no need to redirect at all
  return null;
}
