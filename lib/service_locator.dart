import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:inventory_v1/data/datasources/local_database.dart';
import 'package:inventory_v1/data/repositories/part_repository_implementation.dart';
import 'package:logging/logging.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';

final GetIt locator = GetIt.instance;
Logger serviceLocatorLogger = Logger('service_locator');
Future<void> initDependencies() async {
  serviceLocatorLogger = Logger('service_logga');
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  serviceLocatorLogger.finest('initializing service locator');
  await setupLocator();
}

Future<void> initHive() async {
  serviceLocatorLogger.finest('initializing HIVE');
  // Directory appDocumentDirectory;
  // try {
  //   appDocumentDirectory =
  //       await path_provider.getApplicationDocumentsDirectory();
  //   serviceLocatorLogger.finest('got application path for hive');
  // } catch (e) {
  //   serviceLocatorLogger
  //       .warning('exception getting application path  getting temp ...$e  ');
  //   appDocumentDirectory = await path_provider.getTemporaryDirectory();
  //   serviceLocatorLogger.finest('got temp path');
  // }
  await Hive.initFlutter();
  await Hive.openBox<Map<String, dynamic>>('parts');
  serviceLocatorLogger.finest('initialized hive');
}

//Initialize the service locator

Future<void> setupLocator() async {
//! Datasource

  locator.registerLazySingletonAsync<Box<Map<String, dynamic>>>(
      () async => await Hive.openBox<Map<String, dynamic>>('parts'));
  serviceLocatorLogger.finest('opened hive box');

  //!Data Layer
  //!Repositories
  locator.registerLazySingleton<LocalDataSourceImplementation>(() =>
      LocalDataSourceImplementation(Hive.box<Map<String, dynamic>>('parts')));
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
