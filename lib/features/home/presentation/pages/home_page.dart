import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../router/app_router.dart';
import '../../../auth/domain/entities/user.dart';
import '../notifiers/home_notifier.dart';

/// Home page displayed after successful authentication.
///
/// Shows user info and provides logout functionality.
@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<User?> userState = ref.watch(homeProvider);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    // Listen for logout - navigate to login when user becomes null after being logged in
    ref.listen<AsyncValue<User?>>(homeProvider, (previous, next) {
      final wasLoggedIn = previous?.value != null;
      final bool isLoggedOut = next.value == null && !next.isLoading;

      if (wasLoggedIn && isLoggedOut) {
        context.router.replaceAll([const LoginRoute()]);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            key: const Key('logout_button'),
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: userState.isLoading ? null : () => ref.read(homeProvider.notifier).logout(),
          ),
        ],
      ),
      body: userState.when(
        data: (user) => user == null
            ? const Center(child: CircularProgressIndicator())
            : _UserInfoCard(user: user, theme: theme, l10n: l10n),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(l10n.errorUnexpected),
              const SizedBox(height: 16),
              FilledButton(onPressed: () => ref.invalidate(homeProvider), child: Text(l10n.retry)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays user information in a card format.
class _UserInfoCard extends StatelessWidget {
  const _UserInfoCard({required this.user, required this.theme, required this.l10n});

  final User user;
  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person,
                      size: 48,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.welcomeMessage(user.email),
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
