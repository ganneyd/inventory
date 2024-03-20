import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';
import 'package:inventory_v1/domain/repositories/authentication_repository.dart';
import 'package:logging/logging.dart';

class UpdateUserProfileUsecase
    implements UseCase<void, UpdateUserProfileParams> {
  final AuthenticationRepository authenticationRepository;
  final Logger _logger = Logger('UpdateUserProfileUsecase');

  UpdateUserProfileUsecase({required this.authenticationRepository});

  @override
  Future<Either<Failure, void>> call(UpdateUserProfileParams params) async {
    // Authenticate the requesting user
    var authResult = await authenticationRepository.authenticateUser(
        params.requestingUserUsername, params.requestingUserPassword);

    return authResult.fold(
      (failure) => Left(failure),
      (authenticatedUser) async {
        // Check if it's the user themselves or an admin
        if (authenticatedUser.username == params.userToUpdate.username ||
            authenticatedUser.viewRights.contains(ViewRightsEnum.admin)) {
          // Proceed with the update
          return await authenticationRepository.updateUser(params.userToUpdate);
        } else {
          // Not authorized
          _logger.warning(
              'Unauthorized profile update attempt by ${authenticatedUser.username} for ${params.userToUpdate.username}');
          return const Left(AuthenticationFailure(
              errorMessage:
                  "You don't have permission to update this profile."));
        }
      },
    );
  }
}

class UpdateUserProfileParams extends Equatable {
  final UserEntity userToUpdate;
  final String requestingUserUsername;
  final String requestingUserPassword;

  const UpdateUserProfileParams({
    required this.userToUpdate,
    required this.requestingUserUsername,
    required this.requestingUserPassword,
  });

  @override
  List<Object?> get props =>
      [userToUpdate, requestingUserUsername, requestingUserPassword];
}
