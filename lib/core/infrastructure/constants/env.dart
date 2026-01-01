import 'package:envied/envied.dart';

part 'env.g.dart';

abstract interface class EnvFields {
  abstract final String databaseName;

  abstract final String apiBaseUrl;
}

abstract interface class Env implements EnvFields {
  static late final Env _instance;
  static bool _isInitialized = false;

  static Env get instance => _instance;

  static void init(String flavor) {
    if (_isInitialized) {
      return;
    }

    _instance = switch (flavor) {
      'dev' => DevEnv(),
      'prod' => ProdEnv(),
      _ => throw UnsupportedError('Unsupported flavor: $flavor'),
    };
    _isInitialized = true;
  }
}

@Envied(path: '.env.dev')
final class DevEnv implements Env, EnvFields {
  DevEnv();

  @override
  @EnviedField(varName: 'DATABASE_NAME', obfuscate: true)
  final String databaseName = _DevEnv.databaseName;

  @override
  @EnviedField(varName: 'API_BASE_URL', obfuscate: true)
  final String apiBaseUrl = _DevEnv.apiBaseUrl;
}

@Envied(path: '.env.prod')
final class ProdEnv implements Env, EnvFields {
  ProdEnv();

  @override
  @EnviedField(varName: 'DATABASE_NAME', obfuscate: true)
  final String databaseName = _ProdEnv.databaseName;

  @override
  @EnviedField(varName: 'API_BASE_URL', obfuscate: true)
  final String apiBaseUrl = _ProdEnv.apiBaseUrl;
}
