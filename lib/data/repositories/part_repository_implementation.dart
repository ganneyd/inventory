import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:logging/logging.dart';

import '../../core/error/exceptions.dart';

class PartRepositoryImplementation extends PartRepository {
  PartRepositoryImplementation(Box<PartEntity> localDataSource)
      : _localDataSource = localDataSource,
        _logger = Logger('part-repo');

  final Box<PartEntity> _localDataSource;
  final Logger _logger;

  PartEntity _getPartWithIndex(
      {required int index, required PartEntity partEntity}) {
    return PartEntity(
        index: index,
        name: partEntity.name,
        nsn: partEntity.nsn,
        partNumber: partEntity.partNumber,
        location: partEntity.location,
        quantity: partEntity.quantity,
        requisitionPoint: partEntity.requisitionPoint,
        requisitionQuantity: partEntity.requisitionQuantity,
        serialNumber: partEntity.serialNumber,
        unitOfIssue: partEntity.unitOfIssue);
  }

  @override
  Future<Either<Failure, void>> createPart(PartEntity partEntity) async {
    try {
      _logger.finest('setting partEntity index');
      var index = _localDataSource.isEmpty ? 0 : _localDataSource.length;
      _logger.finest('index is $index');

      await _localDataSource
          .add(_getPartWithIndex(index: index, partEntity: partEntity));
      _logger.finest('index set');
      return const Right<Failure, void>(null);
    } on CreateDataException {
      return Left<Failure, void>(CreateDataFailure());
    } catch (e) {
      return Left<Failure, void>(CreateDataFailure(errMsg: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePart(PartEntity partEntity) async {
    try {
      return Right<Failure, void>(
          await _localDataSource.delete(partEntity.index));
    } on DeleteDataException {
      return const Left<Failure, void>(DeleteDataFailure());
    } catch (e) {
      return const Left<Failure, void>(DeleteDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> editPart(PartEntity partEntity) async {
    try {
      return Right<Failure, void>(
          await _localDataSource.putAt(partEntity.index, partEntity));
    } on UpdateDataException {
      return const Left<Failure, void>(UpdateDataFailure());
    } catch (e) {
      return const Left<Failure, void>(UpdateDataFailure());
    }
  }

  @override
  Future<Either<Failure, List<PartEntity>>> getAllParts(
      int startIndex, int pageIndex) async {
    try {
      var upperBound = _localDataSource.length;
      var lowerBound = startIndex < 0 ? 0 : startIndex;

      if (pageIndex < upperBound) {
        upperBound = pageIndex + 1;
      }
      _logger.finest(
          'getting all parts lowerBound is $lowerBound and upperBound is $upperBound');
      if (upperBound < lowerBound) {
        _logger.severe(
            'upperBound is less than lowerBound, throwing exception... ');
        throw IndexOutOfBounds();
      }

      List<PartEntity> parts = [];
      for (int i = lowerBound; i < upperBound; i++) {
        var part = _localDataSource.getAt(i);
        if (part != null) {
          parts.add(part);
        }
      }
      _logger.finest('got ${parts.length} parts from database');
      return Right<Failure, List<PartEntity>>(parts);
    } on ReadDataException {
      _logger.warning('ReadDataFailure() occurred');
      return const Left<Failure, List<PartEntity>>(ReadDataFailure());
    } on IndexOutOfBounds {
      _logger.warning('ReadDataFailure() occurred');
      return Left<Failure, List<PartEntity>>(OutOfBoundsFailure());
    } catch (e) {
      _logger.severe('Unknown exception occurred  $e', [e.runtimeType]);
      return const Left<Failure, List<PartEntity>>(GetFailure());
    }
  }

  String _cleanKey(String key) {
    // Create a new string 'cleanKey' by removing all non-alphanumeric characters from 'key'
    // This is done using a regular expression that matches any character that is NOT a letter (a-zA-Z) or a number (0-9)
    // The 'r' before the string indicates a raw string, which treats backslashes as literal characters
    var cleanKey = key.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    // Return the sanitized 'cleanKey' string
    return cleanKey;
  }

  String _removeNumbers(String input) {
    // Use a regular expression to match and remove all digits (0-9) from the input string
    // The 'r' before the string indicates a raw string, which treats backslashes as literal characters
    // '[0-9]' is a character class that matches any digit between 0 and 9
    // The 'replaceAll' function replaces all substrings that match the pattern with an empty string, effectively removing them
    String result = input.replaceAll(RegExp(r'[0-9]'), '');
    return result; // Return the modified string with digits removed, leaving only letters and possibly other characters
  }

  String _removeLetters(String input) {
    // Use a regular expression to match and remove all letters (both lowercase and uppercase) from the input string
    // The regular expression '[a-zA-Z]' matches any character in the ranges 'a-z' or 'A-Z', which includes all lowercase and uppercase letters
    // The 'replaceAll' function replaces all substrings that match the pattern (letters in this case) with an empty string, effectively removing them
    String result = input.replaceAll(RegExp(r'[a-zA-Z]'), '');
    return result; // Return the modified string with letters removed, leaving only digits and possibly other non-letter characters
  }

  @override
  Future<Either<Failure, List<PartEntity>>> searchPartsByField(
      {required PartField fieldName, required String queryKey}) async {
    try {
      List<PartEntity> parts = [];

      if (!_localDataSource.containsKey(fieldName)) {
        _logger.warning('error encountered  querying the dataset');
        throw ReadDataException();
      }
      final String cleanQuery = _cleanKey(queryKey);
      _logger.finest('searching for $queryKey in database');
      parts = _localDataSource.values.where((data) {
        switch (fieldName) {
          case PartField.name:
            var searchKey =
                _removeNumbers(_removeNumbers(cleanQuery.toLowerCase()));
            if (searchKey == '') {
              return false;
            }
            return _cleanKey(data.name.toLowerCase()).contains(searchKey);
          case PartField.nsn:
            var searchKey = _removeLetters(cleanQuery);
            if (searchKey == '') {
              return false;
            }
            return _cleanKey(data.nsn).contains(searchKey);
          case PartField.partNumber:
            return _cleanKey(data.partNumber.toLowerCase())
                .contains(cleanQuery.toLowerCase());
          case PartField.serialNumber:
            return _cleanKey(data.serialNumber.toLowerCase())
                .contains(cleanQuery.toLowerCase());
          default:
            return false;
        }
      }).toList();

      return Right<Failure, List<PartEntity>>(parts);
    } on ReadDataFailure {
      return const Left<Failure, List<PartEntity>>(ReadDataFailure());
    } catch (e) {
      return const Left<Failure, List<PartEntity>>(ReadDataFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getDatabaseLength() async {
    try {
      var length = _localDataSource.length;
      _logger.finest('retrieved database length and it is $length');
      return Right<Failure, int>(length);
    } catch (e) {
      return const Left<Failure, int>(ReadDataFailure());
    }
  }
}
