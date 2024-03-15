import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/repositories/local_storage_repository.dart';

class ImportFromExcelUsecase implements UseCase<void, ImportFromExcelParams> {
  const ImportFromExcelUsecase(LocalStorage localStorage, Box<PartModel> box)
      : _localStorage = localStorage,
        _box = box;
  final LocalStorage _localStorage;
  final Box<PartModel> _box;
  @override
  Future<Either<Failure, void>> call(ImportFromExcelParams params) {
    return _localStorage.readFromExcel(params.path, _box);
  }
}

class ImportFromExcelParams extends Equatable {
  const ImportFromExcelParams({required this.path});
  final String path;

  @override
  List<Object?> get props => [path];
}
