import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:logging/logging.dart';

import '../../core/error/exceptions.dart';

class PartRepositoryImplementation extends PartRepository {
  PartRepositoryImplementation(Box<PartModel> localDataSource)
      : _localDataSource = localDataSource,
        _logger = Logger('part-repo');

  final Box<PartModel> _localDataSource;
  final Logger _logger;

  @override
  Future<Either<Failure, void>> createPart(PartEntity partEntity) async {
    try {
      var index = _localDataSource.isEmpty ? 0 : _localDataSource.length;

      var addPart = PartEntityToModelAdapter.fromEntity(partEntity);
      addPart = addPart.copyWith(index: index);
      bool partExist = _localDataSource.values
          .where((element) => element == addPart)
          .isNotEmpty;
      if (!partExist) {
        await _localDataSource.add(addPart);
      } else {
        _logger.finest('part exists');
      }

      return const Right<Failure, void>(null);
    } on CreateDataException {
      return const Left<Failure, void>(CreateDataFailure());
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
      _logger.finest(partEntity.isDiscontinued);
      var updatePart =
          PartEntityToModelAdapter.fromEntity(partEntity.updateChecksum());
      _logger.finest(
          'updating part with index ${updatePart.index} is discontinued is ${updatePart.isDiscontinued}');
      return Right<Failure, void>(
          await _localDataSource.putAt(partEntity.index, updatePart));
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
      return const Left<Failure, List<PartEntity>>(IndexOutOfBoundsFailure());
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

  @override
  Either<Failure, PartEntity> getSpecificPart(int index) {
    try {
      if (index < 0) {
        throw IndexOutOfBounds();
      }
      var result = _localDataSource.getAt(index);
      return Right<Failure, PartEntity>(result!);
    } on IndexOutOfBounds {
      return const Left<Failure, PartEntity>(IndexOutOfBoundsFailure());
    } catch (e) {
      return const Left<Failure, PartEntity>(ReadDataFailure());
    }
  }

  @override
  Iterable<PartEntity> getValues() {
    return _localDataSource.values;
  }

  @override
  Future<Either<Failure, void>> clearParts() async {
    try {
      _localDataSource.clear();
      _logger.info('cleared database length is ${_localDataSource.length}');
      return const Right<Failure, void>(null);
    } catch (e) {
      return const Left<Failure, void>(DeleteDataFailure());
    }
  }
}
