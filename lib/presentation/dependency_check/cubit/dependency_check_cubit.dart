import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:inventory_v1/data/repositories/part_repository_implementation.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/dependency_check/cubit/dependency_check_state.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class DependencyCheckCubit extends Cubit<DependencyCheckState> {
  DependencyCheckCubit({
    required this.isHiveInitialized,
    required this.sl,
  })  : _dependencyCubitLogger = Logger('dependency cubit'),
        super(DependencyCheckState()) {
    checkDependencies();
  }
  final bool isHiveInitialized;
  final Logger _dependencyCubitLogger;
  final GetIt sl;
  Logger getLogger() => _dependencyCubitLogger;

  ///Attempts to either retrieve/create or check that dependencies exists or can be accessed
  Future<void> checkDependencies() async {
    await Future.delayed(const Duration(seconds: 1));
    _dependencyCubitLogger.finest('checking if dependencies are good');

    bool isInit = await _isPathAccessible();

    if (isInit) {
      emit(state.copyWith(isPathAccessible: true));
    } else {
      _dependencyCubitLogger.warning('path  is not accessible');
    }
    //perform checks for Hive initialization

    if (isHiveInitialized) {
      emit(state.copyWith(isHiveOpen: true));
    } else {
      _dependencyCubitLogger.warning('hive is a no go $isHiveInitialized');
    }

    //Perform checks to for Part Repository initialization

    if (_isPartRepositoryInitialized()) {
      emit(state.copyWith(isPartRepoInit: true));
    } else {
      _dependencyCubitLogger.warning('part repo is a no go');
    }

    //Perform checks for Usecases
    if (_isUsecasesInitialized()) {
      emit(state.copyWith(isUsecasesInit: true));
    } else {
      _dependencyCubitLogger.warning('usecases is a no go');
    }
//check if one or more dependency was able to be accessed or opened and emit the proper state
    if (state.isPathAccessible ||
        !state.isHiveOpen ||
        !state.isPartRepoInit ||
        !state.isUsecasesInit) {
      emit(DependencyCheckState(
          dependencyCheckStateStatus:
              DependencyCheckStateStatus.loadedUnsuccessfully));
    } else {
      _dependencyCubitLogger.finest('success loading dependencies');
      emit(DependencyCheckState(
          dependencyCheckStateStatus:
              DependencyCheckStateStatus.loadedSuccessfully));
    }
  }

  bool _isPartRepositoryInitialized() {
    try {
      sl<PartRepositoryImplementation>();

      return true;
    } catch (e) {
      return false;
    }
  }

  bool _isUsecasesInitialized() {
    try {
      sl<AddPartUsecase>();
      sl<DeletePartUsecase>();
      sl<EditPartUsecase>();
      sl<GetAllPartsUsecase>();
      sl<GetPartByNameUseCase>();
      sl<GetPartByNameUseCase>();
      sl<GetPartByNsnUseCase>();
      sl<GetPartByPartNumberUsecase>();
      sl<GetPartBySerialNumberUsecase>();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _isPathAccessible() async {
    try {
      Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
      String path = appDocumentDirectory.path;
      return true;
    } catch (e) {
      return false;
    }
  }
}
