import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/failures/failure.dart';
import '../../../../core/domain/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Input for credential-based login.
class LoginCredentials {
  const LoginCredentials({required this.email, required this.password});
  final String email;
  final String password;
}

/// Authenticates user with email and password.
class LoginWithCredentials implements UseCase<LoginCredentials, User> {
  const LoginWithCredentials(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(LoginCredentials input) =>
      _repository.loginWithCredentials(email: input.email, password: input.password);
}
