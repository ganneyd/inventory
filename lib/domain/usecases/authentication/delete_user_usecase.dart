import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';
import 'package:inventory_v1/domain/repositories/authentication_repository.dart';
import 'package:logging/logging.dart';

class DeleteUserUsecase implements UseCase<void, DeleteUserParams> {
  DeleteUserUsecase({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        _logger = Logger('delete-user-usecase');

  final AuthenticationRepository _authenticationRepository;
  final Logger _logger;

  @override
  Future<Either<Failure, void>> call(DeleteUserParams params) async {
    _logger.info('Attempting to delete user: ${params.userEntity.username}');

    var verifyUser = await _authenticationRepository.authenticateUser(
        params.username, params.password);

    return verifyUser.fold(
      (failure) {
        _logger.warning(
            'Authentication failed for user deletion attempt: ${params.username}');
        return Left<Failure, void>(failure);
      },
      (authUser) async {
        if (authUser.username != params.username &&
            !authUser.viewRights.contains(ViewRightsEnum.admin)) {
          _logger.warning(
              'Unauthorized deletion attempt by ${params.username} for user: ${params.userEntity.username}');
          return const Left<Failure, void>(DeleteDataFailure(
            errMsg:
                'Only admins or the user themselves can delete this profile',
          ));
        }

        var result =
            await _authenticationRepository.deleteUser(params.userEntity);
        result.fold(
          (failure) => _logger.warning(
              'Failed to delete user: ${params.userEntity.username}, Reason: $failure'),
          (_) => _logger
              .info('User successfully deleted: ${params.userEntity.username}'),
        );
        return result;
      },
    );
  }
}

class DeleteUserParams extends Equatable {
  const DeleteUserParams(
      {required this.userEntity,
      required this.password,
      required this.username});
  final UserEntity userEntity;
  final String password;
  final String username;

  @override
  List<Object?> get props => [userEntity, username, password];
}
