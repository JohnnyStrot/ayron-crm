import 'package:ayron_crm/data/repositories/auth/auth_repository.dart';
import 'package:ayron_crm/data/repositories/band/band_repository.dart';
import 'package:ayron_crm/data/repositories/band/band_repository_local.dart';
import 'package:ayron_crm/data/repositories/contact/contact_repository.dart';
import 'package:ayron_crm/data/repositories/contact/contact_repository_local.dart';
import 'package:ayron_crm/data/repositories/event/event_repository.dart';
import 'package:ayron_crm/data/repositories/event/event_repository_local.dart';
import 'package:ayron_crm/data/repositories/gig/gig_repository.dart';
import 'package:ayron_crm/data/repositories/gig/gig_repository_local.dart';
import 'package:ayron_crm/data/repositories/location/location_repository.dart';
import 'package:ayron_crm/data/repositories/location/location_repository_local.dart';
import 'package:ayron_crm/data/repositories/organisation/organisation_repository.dart';
import 'package:ayron_crm/data/repositories/organisation/organisation_repository_local.dart';
import 'package:ayron_crm/data/repositories/series/series_repository.dart';
import 'package:ayron_crm/data/repositories/series/series_repository_local.dart';
import 'package:ayron_crm/data/repositories/song/song_repository.dart';
import 'package:ayron_crm/data/repositories/song/song_repository_local.dart';
import 'package:ayron_crm/data/services/local/local_data_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'data/repositories/auth/auth_repository_dev.dart';
import 'main.dart';

/// Development config entry point.
/// Launch with `flutter run --target lib/main_development.dart`.
/// Uses local data.
void main() {
  Logger.root.level = Level.ALL;
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: LocalDataService()),
        ChangeNotifierProvider.value(
          value: AuthRepositoryDev() as AuthRepository,
        ),
        Provider(
          create: (context) =>
              LocationRepositoryLocal(localDataService: context.read())
                  as LocationRepository,
        ),
        Provider(
          create: (context) =>
              OrganisationRepositoryLocal(localDataService: context.read())
                  as OrganisationRepository,
        ),
        Provider(
          create: (context) =>
              GigRepositoryLocal(localDataService: context.read())
                  as GigRepository,
        ),
        Provider(
          create: (context) =>
              BandRepositoryLocal(localDataService: context.read())
                  as BandRepository,
        ),
        Provider(
          create: (context) =>
              EventSeriesRepositoryLocal(localDataService: context.read())
                  as EventSeriesRepository,
        ),
        Provider(
          create: (context) =>
              ContactRepositoryLocal(localDataService: context.read())
                  as ContactRepository,
        ),
        Provider(
          create: (context) =>
              SongRepositoryLocal(localDataService: context.read())
                  as SongRepository,
        ),
        Provider(
          create: (context) =>
              EventRepositoryLocal(localDataService: context.read())
                  as EventRepository,
        ),
      ],
      child: const MainApp(),
    ),
  );
}
