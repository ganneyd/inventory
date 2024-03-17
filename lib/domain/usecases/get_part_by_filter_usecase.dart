import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';

class GetPartByFilterUsecase
    implements UseCase<List<PartEntity>, GetPartByFilterParams> {
  @override
  Future<Either<Failure, List<PartEntity>>> call(GetPartByFilterParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class GetPartByFilterParams extends Equatable {
  final String? nsnQuery;
  final String? partNumberQuery;
  final String? partNameQuery;

  const GetPartByFilterParams(
      {this.nsnQuery, this.partNumberQuery, this.partNameQuery});

  @override
  List<Object?> get props => [nsnQuery, partNameQuery, partNameQuery];
}
