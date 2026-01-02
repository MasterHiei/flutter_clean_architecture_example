import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/infrastructure/auth/auth_state_controller.dart';
import 'l10n/app_localizations.dart';
import 'router/app_router.dart';

void mainCommon() {
  runApp(ProviderScope(observers: [if (kDebugMode) _DebugProviderObserver()], child: const App()));
}

/// Root application widget using [AppRouter].
///
/// Subscribes to [AuthStateController] stream to handle global auth events.
/// On [AuthEvent.expired], forces navigation to Login and clears tokens.
class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late final StreamSubscription<AuthEvent> _authSubscription;

  @override
  void initState() {
    super.initState();
    // Initialize subscription after widget is mounted (ref is now valid)
    _authSubscription = ref.read(authStateControllerProvider).stream.listen((event) {
      if (event == AuthEvent.expired) {
        ref.read(appRouterProvider).replaceAll([const LoginRoute()]);
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)?.appTitle ?? '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter.config(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

final Provider<AppRouter> appRouterProvider = Provider((ref) => AppRouter(ref));

/// Debug observer for tracking provider state changes.
///
/// Riverpod 3.x uses ProviderObserverContext for provider info.
final class _DebugProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderObserverContext context, Object? previousValue, Object? newValue) {
    if (newValue is AsyncError) {
      debugPrint(
        '[${context.provider.name ?? context.provider.runtimeType}] ❌ Error: ${newValue.error}',
      );
      debugPrint('Stack trace:\n${newValue.stackTrace}');
    } else {
      debugPrint(
        '[${context.provider.name ?? context.provider.runtimeType}] $previousValue → $newValue',
      );
    }
  }
}
