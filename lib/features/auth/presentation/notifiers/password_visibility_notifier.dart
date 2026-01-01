import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'password_visibility_notifier.g.dart';

@riverpod
class PasswordVisibilityNotifier extends _$PasswordVisibilityNotifier {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }
}
