import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/data/models/checked-out/checked_out_model.dart';
import 'package:inventory_v1/data/repositories/checked_out_part_repository_implementation.dart';
import 'package:inventory_v1/data/repositories/part_repository_implementation.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:inventory_v1/domain/usecases/checkout/verify_checkout_part.dart';
import 'package:logging/logging.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';

//name of the Hive.box that the parts data is stored in
const String boxName = 'parts_json';
const String checkoutPartBox = 'checkout_parts';
final GetIt locator = GetIt.instance;
Logger serviceLocatorLogger = Logger('service_locator');

//initialize various dependencies
Future<void> initDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  serviceLocatorLogger = Logger('service_logga');
  await initHive();
  serviceLocatorLogger.finest('initializing service locator');
  await setupLocator();
}

Future<void> initHive() async {
  serviceLocatorLogger.finest('initializing HIVE');

  await Hive.initFlutter();
  Hive.registerAdapter(PartEntityAdapter());
  Hive.registerAdapter(UnitOfIssueAdapter());
  Hive.registerAdapter(CheckedOutModelAdapter());
  await Hive.openBox<PartEntity>(boxName);
  await Hive.openBox<CheckedOutModel>(checkoutPartBox);
  serviceLocatorLogger.finest('initialized hive');
}

//Initialize the service locator

Future<void> setupLocator() async {
//! Datasource

  if (Hive.isBoxOpen(boxName)) {
    serviceLocatorLogger.finest('opened hive box');
  }

  //!Data Layer
  //!Repositories
  locator.registerLazySingleton<PartRepositoryImplementation>(
      () => PartRepositoryImplementation(Hive.box<PartEntity>(boxName)));
  locator.registerLazySingleton<CheckedOutPartRepository>(() =>
      CheckedOutPartRepositoryImplementation(
          Hive.box<CheckedOutModel>(checkoutPartBox)));
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
  locator.registerFactory<GetDatabaseLength>(
      () => GetDatabaseLength(locator<PartRepositoryImplementation>()));
  locator.registerFactory<GetLowQuantityParts>(
      () => GetLowQuantityParts(locator<PartRepositoryImplementation>()));
  locator.registerFactory<VerifyCheckoutPart>(
      () => VerifyCheckoutPart(locator<CheckedOutPartRepository>()));
  locator.registerFactory<AddCheckoutPart>(() => AddCheckoutPart(
      locator<CheckedOutPartRepository>(), locator<EditPartUsecase>()));
  locator.registerFactory<GetAllCheckoutParts>(
      () => GetAllCheckoutParts(locator<CheckedOutPartRepository>()));
  locator.registerFactory<GetUnverifiedCheckoutParts>(
      () => GetUnverifiedCheckoutParts(locator<CheckedOutPartRepository>()));

  //!Presentation Layer
//!Pages
}
