import 'package:dartz/dartz.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';
import 'package:inventory_v1/domain/repositories/authentication_repository.dart';
import 'package:logging/logging.dart';

class GetUsersUsecase implements UseCase<List<UserEntity>, NoParams> {
  GetUsersUsecase({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        _logger = Logger('get-users-usecase');
  final AuthenticationRepository _authenticationRepository;
  final Logger _logger;

  @override
  Future<Either<Failure, List<UserEntity>>> call(NoParams params) async {
    _logger.info('Attempting to fetch all users');
    var result = await _authenticationRepository.getUsers();
    result.fold(
      (l) => _logger.warning('Failed to fetch users: ${l.toString()}'),
      (r) => _logger.info('Successfully fetched ${r.length} users'),
    );
    return result;
  }
}
