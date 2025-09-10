import 'package:ayron_crm/data/repositories/auth/auth_repository.dart';
import 'package:ayron_crm/ui/auth/login/login_viewmodel.dart';
import 'package:ayron_crm/ui/band/band_details.dart';
import 'package:ayron_crm/ui/band/band_details_viewmodel.dart';
import 'package:ayron_crm/ui/band/band_list.dart';
import 'package:ayron_crm/ui/band/band_list_viewmodel.dart';
import 'package:ayron_crm/ui/contact/contact_details.dart';
import 'package:ayron_crm/ui/contact/contact_details_viewmodel.dart';
import 'package:ayron_crm/ui/contact/contact_list.dart';
import 'package:ayron_crm/ui/contact/contact_list_viewmodel.dart';
import 'package:ayron_crm/ui/dashboard/dashboard.dart';
import 'package:ayron_crm/ui/event/event_details.dart';
import 'package:ayron_crm/ui/event/event_details_viewmodel.dart';
import 'package:ayron_crm/ui/event/event_list.dart';
import 'package:ayron_crm/ui/event/event_list_viewmodel.dart';
import 'package:ayron_crm/ui/gig/gig_details.dart';
import 'package:ayron_crm/ui/gig/gig_details_viewmodel.dart';
import 'package:ayron_crm/ui/gig/gig_list.dart';
import 'package:ayron_crm/ui/gig/gig_list_viewmodel.dart';
import 'package:ayron_crm/ui/navigation/analysis_navigation_page.dart';
import 'package:ayron_crm/ui/navigation/data_navigation_page.dart';
import 'package:ayron_crm/ui/location/location_details.dart';
import 'package:ayron_crm/ui/location/location_details_viewmodel.dart';
import 'package:ayron_crm/ui/location/location_list.dart';
import 'package:ayron_crm/ui/location/location_list_viewmodel.dart';
import 'package:ayron_crm/ui/navigation/overview_navigation_page.dart';
import 'package:ayron_crm/ui/opportunity/opportunity_list.dart';
import 'package:ayron_crm/ui/opportunity/opportunity_list_viewmodel.dart';
import 'package:ayron_crm/ui/organisation/organisation_details.dart';
import 'package:ayron_crm/ui/organisation/organisation_details_viewmodel.dart';
import 'package:ayron_crm/ui/organisation/organisation_list.dart';
import 'package:ayron_crm/ui/organisation/organisation_list_viewmodel.dart';
import 'package:ayron_crm/ui/series/series_details.dart';
import 'package:ayron_crm/ui/series/series_details_viewmodel.dart';
import 'package:ayron_crm/ui/series/series_list.dart';
import 'package:ayron_crm/ui/series/series_list_viewmodel.dart';
import 'package:ayron_crm/ui/song/song_details.dart';
import 'package:ayron_crm/ui/song/song_details_viewmodel.dart';
import 'package:ayron_crm/ui/song/song_list.dart';
import 'package:ayron_crm/ui/song/song_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ui/auth/login/login_screen.dart';
import '../ui/navigation/main_screen.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final overviewRoutes = [
  GoRoute(
    path: Routes.dashboardRelative,
    builder: (context, state) => Dashboard(),
  ),
  GoRoute(
    path: Routes.activeOpportunitiesRelative,
    builder: (context, state) {
      final viewModel = OpportunityListViewmodel(
        opportunityRepository: context.read(),
        active: true,
      );
      return OpportunityList(viewmodel: viewModel);
    },
  ),
];
final analysisRoutes = [
  GoRoute(
    path: Routes.allOpportunitiesRelative,
    builder: (context, state) {
      final viewModel = OpportunityListViewmodel(
        opportunityRepository: context.read(),
      );
      return OpportunityList(viewmodel: viewModel);
    },
  ),
  GoRoute(
    path: Routes.pastOpportunitiesRelative,
    builder: (context, state) {
      final viewModel = OpportunityListViewmodel(
        opportunityRepository: context.read(),
        past: true,
      );
      return OpportunityList(viewmodel: viewModel);
    },
  ),
];

