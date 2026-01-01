import 'package:fpdart/fpdart.dart';

import '../failures/failure.dart';

/// Base interface for all use cases.
///
/// [Input] - Parameters required by the use case.
/// [Output] - Success result type.
abstract interface class UseCase<Input, Output> {
  Future<Either<Failure, Output>> call(Input input);
}

/// Use case that requires no input parameters.
abstract interface class NoInputUseCase<Output> {
  Future<Either<Failure, Output>> call();
}
