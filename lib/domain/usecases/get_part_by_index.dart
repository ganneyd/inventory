import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';

class GetPartByIndexUsecase {
  const GetPartByIndexUsecase(PartRepository partRepository)
      : _partRepository = partRepository;
  final PartRepository _partRepository;

  Either<Failure, PartEntity> call(GetPartByIndexParams params) {
    return _partRepository.getSpecificPart(params.index);
  }
}

class GetPartByIndexParams extends Equatable {
  const GetPartByIndexParams({required this.index});
  final int index;

  @override
  List<Object?> get props => [index];
}
