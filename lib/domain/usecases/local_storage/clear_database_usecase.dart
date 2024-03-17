import 'package:dartz/dartz.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/repositories/local_storage_repository.dart';

class ClearDatabaseUsecase implements UseCase<void, NoParams> {
  ClearDatabaseUsecase({required LocalStorage localStorage})
      : _localStorage = localStorage;
  final LocalStorage _localStorage;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return _localStorage.clearDatabase();
  }
}
