import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/core/util/rank_enum.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/domain/repositories/authentication_repository.dart';
import 'package:logging/logging.dart';

class ExportUsersUsecase implements UseCase<Sheet, ExportUsersParams> {
  ExportUsersUsecase({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        _logger = Logger('export-users-usecase');
  final AuthenticationRepository _authenticationRepository;
  final Logger _logger;

  @override
  Future<Either<Failure, Sheet>> call(ExportUsersParams params) async {
    var userSheet = params.excel['PARTS'];

    List<CellValue> header = const [
      TextCellValue('FIRST NAME'),
      TextCellValue('LAST NAME'),
      TextCellValue('RANK'),
      TextCellValue('USERNAME'),
      // Remove PASSWORD for security reasons,
      TextCellValue('VIEW RIGHTS'),
    ];
    userSheet.appendRow(header);

    var results = await _authenticationRepository.getUsers();
    return results.fold((failure) => Left<Failure, Sheet>(failure), (users) {
      for (var user in users) {
        var viewRightsAsString =
            user.viewRights.map((vr) => vr.enumToString()).join(',');
        var row = <CellValue>[
          TextCellValue(user.firstName),
          TextCellValue(user.lastName),
          TextCellValue(user.rank.enumToString()),
          TextCellValue(user.username),
          TextCellValue(user.password),
          TextCellValue(viewRightsAsString),
        ];
        userSheet.appendRow(row);
      }
      _logger.info('Exported ${userSheet.rows.length - 1} users');
      return Right(userSheet);
    });
  }
}

class ExportUsersParams extends Equatable {
  const ExportUsersParams({required this.excel});
  final Excel excel;

  @override
  List<Object?> get props => [excel];
}
