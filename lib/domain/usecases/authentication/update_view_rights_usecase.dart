import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';
import 'package:inventory_v1/domain/repositories/authentication_repository.dart';
import 'package:logging/logging.dart';

class UpdateUserViewRightsUsecase
    implements UseCase<void, UpdateUserViewRightsParams> {
  final AuthenticationRepository authenticationRepository;
  final Logger _logger = Logger('UpdateUserViewRightsUsecase');

  UpdateUserViewRightsUsecase({required this.authenticationRepository});

  @override
  Future<Either<Failure, void>> call(UpdateUserViewRightsParams params) async {
    _logger.info(
        'Attempting to update view rights for user: ${params.userToUpdate.username}');
    List<ViewRightsEnum> updatedRights = params.newViewRights.toList();
    // Ensure the requesting user is an admin
    if (!params.requestingUser.viewRights.contains(ViewRightsEnum.admin)) {
      _logger.warning(
          'Non-admin user ${params.requestingUser.username} attempted to update view rights');
      return const Left(AuthenticationFailure(
          errorMessage: "Only admins can update view rights."));
    }

    // Prevent removing admin rights from another admin
    if (params.userToUpdate.viewRights.contains(ViewRightsEnum.admin) &&
        !params.newViewRights.contains(ViewRightsEnum.admin)) {
      _logger.warning(
          'Attempted to remove admin rights from user: ${params.userToUpdate.username}');
      return const Left(UpdateDataFailure(
          errMsg: "Cannot remove admin rights from another admin."));
    }

    // // If granting admin rights, ensure it's the only right
    // if (params.newViewRights.contains(ViewRightsEnum.admin)) {
    //   updatedRights = [ViewRightsEnum.admin];
    //   _logger.info(
    //       'Granting admin rights to user: ${params.userToUpdate.username}. All other rights removed.');
    // }

    // Proceed with updating the user's view rights
    var result = await authenticationRepository
        .updateUser(params.userToUpdate.copyWith(viewRights: updatedRights));

    return result.fold(
      (failure) {
        _logger.severe(
            'Failed to update view rights for user: ${params.userToUpdate.username}',
            failure);
        return Left(failure);
      },
      (_) {
        _logger.info(
            'Successfully updated view rights for user: ${params.userToUpdate.username}');
        return const Right(null);
      },
    );
  }
}

class UpdateUserViewRightsParams extends Equatable {
  const UpdateUserViewRightsParams({
    required this.requestingUser,
    required this.userToUpdate,
    required this.newViewRights,
  });
  final UserEntity requestingUser;
  final UserEntity userToUpdate;
  final List<ViewRightsEnum> newViewRights;

  @override
  List<Object> get props => [requestingUser, userToUpdate, newViewRights];
}
