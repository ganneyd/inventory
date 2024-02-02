import 'package:dartz/dartz.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';

class GetDatabaseLength extends UseCase<int, NoParams> {
  GetDatabaseLength(this._partRepository);

  final PartRepository _partRepository;

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return _partRepository.getDatabaseLength();
  }
}
