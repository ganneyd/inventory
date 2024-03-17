import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:excel/excel.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/data/models/checked-out/checked_out_model.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/data/models/part_order/part_order_model.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/local_storage_repository.dart';
import 'package:logging/logging.dart';

class LocalStorageImplementation extends LocalStorage {
  LocalStorageImplementation({required Box<PartModel> box})
      : _hiveBox = box,
        _logger = Logger('local-storage');

  final Logger _logger;
  final Box<PartModel> _hiveBox;
  final String boxName = 'parts_json';
  final String checkoutPartBox = 'checkout_parts';
  final String partOrdersBox = 'part_orders';
  @override
  Future<Either<Failure, void>> saveToExcel(String path) async {
    try {
      _logger.finest('exporting database to excel file at $path');
      var excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];
      List<CellValue> rowHeader = const [
        TextCellValue('NSN'),
        TextCellValue('NAME'),
        TextCellValue('PART NUMBER'),
        TextCellValue('SERIAL NUMBER'),
        TextCellValue('QUANTITY'),
        TextCellValue('UNIT OF ISSUE'),
        TextCellValue('LOCATION'),
        TextCellValue('REQUISITION QUANTITY'),
        TextCellValue('REQUISITION POINT'),
        TextCellValue('DISCONTINUED'),
      ];
      sheet.appendRow(rowHeader);
      for (var part in _hiveBox.values) {
        _logger.finest(
            'part quantity is ${part.quantity} as int cell value is ${IntCellValue(part.quantity).value}rq is ${part.requisitionQuantity} part rp is ${part.requisitionPoint}');
        var row = [
          TextCellValue(part.nsn),
          TextCellValue(part.name),
          TextCellValue(part.partNumber),
          TextCellValue(part.serialNumber),
          TextCellValue(part.quantity.toString()),
          TextCellValue(part.unitOfIssue.displayValue),
          TextCellValue(part.location),
          TextCellValue(part.requisitionQuantity.toString()),
          TextCellValue(part.requisitionPoint.toString()),
          TextCellValue(part.isDiscontinued ? 'YES' : 'NO')
        ];
        sheet.appendRow(row);
      }

      File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excel.save()!);
      _logger.finest('wrote to file');
      return const Right<Failure, void>(null);
    } catch (e) {
      _logger.warning('failed to write to file.. $e');
      return const Left<Failure, void>(CreateDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> readFromExcel(
      String path, Box<PartEntity> box) async {
    try {
      _logger.finest('reading from excel from $path');
      var bytes = File(path).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      bool firstIteration = true;

      int partIndex = box.values.length;
      int initialCount = partIndex;
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          if (firstIteration) {
            firstIteration = false;
            continue;
          }
          String nsn = (row[0]?.value as CellValue).toString();

          bool partExists = box.values.any((element) => element.nsn == nsn);
          _logger.finest('part exits[$partExists]for $nsn ');
          if (!partExists) {
            var part = PartModel(
                index: partIndex++,
                nsn: nsn,
                name: (row[1]?.value as CellValue).toString(),
                partNumber: (row[2]?.value as CellValue).toString(),
                serialNumber: (row[3]?.value as CellValue).toString(),
                quantity:
                    int.tryParse((row[4]?.value as CellValue).toString()) ?? 0,
                unitOfIssue: UnitOfIssueExtension.fromDisplayValue(
                    (row[5]?.value as CellValue).toString()),
                location: (row[6]?.value as CellValue).toString(),
                requisitionQuantity:
                    int.tryParse((row[7]?.value as CellValue).toString()) ?? 0,
                requisitionPoint:
                    int.tryParse((row[8]?.value as CellValue).toString()) ?? 0,
                checksum: 0,
                isDiscontinued:
                    (row[9]?.value as CellValue).toString().toLowerCase() ==
                            'yes'
                        ? true
                        : false);
            await box.add(part);
          }
        }
      }
      _logger.finest(
          'read from file read ${box.values.length - initialCount} new entries');
      return const Right<Failure, void>(null);
    } catch (e) {
      _logger.warning("exception occurred when reading from excel $e");
      return const Left<Failure, void>(CreateDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearDatabase() async {
    try {
      await saveToExcel('/desktop/lastResort${DateTime.now().minute}.xlsx');
      Hive.box<PartModel>(boxName).clear();
      Hive.box<CheckedOutModel>(checkoutPartBox).clear();
      Hive.box<OrderModel>(partOrdersBox).clear();
      return const Right<Failure, void>(null);
    } on Exception catch (_) {
      return const Left<Failure, void>(DeleteDataFailure());
    }
  }
}
