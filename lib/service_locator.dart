import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/data/datasources/local_database.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/data/repositories/part_repository_implementation.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:logging/logging.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';

const String boxName = 'newParts';

final GetIt locator = GetIt.instance;
Logger serviceLocatorLogger = Logger('service_locator');

//initialize various dependencies
Future<void> initDependencies() async {
  serviceLocatorLogger = Logger('service_logga');
  await initHive();
  serviceLocatorLogger.finest('initializing service locator');
  await setupLocator();
}

Future<void> initHive() async {
  try {
    serviceLocatorLogger.finest('initializing HIVE');
    await Hive.initFlutter();
    Hive.registerAdapter(PartEntityAdapter());
    Hive.registerAdapter(UnitOfIssueAdapter());
    await Hive.openBox<PartEntity>(boxName);
    serviceLocatorLogger.finest('initialized hive');
  } catch (e) {
    serviceLocatorLogger.severe('Exception occurred initializing hive $e');
  }
}

//Initialize the service locator

Future<void> setupLocator() async {
//! Datasource

  if (Hive.isBoxOpen(boxName)) {
    serviceLocatorLogger.finest('opened hive box');
  }

  //!Data Layer
  //!Repositories
  locator.registerLazySingleton<LocalDataSourceImplementation>(
      () => LocalDataSourceImplementation(Hive.box<PartEntity>(boxName)));
  locator.registerLazySingleton<PartRepositoryImplementation>(() =>
      PartRepositoryImplementation(locator<LocalDataSourceImplementation>()));
  //!Usecases
  locator.registerFactory<AddPartUsecase>(
      () => AddPartUsecase(locator<PartRepositoryImplementation>()));
  locator.registerFactory<DeletePartUsecase>(
      () => DeletePartUsecase(locator<PartRepositoryImplementation>()));
  locator.registerFactory<EditPartUsecase>(
      () => EditPartUsecase(locator<PartRepositoryImplementation>()));
  locator.registerFactory<GetAllPartsUsecase>(
      () => GetAllPartsUsecase(locator<PartRepositoryImplementation>()));
  locator.registerFactory<GetPartByNameUseCase>(
      () => GetPartByNameUseCase(locator<PartRepositoryImplementation>()));
  locator.registerFactory<GetPartByNsnUseCase>(
      () => GetPartByNsnUseCase(locator<PartRepositoryImplementation>()));
  locator.registerFactory<GetPartByPartNumberUsecase>(() =>
      GetPartByPartNumberUsecase(locator<PartRepositoryImplementation>()));
  locator.registerFactory<GetPartBySerialNumberUsecase>(() =>
      GetPartBySerialNumberUsecase(locator<PartRepositoryImplementation>()));
  //!Presentation Layer
//!Pages
}
