// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/data/repositories/part_repository_implementation.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/dependency_check/cubit/dependency_check_state.dart';
import 'package:inventory_v1/service_locator.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class DependencyCheckCubit extends Cubit<DependencyCheckState> {
  DependencyCheckCubit()
      : _dependencyCubitLogger = Logger('dependency cubit'),
        super(DependencyCheckState()) {
    checkDependencies();
  }
  final Logger _dependencyCubitLogger;
  Logger getLogger() => _dependencyCubitLogger;
  Future<void> checkDependencies() async {
    await Future.delayed(const Duration(seconds: 1));
    _dependencyCubitLogger.finest('checking if dependencies are good');
    String errorMsg = 'These dependencies were not initialized properly ';
    bool isInit = await _isPathAccessible();

    if (!isInit) {
      errorMsg += 'Service Locator Or Path not Accessible, ';
    }
    //perform checks for Hive initialization
    bool isHiveInitialized = Hive.isBoxOpen(boxName);
    if (!isHiveInitialized) {
      _dependencyCubitLogger.warning('hive is a no go $isHiveInitialized');
      errorMsg += 'Hive, ';
    }

    //Perform checks to for Part Repository initialization
    bool isPartRepositoryInitialized = _isPartRepositoryInitialized();

    if (!isPartRepositoryInitialized) {
      _dependencyCubitLogger.warning('part repo is a no go');
      errorMsg += 'Part Repository, ';
    }

    bool isUsecasesInitialized = _isUsecasesInitialized();
    //Perform checks for Usecases
    if (!_isUsecasesInitialized()) {
      _dependencyCubitLogger.warning('usecases is a no go');
      errorMsg += 'One or More Usecases, ';
    }

    if (!isUsecasesInitialized ||
        !isHiveInitialized ||
        !isPartRepositoryInitialized) {
      emit(DependencyCheckState(
          error: errorMsg,
          dependencyCheckStateStatus:
              DependencyCheckStateStatus.loadedUnsuccessfully));
    } else {
      _dependencyCubitLogger.finest('success loading dependencies');
      emit(DependencyCheckState(
          error: '',
          dependencyCheckStateStatus:
              DependencyCheckStateStatus.loadedSuccessfully));
    }
  }
}

bool _isPartRepositoryInitialized() {
  try {
    PartRepositoryImplementation partRepository =
        locator<PartRepositoryImplementation>();

    return true;
  } catch (e) {
    return false;
  }
}

bool _isUsecasesInitialized() {
  try {
    AddPartUsecase usecase = locator<AddPartUsecase>();
    DeletePartUsecase usecase1 = locator<DeletePartUsecase>();
    EditPartUsecase usecase2 = locator<EditPartUsecase>();
    GetAllPartsUsecase usecase3 = locator<GetAllPartsUsecase>();
    GetPartByNameUseCase usecase4 = locator<GetPartByNameUseCase>();
    GetPartByNameUseCase usecase5 = locator<GetPartByNameUseCase>();
    GetPartByNsnUseCase usecase6 = locator<GetPartByNsnUseCase>();
    GetPartByPartNumberUsecase usecase7 = locator<GetPartByPartNumberUsecase>();
    GetPartBySerialNumberUsecase usecase8 =
        locator<GetPartBySerialNumberUsecase>();
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
