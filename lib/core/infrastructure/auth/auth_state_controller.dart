import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state_controller.g.dart';

/// Events representing global authentication state changes.
enum AuthEvent {
  /// Token was successfully refreshed.
  refreshed,

  /// Authentication expired and could not be refreshed.
  /// App should force logout and navigate to login.
  expired,

  /// User explicitly logged out.
  loggedOut,
}

/// Global controller for broadcasting authentication state changes.
///
/// This controller uses a broadcast stream to notify all listeners
/// (e.g., main app, interceptors) about auth state changes.
///
/// Usage:
/// - Interceptors emit [AuthEvent.expired] when refresh fails
/// - App subscribes and navigates to login on expired event
class AuthStateController {
  AuthStateController();

  final StreamController<AuthEvent> _controller = StreamController<AuthEvent>.broadcast();

  /// Stream of authentication events.
  Stream<AuthEvent> get stream => _controller.stream;

  /// Emit an authentication event.
  void emit(AuthEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  /// Close the controller. Call on app dispose.
  void dispose() {
    _controller.close();
  }
}

@Riverpod(keepAlive: true)
AuthStateController authStateController(Ref ref) {
  final controller = AuthStateController();
  ref.onDispose(controller.dispose);
  return controller;
}
