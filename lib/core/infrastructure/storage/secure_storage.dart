import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/failures/failure.dart';

part 'secure_storage.g.dart';

/// Interface for secure key-value storage.
abstract interface class SecureStorage {
  Future<Either<Failure, String?>> read(String key);
  Future<Either<Failure, Unit>> write(String key, String value);
  Future<Either<Failure, Unit>> delete(String key);
  Future<Either<Failure, Unit>> deleteAll();
}

/// Implementation using flutter_secure_storage v10.
final class SecureStorageImpl implements SecureStorage {
  SecureStorageImpl([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<Either<Failure, String?>> read(String key) async {
    try {
      return right(await _storage.read(key: key));
    } catch (e, st) {
      return left(Failure.unexpected(error: e, stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, Unit>> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      return right(unit);
    } catch (e, st) {
      return left(Failure.unexpected(error: e, stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String key) async {
    try {
      await _storage.delete(key: key);
      return right(unit);
    } catch (e, st) {
      return left(Failure.unexpected(error: e, stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAll() async {
    try {
      await _storage.deleteAll();
      return right(unit);
    } catch (e, st) {
      return left(Failure.unexpected(error: e, stackTrace: st));
    }
  }
}

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) => SecureStorageImpl();
