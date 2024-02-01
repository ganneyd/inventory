import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';

class DeletePartUsecase implements UseCase<void, DeletePartParams> {
  const DeletePartUsecase(PartRepository partRepository)
      : _partRepository = partRepository;

  final PartRepository _partRepository;
  @override
  Future<Either<Failure, void>> call(DeletePartParams params) {
    return _partRepository.deletePart(params.partEntity);
  }
}

class DeletePartParams extends Equatable {
  const DeletePartParams({required this.partEntity});

  final PartEntity partEntity;

  @override
  List<Object?> get props => <Object>[partEntity];
}
