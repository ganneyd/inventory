import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';
import 'package:inventory_v1/domain/repositories/authentication_repository.dart';
import 'package:logging/logging.dart';

class UpdatePasswordUsecase implements UseCase<void, UpdatePasswordParams> {
  UpdatePasswordUsecase({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        _logger = Logger('update-password-usecase');
  final AuthenticationRepository _authenticationRepository;
  final Logger _logger;

  @override
  Future<Either<Failure, void>> call(UpdatePasswordParams params) async {
    var authUserResults = await _authenticationRepository.authenticateUser(
        params.username, params.currentPassword);

    return authUserResults.fold((fail) => Left(fail), (authUser) async {
      if (authUser.username != params.userToUpdate.username &&
          !authUser.viewRights.contains(ViewRightsEnum.admin)) {
        _logger.warning(
            'Unauthorized password update attempt by ${params.username} for user: ${params.userToUpdate.username}');
        return const Left<Failure, void>(UpdateDataFailure(
          errMsg: 'Only admins or the user themselves can update the password',
        ));
      }

      var result = await _authenticationRepository.updatePassword(
          params.userToUpdate, params.newPassword);
      result.fold(
        (failure) => _logger.warning(
            'Failed to update  password for : ${params.userToUpdate.username}, Reason: ${failure.errorMessage}'),
        (_) => _logger
            .info('Password updated for : ${params.userToUpdate.username}'),
      );
      return result;
    });
  }
}

class UpdatePasswordParams extends Equatable {
  const UpdatePasswordParams(
      {required this.newPassword,
      required this.username,
      required this.currentPassword,
      required this.userToUpdate});
  final String username;
  final String currentPassword;
  final String newPassword;
  final UserEntity userToUpdate;

  @override
  List<Object?> get props =>
      [newPassword, username, currentPassword, userToUpdate];
}
