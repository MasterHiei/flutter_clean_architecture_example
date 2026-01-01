import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/failures/failure.dart';
import '../../../../core/domain/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Authenticates user with biometrics.
class LoginWithBiometrics implements NoInputUseCase<User> {
  const LoginWithBiometrics(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call() => _repository.loginWithBiometrics();
}
