// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Clean Architecture';

  @override
  String get loginTitle => '登录';

  @override
  String get loginButton => '登录';

  @override
  String get emailLabel => '邮箱';

  @override
  String get passwordLabel => '密码';

  @override
  String get errorNetwork => '网络错误，请检查连接。';

  @override
  String get errorUnexpected => '发生未知错误。';

  @override
  String errorNotFound(String resource) {
    return '未找到 $resource。';
  }

  @override
  String get retry => '重试';

  @override
  String get settings => '设置';

  @override
  String get theme => '主题';

  @override
  String get language => '语言';

  @override
  String get darkMode => '深色模式';

  @override
  String get lightMode => '浅色模式';

  @override
  String get errorEmailRequired => '请输入邮箱';

  @override
  String get errorEmailInvalid => '邮箱格式不正确';

  @override
  String get errorEmailTooShort => '邮箱长度过短';

  @override
  String get errorEmailTooLong => '邮箱长度过长';

  @override
  String get errorValueMismatch => '输入不一致';

  @override
  String get errorPasswordRequired => '请输入密码';

  @override
  String get errorServiceUnavailable => '服务暂停';

  @override
  String get errorInvalidCredentials => '邮箱或密码错误';

  @override
  String get errorBiometricsUnavailable => '生物识别不可用';

  @override
  String get errorBiometricsHardware => '未检测到生物识别硬件';

  @override
  String get useBiometrics => '使用生物识别';

  @override
  String get homeTitle => '主页';

  @override
  String get logout => '登出';

  @override
  String welcomeMessage(String email) {
    return '欢迎，$email';
  }
}
