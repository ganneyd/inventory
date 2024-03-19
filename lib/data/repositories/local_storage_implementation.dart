import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:excel/excel.dart';
import 'package:inventory_v1/core/error/exceptions.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/util/main_section_enum.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/data/models/checked-out/checked_out_model.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/data/models/part_order/part_order_model.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:inventory_v1/domain/repositories/local_storage_repository.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:logging/logging.dart';

class LocalStorageImplementation extends LocalStorage {
  LocalStorageImplementation(
      {required PartRepository partRepository,
      required PartOrderRepository partOrderRepository,
      required CheckedOutPartRepository checkedOutPartRepository})
      : _partRepository = partRepository,
        _checkedOutPartRepository = checkedOutPartRepository,
        _orderRepository = partOrderRepository,
        _logger = Logger('local-storage');

  final Logger _logger;
  final PartRepository _partRepository;
  final PartOrderRepository _orderRepository;
  final CheckedOutPartRepository _checkedOutPartRepository;
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
      for (var part in _partRepository.getValues()) {
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
      Sheet orderPartsSheet = excel['PART ORDERS'];
      List<CellValue> checkedOutPartsHeader = const [
        TextCellValue('ORDER NO'),
        TextCellValue('PART INDEX'),
        TextCellValue('PART NSN'),
        TextCellValue('ORDER AMOUNT'),
        TextCellValue('ORDER DATE'),
        TextCellValue('FULFILLED'),
        TextCellValue('FULFILLMENT DATE'),
      ];
      orderPartsSheet.appendRow(checkedOutPartsHeader);
      for (var part in _orderRepository.getValues()) {
        var partNsn = 'not_found';

        var results = _partRepository.getSpecificPart(part.partEntityIndex);
        if (results.isLeft()) {
          continue;
        }

        results.fold((l) => null, (part) => partNsn = part.nsn);
        var row = [
          TextCellValue(part.index.toString()),
          TextCellValue(part.partEntityIndex.toString()),
          TextCellValue(partNsn),
          TextCellValue(part.orderAmount.toString()),
          TextCellValue(part.orderDate.toString()),
          TextCellValue(part.isFulfilled ? 'YES' : 'NO'),
          TextCellValue(part.fulfillmentDate.toString()),
        ];
        orderPartsSheet.appendRow(row);
      }
      Sheet checkedOutPartsSheet = excel['CHECKED OUT PARTS'];
      List<CellValue> orderPartsHeader = const [
        TextCellValue('INDEX/SERIAL'),
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

      for (var part in _checkedOutPartRepository.getValues()) {
        var partNsn = 'not_found';

        var results = _partRepository.getSpecificPart(part.partEntityIndex);
        if (results.isLeft()) {
          continue;
        }

        results.fold((l) => null, (part) => partNsn = part.nsn);

        var row = [
          TextCellValue(part.index.toString()),
          TextCellValue(part.checkedOutQuantity.toString()),
          TextCellValue(part.dateTime.toString()),
          TextCellValue(part.partEntityIndex.toString()),
          TextCellValue(partNsn),
          TextCellValue((part.isVerified ?? false) ? 'YES' : 'NO'),
          TextCellValue(part.verifiedDate.toString()),
          TextCellValue(part.quantityDiscrepancy.toString()),
          TextCellValue(part.aircraftTailNumber.toString()),
          TextCellValue(part.checkoutUser),
          TextCellValue(part.section.toString()),
          TextCellValue(part.taskName)
        ];
        checkedOutPartsSheet.appendRow(row);
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
    String path,
  ) async {
    try {
      _logger.finest('reading from excel from $path');
      var bytes = File(path).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      int newPartsCount = -401;
      int ordersAdded = -1;
      int checkedOutPartsAdded = -1;
      if (excel.sheets.keys.contains('PARTS')) {
        var results = await _partRepository.getDatabaseLength();
        newPartsCount = results.getOrElse(
          () => 0,
        );
        await _addPartsToBox(excel.sheets['PARTS']!);
        results = await _partRepository.getDatabaseLength();
        newPartsCount = results.getOrElse(
              () => 0,
            ) -
            newPartsCount;
      } else {
        _logger.warning('first sheet does not exist');
        throw Exception();
      }

      if (excel.sheets.keys.contains('CHECKED OUT PARTS')) {
        Sheet? sheet = excel['CHECKED OUT PARTS'];

        checkedOutPartsAdded = await _addCheckedOutPartsToBox(sheet);
      }
      if (excel.sheets.keys.contains('PART ORDERS')) {
        Sheet? sheet = excel['PART ORDERS'];

        ordersAdded = await _addOrdersToBox(sheet);
      }
      _logger.finest(
          'added  $newPartsCount new parts, $checkedOutPartsAdded checked out parts, $ordersAdded orders ');
      return Right<Failure, String>((newPartsCount).toString());
    } catch (e) {
      _logger.warning("exception occurred when reading from excel $e");
      return const Left<Failure, String>(CreateDataFailure());
    }
  }

  Future<void> _addPartsToBox(Sheet sheet) async {
    bool firstIteration = true;

    for (var row in sheet.rows) {
      if (firstIteration) {
        firstIteration = false;
        continue;
      }
      var part = PartModel(
          index: 0,
          nsn: (row[0]?.value as CellValue).toString(),
          name: (row[1]?.value as CellValue).toString(),
          partNumber: (row[2]?.value as CellValue).toString(),
          serialNumber: (row[3]?.value as CellValue).toString(),
          quantity: int.tryParse((row[4]?.value as CellValue).toString()) ?? 0,
          unitOfIssue: UnitOfIssueExtension.fromDisplayValue(
              (row[5]?.value as CellValue).toString()),
          location: (row[6]?.value as CellValue).toString(),
          requisitionQuantity:
              int.tryParse((row[7]?.value as CellValue).toString()) ?? 0,
          requisitionPoint:
              int.tryParse((row[8]?.value as CellValue).toString()) ?? 0,
          checksum: 0,
          isDiscontinued:
              (row[9]?.value as CellValue).toString().toLowerCase() == 'yes'
                  ? true
                  : false);
      await _partRepository.createPart(part);
    }
  }

  Future<int> _addCheckedOutPartsToBox(Sheet sheet) async {
    bool firstIteration = true;
    int initialCount = 0;

    for (var row in sheet.rows) {
      if (firstIteration) {
        firstIteration = false;
        continue;
      }
      int partIndex = 0;
      var results = await _partRepository.searchPartsByField(
          fieldName: PartField.nsn,
          queryKey: (row[4]?.value as CellValue).toString());
      if (results.isLeft()) {
        continue;
      }
      if (results.getOrElse(() => []).isEmpty) {
        continue;
      }
      results.fold((l) {}, (parts) {
        partIndex = parts.first.index;
      });
      var checkedOutPart = CheckedOutModel(
          indexModel:
              int.tryParse((row[0]?.value as CellValue).toString()) ?? -1,
          checkedOutAmount:
              int.tryParse((row[1]?.value as CellValue).toString()) ?? 0,
          dateTimeModel:
              DateTime.tryParse((row[2]?.value as CellValue).toString()) ??
                  DateTime.now(),
          partModelIndex: partIndex,
          isVerifiedModel:
              (row[5]?.value as CellValue).toString().toLowerCase() == 'yes'
                  ? true
                  : false,
          verifiedDateModel:
              DateTime.tryParse((row[6]?.value as CellValue).toString()) ??
                  DateTime.now(),
          quantityDiscrepancyModel:
              int.tryParse((row[7]?.value as CellValue).toString()) ?? 0,
          aircraftTailNumberModel: (row[8]?.value as CellValue).toString(),
          checkoutUserModel: (row[9]?.value as CellValue).toString(),
          sectionModel: MaintenanceSectionExtension.fromDisplayValue(
              (row[10]?.value as CellValue).toString()),
          taskNameModel: (row[11]?.value as CellValue).toString());
      await _checkedOutPartRepository.createCheckOut(checkedOutPart);
      initialCount++;
    }

    return initialCount;
  }

  Future<int> _addOrdersToBox(
    Sheet sheet,
  ) async {
    bool firstIteration = true;
    int initialCount = 0;

    for (var row in sheet.rows) {
      if (firstIteration) {
        firstIteration = false;
        continue;
      }

      int updatedPartIndex = 0;
      var results = await _partRepository.searchPartsByField(
          fieldName: PartField.nsn,
          queryKey: (row[2]?.value as CellValue).toString());
      if (results.isLeft()) {
        continue;
      }

      if (results.getOrElse(() => []).isEmpty) {
        continue;
      }
      results.fold((l) {}, (parts) {
        updatedPartIndex = parts.first.index;
      });
      var partOrder = OrderModel(
        indexModel: 0,
        partModelIndex: updatedPartIndex,
        orderAmountModel:
            int.tryParse((row[3]?.value as CellValue).toString()) ?? 0,
        orderDateModel:
            DateTime.tryParse((row[4]?.value as CellValue).toString()) ??
                DateTime.now(),
        isFulfilledModel:
            (row[5]?.value as CellValue).toString().toLowerCase() == 'yes'
                ? true
                : false,
        fulfillmentDateModel:
            DateTime.tryParse((row[6]?.value as CellValue).toString()) ??
                DateTime.now(),
      );
      _orderRepository.createPartOrder(partOrder);
    }
    return initialCount;
  }

  @override
  Future<Either<Failure, void>> clearDatabase() async {
    try {
      var directory = await _getDesktopPath();
      await saveToExcel(
          '$directory/inventory_files/lastResort${DateTime.now()}.xlsx');
      var results = await _partRepository.clearParts();
      if (results.isRight()) {
        await _orderRepository.clearParts();
        await _checkedOutPartRepository.clearParts();
      } else {
        _logger.warning('unable to clear the part database');
        throw DeleteDataException();
      }

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
