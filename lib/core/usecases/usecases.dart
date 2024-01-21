import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';

///Defines the basic structure of a usecase
///takes [Params] as an argument and if not use
///the [NoParams] class to specify a usecase
///does not need any parameters
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

///Used when a usecase does not need any parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
