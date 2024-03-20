import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:inventory_v1/core/util/main_section_enum.dart';
import 'package:inventory_v1/core/util/rank_enum.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/data/models/checked-out/checked_out_model.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/data/models/part_order/part_order_model.dart';
import 'package:inventory_v1/data/models/user/user_model.dart';
import 'package:inventory_v1/data/repositories/authentication_repository_implementation.dart';
import 'package:inventory_v1/data/repositories/checked_out_part_repository_implementation.dart';
import 'package:inventory_v1/data/repositories/local_storage_implementation.dart';
import 'package:inventory_v1/data/repositories/part_order_repository_implementation.dart';
import 'package:inventory_v1/data/repositories/part_repository_implementation.dart';
import 'package:inventory_v1/domain/repositories/authentication_repository.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:inventory_v1/domain/repositories/local_storage_repository.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/authentication/login_usecase.dart';
import 'package:logging/logging.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';

//name of the Hive.box that the parts data is stored in
const String boxName = 'parts_json';
const String checkoutPartBox = 'checkout_parts';
const String partOrdersBox = 'part_orders';
const String usersBox = 'users';
final GetIt locator = GetIt.instance;
Logger serviceLocatorLogger = Logger('service_locator');

//initialize various dependencies
Future<void> initDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  serviceLocatorLogger = Logger('service_logger');
  await initHive();
  serviceLocatorLogger.finest('initializing service locator');
  await setupLocator();
}

Future<void> initHive() async {
  serviceLocatorLogger.finest('initializing HIVE');

  await Hive.initFlutter();
  Hive.registerAdapter(PartModelAdapter());
  Hive.registerAdapter(UnitOfIssueAdapter());
  Hive.registerAdapter(CheckedOutModelAdapter());
  Hive.registerAdapter(OrderModelAdapter());
  Hive.registerAdapter(MaintenanceSectionAdapter());
  Hive.registerAdapter(RankEnumAdapter());
  Hive.registerAdapter(ViewRightsEnumAdapter());
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>(usersBox);
  await Hive.openBox<OrderModel>(partOrdersBox);
  await Hive.openBox<PartModel>(boxName);
  await Hive.openBox<CheckedOutModel>(checkoutPartBox);

  // Hive.box<PartModel>(boxName).clear();
  // Hive.box<CheckedOutModel>(checkoutPartBox).clear();
  // Hive.box<OrderModel>(partOrdersBox).clear();

  serviceLocatorLogger.finest('initialized hive');
}

//Initialize the service locator

