import 'package:drift/drift.dart';
import 'package:flutter_clean_architecture_example/features/core/databases/tables/mixins/index.dart';

class Users extends Table with IdMixin, TimestampsMixin {
  late final name = text()();
  late final email = text()();
  late final password = text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {email},
  ];
}
