import 'package:drift/drift.dart';

mixin IdMixin on Table {
  late final id = text()();

  @override
  Set<Column> get primaryKey => {id};
}
