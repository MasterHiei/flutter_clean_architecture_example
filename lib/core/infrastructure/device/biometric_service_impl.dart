import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/failures/failure.dart';
import '../../domain/services/biometric_service.dart';

part 'biometric_service_impl.g.dart';

/// Implementation of [BiometricService] using local_auth.
final class BiometricServiceImpl implements BiometricService {
  BiometricServiceImpl([LocalAuthentication? auth]) : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<Either<Failure, bool>> isAvailable() async {
    try {
      final bool canCheck = await _auth.canCheckBiometrics;
      final bool isSupported = await _auth.isDeviceSupported();
      return right(canCheck && isSupported);
    } catch (e, st) {
      return left(Failure.unexpected(error: e, stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, bool>> authenticate({required String reason}) async {
    try {
      final bool result = await _auth.authenticate(localizedReason: reason, biometricOnly: true);
      return right(result);
    } on PlatformException catch (e) {
      if (e.code == 'NotAvailable' || e.code == 'NotEnrolled' || e.code == 'PasscodeNotSet') {
        return left(const Failure.device(reason: DeviceFailureReason.unavailable));
      } else if (e.code == 'NoHardware') {
        return left(const Failure.device(reason: DeviceFailureReason.noHardware));
      }
      return left(const Failure.device(reason: DeviceFailureReason.other));
    } catch (e) {
      return left(const Failure.device(reason: DeviceFailureReason.other));
    }
  }
}

@Riverpod(keepAlive: true)
BiometricService biometricService(Ref ref) => BiometricServiceImpl();
