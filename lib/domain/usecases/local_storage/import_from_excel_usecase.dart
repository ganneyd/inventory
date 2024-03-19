import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/data/models/checked-out/checked_out_model.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/data/models/part_order/part_order_model.dart';
import 'package:inventory_v1/domain/repositories/local_storage_repository.dart';

class ImportFromExcelUsecase implements UseCase<String, ImportFromExcelParams> {
  const ImportFromExcelUsecase(LocalStorage localStorage, Box<PartModel> box,
      Box<CheckedOutModel> checkoutBox, Box<OrderModel> orderBox)
      : _localStorage = localStorage;
  final LocalStorage _localStorage;
  @override
  Future<Either<Failure, String>> call(ImportFromExcelParams params) async {
    return _localStorage.readFromExcel(
      params.path,
    );
  }
}

class ImportFromExcelParams extends Equatable {
  const ImportFromExcelParams({required this.path});
  final String path;

  @override
  List<Object?> get props => [path];
}
