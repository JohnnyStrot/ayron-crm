import 'package:ayron_crm/data/repositories/auth/auth_repository.dart';
import 'package:ayron_crm/ui/auth/login/login_viewmodel.dart';
import 'package:ayron_crm/ui/location/location_details.dart';
import 'package:ayron_crm/ui/location/location_details_viewmodel.dart';
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
  initialLocation: Routes.overview,
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
            final viewModel = LocationListViewmodel(
              locationRepository: context.read(),
            );
            return LocationList(viewmodel: viewModel);
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
          routes: [
            GoRoute(
              path: Routes.locationsRelative,
              builder: (context, state) {
                final viewModel = LocationListViewmodel(
                  locationRepository: context.read(),
                );
                return LocationList(viewmodel: viewModel);
              },
              routes: [
                GoRoute(
                  path: Routes.createRelative,
                  builder: (context, state) {
                    LocationDetailsViewmodel vm = LocationDetailsViewmodel(
                      locationRepository: context.read(),
                    );
                    vm.createLocation.execute();
                    return LocationDetails(viewmodel: vm);
                  },
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = int.parse(state.pathParameters['id']!);
                    final vm = LocationDetailsViewmodel(
                      locationRepository: context.read(),
                    );

                    vm.loadLocation.execute(id);

                    return LocationDetails(viewmodel: vm);
                  },
                ),
              ],
            ),
          ],
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
