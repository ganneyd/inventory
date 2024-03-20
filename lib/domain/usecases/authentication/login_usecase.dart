import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';
import 'package:inventory_v1/domain/repositories/authentication_repository.dart';

class LoginUsecase implements UseCase<UserEntity, LoginParams> {
  LoginUsecase({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository;
  final AuthenticationRepository _authenticationRepository;

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return _authenticationRepository.authenticateUser(
        params.username, params.password);
  }
}

class LoginParams extends Equatable {
  final String username;
  final String password;

  const LoginParams({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}
