import 'package:drift/drift.dart';

mixin TimestampsMixin on Table {
  late final createdAt = dateTime().withDefault(currentDateAndTime)();

  late final updatedAt = dateTime().withDefault(currentDateAndTime)();
}
