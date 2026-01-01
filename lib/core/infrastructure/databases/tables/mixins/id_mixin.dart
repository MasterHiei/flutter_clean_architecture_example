import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// Mixin providing UUID-based primary key for Drift tables.
///
/// Automatically generates UUID v4 if not provided.
mixin IdMixin on Table {
  static const _uuid = Uuid();

  late final Column<String> id = text().clientDefault(() => _uuid.v4())();

  @override
  Set<Column> get primaryKey => {id};
}
