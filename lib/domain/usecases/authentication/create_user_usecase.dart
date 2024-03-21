import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/core/util/rank_enum.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';
import 'package:inventory_v1/domain/repositories/authentication_repository.dart';
import 'package:logging/logging.dart';

class CreateUserUsecase implements UseCase<void, CreateUserParams> {
  CreateUserUsecase(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        _logger = Logger('create-user-usecase');
  final AuthenticationRepository _authenticationRepository;
  final Logger _logger;

  @override
  Future<Either<Failure, void>> call(CreateUserParams params) async {
    var results = await _authenticationRepository.getUsers();
    var users = results.getOrElse(() => [params.userEntity]);

    var updatedUser = params.userEntity.copyWith(
        username:
            '${params.userEntity.firstName}.${params.userEntity.lastName}');
    if (users.isEmpty) {
      updatedUser = updatedUser.copyWith(viewRights: [
        ViewRightsEnum.admin,
        ViewRightsEnum.orders,
        ViewRightsEnum.parts,
        ViewRightsEnum.verify
      ]);
    }
    _logger.finest(
        'updated username for ${params.userEntity.rank.enumToString()}- ${params.userEntity.lastName} to ${updatedUser.username}');
    return await _authenticationRepository.createUser(updatedUser);
  }
}

class CreateUserParams extends Equatable {
  const CreateUserParams({required this.userEntity});
  final UserEntity userEntity;

  @override
  List<Object?> get props => [userEntity];
}