final dataRoutes = [
  GoRoute(
    path: Routes.bandsRelative,
    builder: (context, state) {
      final viewModel = BandListViewmodel(bandRepository: context.read());
      return BandListView(viewmodel: viewModel);
    },
    routes: [
      GoRoute(
        path: Routes.createRelative,
        builder: (context, state) {
          BandDetailsViewmodel vm = BandDetailsViewmodel(
            bandRepository: context.read(),
          );
          vm.createEntity.execute();
          return BandDetails(viewmodel: vm);
        },
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final vm = BandDetailsViewmodel(bandRepository: context.read());

          vm.loadEntity.execute(id);

          return BandDetails(viewmodel: vm);
        },
      ),
    ],
  ),
  GoRoute(
    path: Routes.contactsRelative,
    builder: (context, state) {
      final viewModel = ContactListViewmodel(contactRepository: context.read());
      return ContactListView(viewmodel: viewModel);
    },
    routes: [
      GoRoute(
        path: Routes.createRelative,
        builder: (context, state) {
          ContactDetailsViewmodel vm = ContactDetailsViewmodel(
            contactRepository: context.read(),
          );
          vm.createEntity.execute();
          return ContactDetails(viewmodel: vm);
        },
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final vm = ContactDetailsViewmodel(contactRepository: context.read());

          vm.loadEntity.execute(id);

          return ContactDetails(viewmodel: vm);
        },
      ),
    ],
  ),
  GoRoute(
    path: Routes.eventsRelative,
    builder: (context, state) {
      final viewModel = EventListViewmodel(eventRepository: context.read());
      return EventListView(viewmodel: viewModel);
    },
    routes: [
      GoRoute(
        path: Routes.createRelative,
        builder: (context, state) {
          EventDetailsViewmodel vm = EventDetailsViewmodel(
            eventRepository: context.read(),
          );
          vm.createEntity.execute();
          return EventDetails(viewmodel: vm);
        },
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final vm = EventDetailsViewmodel(eventRepository: context.read());

          vm.loadEntity.execute(id);

          return EventDetails(viewmodel: vm);
        },
      ),
    ],
  ),
  GoRoute(
    path: Routes.gigsRelative,
    builder: (context, state) {
      final viewModel = GigListViewmodel(gigRepository: context.read());
      return GigListView(viewmodel: viewModel);
    },
    routes: [
      GoRoute(
        path: Routes.createRelative,
        builder: (context, state) {
          GigDetailsViewmodel vm = GigDetailsViewmodel(
            gigRepository: context.read(),
          );
          vm.createEntity.execute();
          return GigDetails(viewmodel: vm);
        },
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final vm = GigDetailsViewmodel(gigRepository: context.read());

          vm.loadEntity.execute(id);

          return GigDetails(viewmodel: vm);
        },
      ),
    ],
  ),
  GoRoute(
    path: Routes.locationsRelative,
    builder: (context, state) {
      final viewModel = LocationListViewmodel(
        locationRepository: context.read(),
      );
      return LocationListView(viewmodel: viewModel);
    },
    routes: [
      GoRoute(
        path: Routes.createRelative,
        builder: (context, state) {
          LocationDetailsViewmodel vm = LocationDetailsViewmodel(
            locationRepository: context.read(),
          );
          vm.createEntity.execute();
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

          vm.loadEntity.execute(id);

          return LocationDetails(viewmodel: vm);
        },
      ),
    ],
  ),
  GoRoute(
    path: Routes.organisationsRelative,
    builder: (context, state) {
      final viewModel = OrganisationListViewmodel(
        organisationRepository: context.read(),
      );
      return OrganisationListView(viewmodel: viewModel);
    },
    routes: [
      GoRoute(
        path: Routes.createRelative,
        builder: (context, state) {
          OrganisationDetailsViewmodel vm = OrganisationDetailsViewmodel(
            organisationRepository: context.read(),
          );
          vm.createEntity.execute();
          return OrganisationDetails(viewmodel: vm);
        },
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final vm = OrganisationDetailsViewmodel(
            organisationRepository: context.read(),
          );

          vm.loadEntity.execute(id);

          return OrganisationDetails(viewmodel: vm);
        },
      ),
    ],
  ),
  GoRoute(
    path: Routes.seriesRelative,
    builder: (context, state) {
      final viewModel = EventSeriesListViewmodel(
        seriesRepository: context.read(),
      );
      return EventSeriesListView(viewmodel: viewModel);
    },
    routes: [
      GoRoute(
        path: Routes.createRelative,
        builder: (context, state) {
          SeriesDetailsViewmodel vm = SeriesDetailsViewmodel(
            seriesRepository: context.read(),
          );
          vm.createEntity.execute();
          return SeriesDetails(viewmodel: vm);
        },
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final vm = SeriesDetailsViewmodel(seriesRepository: context.read());

          vm.loadEntity.execute(id);

          return SeriesDetails(viewmodel: vm);
        },
      ),
    ],
  ),
  GoRoute(
    path: Routes.songsRelative,
    builder: (context, state) {
      final viewModel = SongListViewmodel(songRepository: context.read());
      return SongListView(viewmodel: viewModel);
    },
    routes: [
      GoRoute(
        path: Routes.createRelative,
        builder: (context, state) {
          SongDetailsViewmodel vm = SongDetailsViewmodel(
            songRepository: context.read(),
          );
          vm.createEntity.execute();
          return SongDetails(viewmodel: vm);
        },
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final vm = SongDetailsViewmodel(songRepository: context.read());

          vm.loadEntity.execute(id);

          return SongDetails(viewmodel: vm);
        },
      ),
    ],
  ),
];

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
        GoRoute(path: Routes.home, builder: (context, state) => Dashboard()),
        GoRoute(
          path: Routes.overview,
          builder: (context, state) {
            return OverviewNavigationPage();
          },
          routes: overviewRoutes,
        ),
        GoRoute(
          path: Routes.analysis,
          builder: (context, state) {
            return AnalysisNavigationPage();
          },
          routes: analysisRoutes,
        ),
        GoRoute(
          path: Routes.data,
          builder: (context, state) {
            return DataNavigationPage();
          },
          routes: dataRoutes,
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
