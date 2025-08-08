import 'package:ayron_crm/data/repositories/auth/auth_repository.dart';
import 'package:ayron_crm/data/repositories/location/location_repository.dart';
import 'package:ayron_crm/data/repositories/location/location_repository_local.dart';
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
        ChangeNotifierProvider(
          create: (context) =>
              LocationRepositoryLocal(localDataService: context.read())
                  as LocationRepository,
        ),
      ],
      child: const MainApp(),
    ),
  );
}
