import 'package:drift/drift.dart';
import 'mixins/index.dart';

/// Users table for storing user profile data.
///
/// Note: Authentication tokens should be stored in secure storage
/// (e.g., flutter_secure_storage), not in the database.
class Users extends Table with IdMixin, TimestampsMixin {
  late final Column<String> name = text()();
  late final Column<String> email = text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {email},
  ];
}
