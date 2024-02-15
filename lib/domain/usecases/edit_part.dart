import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';

class EditPartUsecase implements UseCase<void, EditPartParams> {
  const EditPartUsecase(PartRepository partRepository)
      : _partRepository = partRepository;

  final PartRepository _partRepository;
  @override
  Future<Either<Failure, void>> call(EditPartParams params) {
    return _partRepository.editPart(params.partEntity);
  }
}

class EditPartParams extends Equatable {
  const EditPartParams({required this.partEntity});
  final PartEntity partEntity;

  @override
  List<Object?> get props => <Object>[partEntity];
}
