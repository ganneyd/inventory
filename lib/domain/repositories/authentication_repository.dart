import 'package:dartz/dartz.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';

abstract class AuthenticationRepository {
  ///creates a new user
  Future<Either<Failure, void>> createUser(UserEntity user);

  ///retrieves all the users from the database
  Future<Either<Failure, List<UserEntity>>> getUsers();

  ///deletes the [user] from the database
  Future<Either<Failure, void>> deleteUser(UserEntity user);

  ///updates the [user] with its new values
  Future<Either<Failure, void>> updateUser(UserEntity user);

  ///authenticates user
  Future<Either<Failure, UserEntity>> authenticateUser(
      String username, String password);

  Future<Either<Failure, void>> updatePassword(
      UserEntity user, String newPassword);
}
