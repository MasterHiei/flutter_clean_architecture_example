import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../router/app_router.dart';
import '../notifiers/splash_notifier.dart';

/// Splash page with minimal-latency authentication check.
///
/// Uses Riverpod for state management (no setState per project rules).
/// Navigates to Home or Login based on auth status.
@RoutePage()
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    // Listen to auth state and navigate accordingly
    ref.listen<AsyncValue<SplashAuthState>>(splashProvider, (_, next) {
      next.whenData((authState) {
        switch (authState) {
          case SplashAuthState.authenticated:
            context.router.replaceAll([const HomeRoute()]);
          case SplashAuthState.unauthenticated:
            context.router.replaceAll([const LoginRoute()]);
          case SplashAuthState.loading:
          case SplashAuthState.error:
            // Stay on splash, UI handles these states
            break;
        }
      });
    });

    final AsyncValue<SplashAuthState> authState = ref.watch(splashProvider);

    return Scaffold(
      body: Center(
        child: authState.when(
          data: (state) => switch (state) {
            SplashAuthState.loading => const _LoadingContent(),
            SplashAuthState.authenticated => const _LoadingContent(),
            SplashAuthState.unauthenticated => const _LoadingContent(),
            SplashAuthState.error => _ErrorContent(
              onRetry: () => ref.read(splashProvider.notifier).retry(),
              theme: theme,
              l10n: l10n,
            ),
          },
          loading: () => const _LoadingContent(),
          error: (_, _) => _ErrorContent(
            onRetry: () => ref.read(splashProvider.notifier).retry(),
            theme: theme,
            l10n: l10n,
          ),
        ),
      ),
    );
  }
}

/// Loading indicator for splash screen.
class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline, size: 64, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 24),
        const CircularProgressIndicator(),
      ],
    );
  }
}

/// Error content with retry button.
class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.onRetry, required this.theme, required this.l10n});

  final VoidCallback onRetry;
  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
        const SizedBox(height: 16),
        Text(l10n.errorUnexpected, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: Text(l10n.retry),
        ),
      ],
    );
  }
}
