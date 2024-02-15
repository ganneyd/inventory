import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:inventory_v1/data/repositories/part_repository_implementation.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
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
    bool isHiveInit = false,
        isPartRepoInit = false,
        isCheckoutPartRepoInit = false,
        isUsecasesInit = false;
    if (!isInit) {
      //!debug
      _dependencyCubitLogger.warning('path  is not accessible');
    }

    //perform checks for Hive initialization
    if (isHiveInitialized) {
      isHiveInit = true;
    } else {
      //!debug
      _dependencyCubitLogger.warning('hive is a no go $isHiveInitialized');
    }

    //Perform checks to for Part Repository initialization

    if (_isPartRepositoryInitialized()) {
      isPartRepoInit = true;
    } else {
      //!debug
      _dependencyCubitLogger.warning('part repo is a no go');
    }

    //Perform checks for Checkout Part Repo

    if (_isCheckoutPartRepositoryInitialized()) {
      isCheckoutPartRepoInit = true;
    } else {
      //!debug
      _dependencyCubitLogger.warning('checkout-part repo is a no go');
    }

    //Perform checks for Usecases
    if (_isUsecasesInitialized()) {
      isUsecasesInit = true;
    } else {
      //!debug
      _dependencyCubitLogger.warning('usecases is a no go');
    }
//check if one or more dependency was able to be accessed or opened and emit the proper state
    if (!isInit ||
        !isHiveInit ||
        !isPartRepoInit ||
        !isUsecasesInit ||
        !isCheckoutPartRepoInit) {
      emit(state.copyWith(
          isHiveOpen: isHiveInit,
          isPartRepoInit: isPartRepoInit,
          isPathAccessible: isInit,
          isUsecasesInit: isUsecasesInit,
          isCheckoutPartRepoInit: isCheckoutPartRepoInit,
          dependencyCheckStateStatus:
              DependencyCheckStateStatus.loadedUnsuccessfully));
    } else {
      //!debug
      _dependencyCubitLogger.finest('success loading dependencies');
      emit(state.copyWith(
          isHiveOpen: isHiveInit,
          isPartRepoInit: isPartRepoInit,
          isPathAccessible: isInit,
          isUsecasesInit: isUsecasesInit,
          isCheckoutPartRepoInit: isCheckoutPartRepoInit,
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

  bool _isCheckoutPartRepositoryInitialized() {
    try {
      sl<CheckedOutPartRepository>();
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

      sl<AddCheckoutPart>();
      sl<GetAllCheckoutParts>();
      sl<VerifyCheckoutPart>();
      sl<GetUnverifiedCheckoutParts>();
      sl<GetLowQuantityParts>();

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