Future<void> setupLocator() async {
//! Datasource

  //!Data Layer
  //!Repositories
  locator.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImplementation(
      localDatasource: Hive.box<UserModel>(usersBox),
    ),
  );
  locator.registerLazySingleton<PartRepository>(
      () => PartRepositoryImplementation(Hive.box<PartModel>(boxName)));
  locator.registerLazySingleton<CheckedOutPartRepository>(() =>
      CheckedOutPartRepositoryImplementation(
          Hive.box<CheckedOutModel>(checkoutPartBox)));
  locator.registerLazySingleton<PartOrderRepository>(() =>
      PartOrderRepositoryImplementation(Hive.box<OrderModel>(partOrdersBox)));
  locator.registerLazySingleton<LocalStorage>(() => LocalStorageImplementation(
      partOrderRepository: locator<PartOrderRepository>(),
      partRepository: locator<PartRepository>(),
      checkedOutPartRepository: locator<CheckedOutPartRepository>()));
  //!Usecases
  locator.registerFactory<AddPartUsecase>(
      () => AddPartUsecase(locator<PartRepository>()));
  locator.registerFactory<DeletePartUsecase>(
      () => DeletePartUsecase(locator<PartRepository>()));
  locator.registerFactory<EditPartUsecase>(
      () => EditPartUsecase(locator<PartRepository>()));
  locator.registerFactory<GetAllPartsUsecase>(
      () => GetAllPartsUsecase(locator<PartRepository>()));
  locator.registerFactory<GetPartByNameUseCase>(
      () => GetPartByNameUseCase(locator<PartRepository>()));
  locator.registerFactory<GetPartByNsnUseCase>(
      () => GetPartByNsnUseCase(locator<PartRepository>()));
  locator.registerFactory<GetPartByPartNumberUsecase>(
      () => GetPartByPartNumberUsecase(locator<PartRepository>()));
  locator.registerFactory<GetPartBySerialNumberUsecase>(
      () => GetPartBySerialNumberUsecase(locator<PartRepository>()));
  locator.registerFactory<GetDatabaseLength>(
      () => GetDatabaseLength(locator<PartRepository>()));
  locator.registerFactory<GetLowQuantityParts>(
      () => GetLowQuantityParts(locator<PartRepository>()));

  locator.registerFactory<VerifyCheckoutPart>(() => VerifyCheckoutPart(
      locator<CheckedOutPartRepository>(), locator<PartRepository>()));
  locator.registerFactory<AddCheckoutPart>(() => AddCheckoutPart(
      locator<CheckedOutPartRepository>(), locator<PartRepository>()));
  locator.registerFactory<GetAllCheckoutParts>(
      () => GetAllCheckoutParts(locator<CheckedOutPartRepository>()));
  locator.registerFactory<GetUnverifiedCheckoutParts>(
      () => GetUnverifiedCheckoutParts(locator<CheckedOutPartRepository>()));

  locator.registerFactory<CreatePartOrderUsecase>(
      () => CreatePartOrderUsecase(locator<PartOrderRepository>()));
  locator.registerFactory<DeletePartOrderUsecase>(
      () => DeletePartOrderUsecase(locator<PartOrderRepository>()));
  locator.registerFactory<EditPartOrderUsecase>(
      () => EditPartOrderUsecase(locator<PartOrderRepository>()));
  locator.registerFactory<FulfillPartOrdersUsecase>(() =>
      FulfillPartOrdersUsecase(
          locator<PartRepository>(), locator<PartOrderRepository>()));
  locator.registerFactory<GetAllPartOrdersUsecase>(
      () => GetAllPartOrdersUsecase(locator<PartOrderRepository>()));
  locator.registerFactory<GetPartOrderUsecase>(
      () => GetPartOrderUsecase(locator<PartOrderRepository>()));
  locator.registerFactory<DiscontinuePartUsecase>(() => DiscontinuePartUsecase(
      locator<PartOrderRepository>(), locator<PartRepository>()));

  locator.registerFactory<ExportToExcelUsecase>(
      () => ExportToExcelUsecase(localStorage: locator<LocalStorage>()));
  locator.registerFactory<ImportFromExcelUsecase>(() => ImportFromExcelUsecase(
      locator<LocalStorage>(),
      Hive.box<PartModel>(boxName),
      Hive.box<CheckedOutModel>(checkoutPartBox),
      Hive.box<OrderModel>(partOrdersBox)));
  locator.registerFactory<GetPartByIndexUsecase>(
      () => GetPartByIndexUsecase(locator<PartRepository>()));

  locator.registerFactory<ClearDatabaseUsecase>(
      () => ClearDatabaseUsecase(localStorage: locator<LocalStorage>()));
  //!authentication usecases
  locator.registerFactory<LoginUsecase>(() => LoginUsecase(
      authenticationRepository: locator<AuthenticationRepository>()));
  locator.registerFactory<CreateUserUsecase>(() => CreateUserUsecase(
      authenticationRepository: locator<AuthenticationRepository>()));
  locator.registerFactory<DeleteUserUsecase>(() => DeleteUserUsecase(
      authenticationRepository: locator<AuthenticationRepository>()));
  locator.registerFactory<ExportUsersUsecase>(() => ExportUsersUsecase(
      authenticationRepository: locator<AuthenticationRepository>()));
  locator.registerFactory<GetUsersUsecase>(() => GetUsersUsecase(
      authenticationRepository: locator<AuthenticationRepository>()));
  locator.registerFactory<UpdatePasswordUsecase>(() => UpdatePasswordUsecase(
      authenticationRepository: locator<AuthenticationRepository>()));
  locator.registerFactory<UpdateUserProfileUsecase>(() =>
      UpdateUserProfileUsecase(
          authenticationRepository: locator<AuthenticationRepository>()));
  locator.registerFactory<UpdateUserViewRightsUsecase>(() =>
      UpdateUserViewRightsUsecase(
          authenticationRepository: locator<AuthenticationRepository>()));
  //!Presentation Layer
//!Pages
}
