import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/dependency_check/cubit/dependency_check_state.dart';
import 'package:logging/logging.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class DependencyCheckCubit extends Cubit<DependencyCheckState> {
  DependencyCheckCubit({
    required this.isHiveInitialized,
    required this.sl,
    required this.pathProviderPlatform,
  })  : _dependencyCubitLogger = Logger('dependency cubit'),
        super(DependencyCheckState());

  final bool isHiveInitialized;
  final Logger _dependencyCubitLogger;
  final GetIt sl;
  final PathProviderPlatform pathProviderPlatform;
  Logger getLogger() => _dependencyCubitLogger;

  ///Attempts to either retrieve/create or check that dependencies exists or can be accessed
  Future<void> checkDependencies() async {
    //default loading
    await Future.delayed(const Duration(seconds: 1));
    //!debug
    _dependencyCubitLogger.finest('checking if dependencies are good');

    bool isInit = await _isPathAccessible();

    if (isInit) {
      emit(state.copyWith(isPathAccessible: isInit));
    } else {
      //!debug
      _dependencyCubitLogger.warning('path  is not accessible');
    }

    //perform checks for Hive initialization
    if (isHiveInitialized) {
      emit(state.copyWith(isHiveOpen: isHiveInitialized));
    } else {
      //!debug
      _dependencyCubitLogger.warning('hive is a no go $isHiveInitialized');
    }

    //Perform checks to for Part Repository initialization

    if (_isPartRepositoryInitialized()) {
      emit(state.copyWith(isPartRepoInit: true));
    } else {
      //!debug
      _dependencyCubitLogger.warning('part repo is a no go');
    }

    //Perform checks for Usecases
    if (_isUsecasesInitialized()) {
      emit(state.copyWith(isUsecasesInit: true));
    } else {
      //!debug
      _dependencyCubitLogger.warning('usecases is a no go');
    }
//check if one or more dependency was able to be accessed or opened and emit the proper state
    if (!state.isPathAccessible ||
        !state.isHiveOpen ||
        !state.isPartRepoInit ||
        !state.isUsecasesInit) {
      emit(state.copyWith(
          dependencyCheckStateStatus:
              DependencyCheckStateStatus.loadedUnsuccessfully));
    } else {
      //!debug
      _dependencyCubitLogger.finest('success loading dependencies');
      emit(state.copyWith(
          dependencyCheckStateStatus:
              DependencyCheckStateStatus.loadedSuccessfully));
    }
  }

  bool _isPartRepositoryInitialized() {
    try {
      sl<PartRepository>();

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

      sl<GetPartByNsnUseCase>();

      sl<GetPartByPartNumberUsecase>();

      sl<GetPartBySerialNumberUsecase>();

      sl<GetDatabaseLength>();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _isPathAccessible() async {
    try {
      var path = await pathProviderPlatform.getApplicationDocumentsPath();
      if (path == null) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
