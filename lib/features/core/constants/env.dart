import 'package:envied/envied.dart';

part 'env.g.dart';

abstract interface class EnvFields {
  abstract final String databaseName;

  abstract final String apiBaseUrl;
}

abstract interface class Env implements EnvFields {
  factory Env._() => switch (const String.fromEnvironment('FLUTTER_APP_FLAVOR')) {
    'dev' => DevEnv(),
    'prod' => ProdEnv(),
    _ => throw UnsupportedError('Unsupported FLUTTER_APP_FLAVOR'),
  };

  static final instance = Env._();
}

@Envied(path: '.env.dev')
final class DevEnv implements Env, EnvFields {
  DevEnv();

  @override
  @EnviedField(varName: 'DATABASE_NAME')
  final String databaseName = _DevEnv.databaseName;

  @override
  @EnviedField(varName: 'API_BASE_URL')
  final String apiBaseUrl = _DevEnv.apiBaseUrl;
}

@Envied(path: '.env.prod')
final class ProdEnv implements Env, EnvFields {
  ProdEnv();

  @override
  @EnviedField(varName: 'DATABASE_NAME')
  final String databaseName = _ProdEnv.databaseName;

  @override
  @EnviedField(varName: 'API_BASE_URL')
  final String apiBaseUrl = _ProdEnv.apiBaseUrl;
}
