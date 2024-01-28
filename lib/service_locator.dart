import 'package:get_it/get_it.dart';
import 'package:inventory_v1/data/datasources/local_database.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/data/repositories/part_repository_implementation.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';

final GetIt locator = GetIt.instance;

Future<void> initDependencies() async {
  await initHive();
  setupLocator();
}

Future<void> initHive() async {
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
}

//Initialize the service locator

Future<void> setupLocator() async {
//! Datasource
  locator.registerLazySingletonAsync<Box<Map<String, dynamic>>>(() async {
    final box = await Hive.openBox<Map<String, dynamic>>('parts');
    return box;
  });
  //!Data Layer
  //!Repositories
  locator.registerLazySingleton<LocalDataSourceImplementation>(() =>
      LocalDataSourceImplementation(locator<Box<Map<String, dynamic>>>()));
  locator.registerLazySingleton<PartRepositoryImplementation>(() =>
      PartRepositoryImplementation(locator<LocalDataSourceImplementation>()));
  //!Usecases
  locator.registerFactory<AddPartUsecase>(() => AddPartUsecase(locator()));
  locator
      .registerFactory<DeletePartUsecase>(() => DeletePartUsecase(locator()));
  locator.registerFactory<EditPartUsecase>(() => EditPartUsecase(locator()));
  locator
      .registerFactory<GetAllPartsUsecase>(() => GetAllPartsUsecase(locator()));
  locator.registerFactory<GetPartByNameUseCase>(
      () => GetPartByNameUseCase(locator()));
  locator.registerFactory<GetPartByNsnUseCase>(
      () => GetPartByNsnUseCase(locator()));
  locator.registerFactory<GetPartByPartNumberUsecase>(
      () => GetPartByPartNumberUsecase(locator()));
  locator.registerFactory<GetPartBySerialNumberUsecase>(
      () => GetPartBySerialNumberUsecase(locator()));
  //!Presentation Layer
//!Pages
}
