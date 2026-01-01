import 'package:drift/drift.dart';

mixin TimestampsMixin on Table {
  late final Column<DateTime> createdAt = dateTime().withDefault(currentDateAndTime)();

  late final Column<DateTime> updatedAt = dateTime().withDefault(currentDateAndTime)();
}
