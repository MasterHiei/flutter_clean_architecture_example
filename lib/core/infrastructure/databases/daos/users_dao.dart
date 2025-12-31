import 'package:drift/drift.dart';
import 'package:flutter_clean_architecture_example/core/infrastructure/databases/app_database.dart';
import 'package:flutter_clean_architecture_example/core/infrastructure/databases/tables/users.dart';

part 'users_dao.g.dart';

/// Data Access Object for Users table.
///
/// Provides reactive streams and async CRUD operations.
@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  /// Watch all users reactively.
  Stream<List<User>> watchAll() => select(users).watch();

  /// Get all users.
  Future<List<User>> findAll() => select(users).get();

  /// Find user by ID.
  Future<User?> findById(String id) =>
      (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Find user by email.
  Future<User?> findByEmail(String email) =>
      (select(users)..where((t) => t.email.equals(email))).getSingleOrNull();

  /// Insert a new user. Returns generated row ID.
  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);

  /// Update an existing user. Returns true if updated.
  Future<bool> updateUser(UsersCompanion user) => update(users).replace(user);

  /// Delete user by ID. Returns count of deleted rows.
  Future<int> deleteById(String id) => (delete(users)..where((t) => t.id.equals(id))).go();
}
