// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Clean Architecture';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginButton => 'Sign In';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get errorNetwork => 'Network error. Please check your connection.';

  @override
  String get errorUnexpected => 'An unexpected error occurred.';

  @override
  String errorNotFound(String resource) {
    return '$resource not found.';
  }

  @override
  String get retry => 'Retry';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get errorEmailRequired => 'Email is required';

  @override
  String get errorEmailInvalid => 'Invalid email format';

  @override
  String get errorEmailTooShort => 'Email too short';

  @override
  String get errorEmailTooLong => 'Email too long';

  @override
  String get errorValueMismatch => 'Values do not match';

  @override
  String get errorPasswordRequired => 'Password is required';

  @override
  String get errorServiceUnavailable => 'Service unavailable';

  @override
  String get errorInvalidCredentials => 'Invalid email or password';

  @override
  String get errorBiometricsUnavailable => 'Biometrics not available';

  @override
  String get errorBiometricsHardware => 'No biometric hardware found';

  @override
  String get useBiometrics => 'Use Biometrics';

  @override
  String get homeTitle => 'Home';

  @override
  String get logout => 'Logout';

  @override
  String welcomeMessage(String email) {
    return 'Welcome, $email';
  }
}
