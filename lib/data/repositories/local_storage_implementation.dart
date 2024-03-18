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
  LocalStorageImplementation(
      {required Box<PartModel> box,
      required Box<CheckedOutModel> checkoutBox,
      required Box<OrderModel> orderBox})
      : _partsBox = box,
        _checkoutPartsBox = checkoutBox,
        _orderBox = orderBox,
        _logger = Logger('local-storage');

  final Logger _logger;
  final Box<PartModel> _partsBox;
  final Box<CheckedOutModel> _checkoutPartsBox;
  final Box<OrderModel> _orderBox;
  @override
  Future<Either<Failure, void>> saveToExcel(String path) async {
    try {
      _logger.finest('exporting database to excel file at $path');
      var excel = Excel.createExcel();
      excel.sheets.clear();
      Sheet partSheet = excel['PARTS'];
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
      partSheet.appendRow(rowHeader);

      Sheet orderPartsSheet = excel['PART ORDERS'];
      List<CellValue> checkedOutPartsHeader = const [
        TextCellValue('PART INDEX'),
        TextCellValue('PART NSN'),
        TextCellValue('ORDER AMOUNT'),
        TextCellValue('ORDER DATE'),
        TextCellValue('FULFILLED'),
        TextCellValue('FULFILLMENT DATE'),
      ];
      orderPartsSheet.appendRow(checkedOutPartsHeader);

      Sheet checkedOutPartsSheet = excel['CHECKED OUT PARTS'];
      List<CellValue> orderPartsHeader = const [
        TextCellValue('CHECKED OUT AMOUNT'),
        TextCellValue('DATE CHECKED OUT'),
        TextCellValue('PART INDEX'),
        TextCellValue('PART NSN'),
        TextCellValue('VERIFIED'),
        TextCellValue('VERIFICATION DATE'),
        TextCellValue('QUANTITY DISCREPANCY'),
        TextCellValue('ACFT'),
        TextCellValue('PERSONNEL'),
        TextCellValue('SECTION'),
        TextCellValue('TASK'),
      ];
      checkedOutPartsSheet.appendRow(orderPartsHeader);

      for (var part in _checkoutPartsBox.values) {
        var row = [
          TextCellValue(part.checkedOutAmount.toString()),
          TextCellValue(part.dateTimeModel.toString()),
          TextCellValue(part.partModelIndex.toString()),
          TextCellValue(
              _partsBox.getAt(part.partModelIndex)?.nsn ?? 'not_found'),
          TextCellValue(part.isVerifiedModel ? 'YES' : 'NO'),
          TextCellValue(part.verifiedDateModel.toString()),
          TextCellValue(part.quantityDiscrepancyModel.toString()),
          TextCellValue(part.aircraftTailNumberModel.toString()),
          TextCellValue(part.checkoutUserModel),
          TextCellValue(part.sectionModel.toString()),
          TextCellValue(part.taskNameModel)
        ];
        checkedOutPartsSheet.appendRow(row);
      }

      for (var part in _partsBox.values) {
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
        partSheet.appendRow(row);
      }

      for (var part in _orderBox.values) {
        var row = [
          TextCellValue(part.partModelIndex.toString()),
          TextCellValue(_partsBox.getAt(part.partModelIndex)?.nsn ?? ''),
          TextCellValue(part.orderAmountModel.toString()),
          TextCellValue(part.orderDateModel.toString()),
          TextCellValue(part.isFulfilledModel ? 'YES' : 'NO'),
          TextCellValue(part.fulfillmentDateModel.toString()),
        ];
        orderPartsSheet.appendRow(row);
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
  Future<Either<Failure, String>> readFromExcel(
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
      return Right<Failure, String>(
          (box.values.length - initialCount).toString());
    } catch (e) {
      _logger.warning("exception occurred when reading from excel $e");
      return const Left<Failure, String>(CreateDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearDatabase() async {
    try {
      var directory = await _getDesktopPath();
      await saveToExcel(
          '$directory/inventory_files/lastResort${DateTime.now()}.xlsx');
      _partsBox.clear();
      _checkoutPartsBox.clear();
      _orderBox.clear();
      _logger.finest('wrote last resort file to $directory');
      return const Right<Failure, void>(null);
    } on Exception catch (_) {
      return const Left<Failure, void>(DeleteDataFailure());
    }
  }

  Future<String> _getDesktopPath() async {
    String desktopPath;

    if (Platform.isWindows) {
      // On Windows, the desktop is typically under USERPROFILE
      desktopPath = '${Platform.environment['USERPROFILE']!}\\Desktop';
    } else if (Platform.isMacOS) {
      // On macOS, the desktop is under the user's home directory
      desktopPath = '${Platform.environment['HOME']!}/Desktop';
    } else {
      throw Exception('Unsupported platform');
    }

    return desktopPath;
  }
}
