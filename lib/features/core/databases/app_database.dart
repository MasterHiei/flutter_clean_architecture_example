import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_clean_architecture_example/features/core/constants/db_settings.dart';
import 'package:flutter_clean_architecture_example/features/core/constants/env.dart';
import 'package:flutter_clean_architecture_example/features/core/databases/daos/index.dart';
import 'package:flutter_clean_architecture_example/features/core/databases/tables/index.dart';

part 'app_database.g.dart';

const _tables = [Users];

const _daos = [UsersDao];

@DriftDatabase(tables: _tables, daos: _daos)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: Env.instance.databaseName));

  @override
  int get schemaVersion => DbSettings.schemaVersion;
}
