import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures/failure.dart';
import '../../../../core/domain/value_objects/email_address.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../router/app_router.dart';
import '../../domain/entities/user.dart';
import '../notifiers/login_notifier.dart';
import '../notifiers/password_visibility_notifier.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'user@example.com');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<User?> loginState = ref.watch(loginProvider);
    final LoginNotifier notifier = ref.read(loginProvider.notifier);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool isPasswordVisible = ref.watch(passwordVisibilityProvider);

    ref.listen<AsyncValue<User?>>(loginProvider, (_, next) {
      if (next.hasValue && next.value != null) {
        context.router.replaceAll([const HomeRoute()]);
      }

      final Object? error = next.error;
      if (next.hasError && error is Failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(notifier.getErrorMessage(error, l10n))));
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loginTitle)),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  key: const Key('login_email'),
                  controller: _emailController,
                  decoration: InputDecoration(labelText: l10n.emailLabel),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => EmailAddress.create(value ?? '').fold(
                    (f) => f.map(
                      emptyField: (_) => l10n.errorEmailRequired,
                      invalidFormat: (_) => l10n.errorEmailInvalid,
                      tooShort: (_) => l10n.errorEmailTooShort,
                      tooLong: (_) => l10n.errorEmailTooLong,
                      mismatch: (_) => l10n.errorValueMismatch,
                    ),
                    (_) => null,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('login_password'),
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: l10n.passwordLabel,
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        ref.read(passwordVisibilityProvider.notifier).toggle();
                      },
                    ),
                  ),
                  obscureText: !isPasswordVisible,
                  validator: (v) => v == null || v.isEmpty ? l10n.errorPasswordRequired : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const Key('login_button'),
                    onPressed: loginState.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              notifier.loginWithCredentials(
                                _emailController.text,
                                _passwordController.text,
                              );
                            }
                          },
                    child: loginState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.loginButton),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: loginState.isLoading ? null : notifier.loginWithBiometrics,
                  icon: const Icon(Icons.fingerprint),
                  label: Text(l10n.useBiometrics),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
