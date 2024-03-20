import 'package:bcrypt/bcrypt.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/util/rank_enum.dart';
import 'package:inventory_v1/data/models/user/user_model.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';
import 'package:inventory_v1/domain/repositories/authentication_repository.dart';
import 'package:logging/logging.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  AuthenticationRepositoryImplementation(
      {required Box<UserModel> localDatasource})
      : _localDatasource = localDatasource,
        _logger = Logger('authentication-repo');
  final Box<UserModel> _localDatasource;
  final Logger _logger;

  @override
  Future<Either<Failure, void>> createUser(UserEntity user) async {
    try {
      //check if user exists already
      var userModel =
          user.copyWith(password: _hashPassword(user.password)).toModel();
      if (_usernameExists(userModel.usernameModel)) {
        _logger
            .info('User ${user.firstName} - ${user.lastName} already exists');
        return Left<Failure, void>(CreateDataFailure(
            errMsg:
                'User ${user.firstName} - ${user.lastName} already exists'));
      }

      _localDatasource.put(userModel.usernameModel, userModel);
      _logger.info(
          'Created User ${user.firstName} - ${user.lastName} username is ${userModel.username} password ${userModel.passwordModel}');
      return const Right(null);
    } catch (e) {
      _logger.warning('Error encountered while authenticating user',
          [e, StackTrace.current]);
      return Left<Failure, void>(
          AuthenticationFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(UserEntity user) async {
    try {
      var index = 0;
      _localDatasource.values.firstWhere((element) {
        if (element.firstNameModel == user.firstName &&
            element.lastNameModel == user.lastName &&
            element.rankModel == user.rank) {
          return true;
        }
        index++;
        return false;
      });
      var userAtIndex = _localDatasource.getAt(index);
      _logger.info(
          'deleting user at $index which is ${userAtIndex?.firstNameModel} - ${userAtIndex?.lastNameModel}');
      _localDatasource.deleteAt(index);
      return const Right<Failure, void>(null);
    } catch (e) {
      return Left<Failure, void>(DeleteDataFailure(
          errMsg:
              'Unable to delete user User ${user.firstName} - ${user.lastName} with username: ${user.username}'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    try {
      var users = _localDatasource.values
          .map((e) => UserModel(
              firstNameModel: e.firstNameModel,
              lastNameModel: e.lastNameModel,
              rankModel: e.rankModel,
              usernameModel: e.usernameModel,
              passwordModel: '',
              viewRightsList: e.viewRightsList))
          .toList();
      return Right<Failure, List<UserEntity>>(users);
    } catch (e) {
      _logger.severe(
          'unable to get list of users from box, ', [e, StackTrace.current]);
      return const Left<Failure, List<UserEntity>>(
          ReadDataFailure(errMsg: 'Unable to retrieve users at this time'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(UserEntity user) async {
    try {
      var userInBox = _localDatasource.get(user.username);
      _logger.info(
          'updating user ${userInBox?.firstNameModel} - ${userInBox?.lastNameModel}');
      _localDatasource.put(user.username, user.toModel());

      _logger.info(
          'updated user ${userInBox?.firstNameModel} - ${userInBox?.lastNameModel} - ${userInBox?.rank.enumToString()} - ${userInBox?.usernameModel} - ${userInBox?.viewRightsList.toString()}');

      return const Right<Failure, void>(null);
    } catch (e) {
      _logger.severe(
          'unable to update user ${user.firstName} - ${user.lastName}, ',
          [e, StackTrace.current]);
      return Left<Failure, void>(UpdateDataFailure(
          errMsg:
              'Unable to update user ${user.firstName} - ${user.lastName}'));
    }
  }

  bool _usernameExists(String username) {
    return _localDatasource.keys.contains(username);
  }

  @override
  Future<Either<Failure, UserEntity>> authenticateUser(
      String username, String password) async {
    try {
      var user = _localDatasource.get(username);

      if (user != null && _verifyPassword(password, user.passwordModel)) {
        return Right<Failure, UserEntity>(user);
      } else {
        _logger.info(
            '$username and $password invalid hashpassword is ${_hashPassword(password)} ');
        return const Left<Failure, UserEntity>(AuthenticationFailure(
            errorMessage: 'Invalid credentials, please try again'));
      }
    } catch (e) {
      _logger.severe('Unexpected error occurred while authenticating $e');
      return const Left<Failure, UserEntity>(AuthenticationFailure(
          errorMessage: 'Unexpected error occurred while authenticating'));
    }
  }

  String _hashPassword(String password) {
    // Generate a salt
    final salt = BCrypt.gensalt();
    // Hash the password using the salt
    return BCrypt.hashpw(password, salt);
  }

  bool _verifyPassword(String providedPassword, String storedHash) {
    return BCrypt.checkpw(providedPassword, storedHash);
  }

  @override
  Future<Either<Failure, void>> updatePassword(
      UserEntity user, String newPassword) async {
    try {
      var userInBox = _localDatasource.get(user.username);
      if (userInBox != null) {
        _logger.info(
            'updating password for user ${userInBox.firstNameModel} - ${userInBox.lastNameModel}');
        var newHashedPassword = _hashPassword(newPassword);
        var userWithNewPassword = user.copyWith(password: newHashedPassword);
        _localDatasource.put(user.username, userWithNewPassword.toModel());

        _logger.info(
            'updated password for user ${userInBox.firstNameModel} - ${userInBox.lastNameModel}');
        return const Right<Failure, void>(null);
      } else {
        _logger.warning(
            'Attempted to update password for a non-existent user, with username ${user.username}');
        return const Left(UpdateDataFailure(
            errMsg: 'Cannot update password for an non-existent user'));
      }
    } catch (e) {
      _logger.severe(
          'unable to update password for user ${user.firstName} - ${user.lastName}, ',
          [e, StackTrace.current]);
      return Left<Failure, void>(UpdateDataFailure(
          errMsg:
              'Unable to update password for user ${user.firstName} - ${user.lastName}'));
    }
  }
}
