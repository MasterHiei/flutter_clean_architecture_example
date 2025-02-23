import 'package:drift/drift.dart';
import 'package:flutter_clean_architecture_example/features/core/databases/app_database.dart';
import 'package:flutter_clean_architecture_example/features/core/databases/tables/users.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);
}
