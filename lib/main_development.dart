import 'package:ayron_crm/data/repositories/auth/auth_repository.dart';
import 'package:ayron_crm/data/repositories/auth/auth_repository_remote.dart';
import 'package:ayron_crm/data/repositories/band/band_repository.dart';
import 'package:ayron_crm/data/repositories/band/band_repository_local.dart';
import 'package:ayron_crm/data/repositories/band/band_repository_remote.dart';
import 'package:ayron_crm/data/repositories/contact/contact_repository.dart';
import 'package:ayron_crm/data/repositories/contact/contact_repository_local.dart';
import 'package:ayron_crm/data/repositories/contact/contact_repository_remote.dart';
import 'package:ayron_crm/data/repositories/event/event_repository.dart';
import 'package:ayron_crm/data/repositories/event/event_repository_local.dart';
import 'package:ayron_crm/data/repositories/event/event_repository_remote.dart';
import 'package:ayron_crm/data/repositories/gig/gig_repository.dart';
import 'package:ayron_crm/data/repositories/gig/gig_repository_local.dart';
import 'package:ayron_crm/data/repositories/gig/gig_repository_remote.dart';
import 'package:ayron_crm/data/repositories/location/location_repository.dart';
import 'package:ayron_crm/data/repositories/location/location_repository_local.dart';
import 'package:ayron_crm/data/repositories/location/location_repository_remote.dart';
import 'package:ayron_crm/data/repositories/organisation/organisation_repository.dart';
import 'package:ayron_crm/data/repositories/organisation/organisation_repository_local.dart';
import 'package:ayron_crm/data/repositories/organisation/organisation_repository_remote.dart';
import 'package:ayron_crm/data/repositories/series/series_repository.dart';
import 'package:ayron_crm/data/repositories/series/series_repository_local.dart';
import 'package:ayron_crm/data/repositories/series/series_repository_remote.dart';
import 'package:ayron_crm/data/repositories/song/song_repository.dart';
import 'package:ayron_crm/data/repositories/song/song_repository_remote.dart';
import 'package:ayron_crm/data/services/api/api_service.dart';
import 'package:ayron_crm/data/services/api/auth_api_client.dart';
import 'package:ayron_crm/data/services/local/local_data_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'main.dart';

/// Development config entry point.
/// Launch with `flutter run --target lib/main_development.dart`.
/// Uses development api.
void main() {
  Logger.root.level = Level.ALL;
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => AuthApiClient()),
        ChangeNotifierProvider(
          create: (context) =>
              AuthRepositoryRemote(authApiClient: context.read())
                  as AuthRepository,
        ),
        Provider(
          create: (context) => ApiService(authApiClient: context.read()),
        ),

        Provider(
          create: (context) =>
              BandRepositoryRemote(apiService: context.read())
                  as BandRepository,
        ),
        Provider(
          create: (context) =>
              ContactRepositoryRemote(apiService: context.read())
                  as ContactRepository,
        ),
        Provider(
          create: (context) =>
              EventRepositoryRemote(apiService: context.read())
                  as EventRepository,
        ),
        Provider(
          create: (context) =>
              EventSeriesRepositoryRemote(apiService: context.read())
                  as EventSeriesRepository,
        ),
        Provider(
          create: (context) =>
              GigRepositoryRemote(apiService: context.read()) as GigRepository,
        ),
        Provider(
          create: (context) =>
              LocationRepositoryRemote(apiService: context.read())
                  as LocationRepository,
        ),
        Provider(
          create: (context) =>
              OrganisationRepositoryRemote(apiService: context.read())
                  as OrganisationRepository,
        ),
        Provider(
          create: (context) =>
              SongRepositoryRemote(apiService: context.read())
                  as SongRepository,
        ),
      ],
      child: const MainApp(),
    ),
  );
}
