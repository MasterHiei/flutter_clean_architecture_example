import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '../constants/db_settings.dart';
import '../constants/env.dart';
import 'daos/index.dart';
import 'tables/index.dart';

part 'app_database.g.dart';

const List<Type> _tables = [Users];

const List<Type> _daos = [UsersDao];

@DriftDatabase(tables: _tables, daos: _daos)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: Env.instance.databaseName));

  @override
  int get schemaVersion => DbSettings.schemaVersion;
}
