import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';

class GetAllPartsUsecase implements UseCase<List<Part>, GetAllPartParams> {
  const GetAllPartsUsecase(PartRepository partRepository)
      : _partRepository = partRepository;

  final PartRepository _partRepository;
  @override
  Future<Either<Failure, List<Part>>> call(GetAllPartParams params) async {
    Either<Failure, List<PartEntity>> usecase =
        await _partRepository.getAllParts(params.startIndex, params.pageIndex);

    return usecase
        .fold((l) => const Left<Failure, List<Part>>(ReadDataFailure()),
            (List<PartEntity> parts) {
      List<Part> newParts = [];
      for (var element in parts) {
        newParts.add(
          PartAdapter.fromEntity(element),
        );
      }
      return Right<Failure, List<Part>>(newParts);
    });
  }
}

class GetAllPartParams extends Equatable {
  const GetAllPartParams({required this.pageIndex, required this.startIndex});
  final int startIndex;
  final int pageIndex;
  @override
  List<Object?> get props => <Object>[startIndex, pageIndex];
}
