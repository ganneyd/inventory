import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/repositories/local_storage_repository.dart';

class ExportToExcelUsecase implements UseCase<void, ExportToExcelParams> {
  const ExportToExcelUsecase({required LocalStorage localStorage})
      : _localStorage = localStorage;
  final LocalStorage _localStorage;
  @override
  Future<Either<Failure, void>> call(ExportToExcelParams params) {
    return _localStorage.saveToExcel(params.path);
  }
}

class ExportToExcelParams extends Equatable {
  const ExportToExcelParams({required this.path});
  final String path;

  @override
  List<Object?> get props => [path];
}
