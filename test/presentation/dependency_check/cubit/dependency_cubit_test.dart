import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/data/models/checked-out/checked_out_model.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/data/models/part_order/part_order_model.dart';
import 'package:inventory_v1/data/repositories/checked_out_part_repository_implementation.dart';
import 'package:inventory_v1/data/repositories/part_order_repository_implementation.dart';
import 'package:inventory_v1/data/repositories/part_repository_implementation.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/dependency_check/cubit/dependency_check_cubit.dart';
import 'package:inventory_v1/presentation/dependency_check/cubit/dependency_check_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class MockGetIt extends Mock implements GetIt {}

class MockPathProviderPlatform extends Mock implements PathProviderPlatform {}

class MockPartRepo extends Mock implements PartRepository {}

class MockPartOrderRepo extends Mock implements PartOrderRepository {}

class MockCheckoutPartRepo extends Mock implements CheckedOutPartRepository {}

class MockBox extends Mock implements Box<PartModel> {}

class MockPartOrderBox extends Mock implements Box<OrderModel> {}

class MockCheckoutBox extends Mock implements Box<CheckedOutModel> {}

void main() {
  late DependencyCheckCubit sut;
  late MockGetIt mockGetIt;
  late MockPartOrderRepo mockPartOrderRepo;

  late MockPathProviderPlatform mockPathProviderPlatform;
  late MockPartRepo mockPartRepo;
  late MockCheckoutPartRepo mockCheckoutPartRepo;
  late MockBox mockBox;
  late MockCheckoutBox mockCheckoutBox;
  late MockPartOrderBox mockPartOrderBox;
  Future<void> dependencyInjection() async {
    mockGetIt = MockGetIt();
  }

  setUp(() async {
    await dependencyInjection();
    mockPartOrderRepo = MockPartOrderRepo();
    mockPathProviderPlatform = MockPathProviderPlatform();
    mockBox = MockBox();
    mockCheckoutBox = MockCheckoutBox();
    mockPartOrderBox = MockPartOrderBox();
    mockPartRepo = MockPartRepo();
    mockCheckoutPartRepo = MockCheckoutPartRepo();
    sut = DependencyCheckCubit(
        pathProviderPlatform: mockPathProviderPlatform,
        isHiveInitialized: true,
        sl: mockGetIt);
  });

  group('DependencyCubit()', () {
    //setup for all tests
    void mockSetup() {
      //path mock
      when(() => mockPathProviderPlatform.getApplicationDocumentsPath())
          .thenAnswer((invocation) async => 'not_null');
      //part repo mock
      when(() => mockGetIt<PartRepository>())
          .thenAnswer((invocation) => PartRepositoryImplementation(mockBox));
      when(() => mockGetIt<CheckedOutPartRepository>()).thenAnswer(
          (invocation) =>
              CheckedOutPartRepositoryImplementation(mockCheckoutBox));
      when(() => mockGetIt<PartOrderRepository>()).thenAnswer(
          (_) => PartOrderRepositoryImplementation(mockPartOrderBox));
      //usecases mock
      when(() => mockGetIt<AddPartUsecase>())
          .thenAnswer((invocation) => AddPartUsecase(mockPartRepo));
      when(() => mockGetIt<DeletePartUsecase>())
          .thenAnswer((invocation) => DeletePartUsecase(mockPartRepo));
      when(() => mockGetIt<EditPartUsecase>())
          .thenAnswer((invocation) => EditPartUsecase(mockPartRepo));
      when(() => mockGetIt<GetAllPartsUsecase>())
          .thenAnswer((invocation) => GetAllPartsUsecase(mockPartRepo));
      when(() => mockGetIt<GetPartByNameUseCase>())
          .thenAnswer((invocation) => GetPartByNameUseCase(mockPartRepo));
      when(() => mockGetIt<GetPartByNsnUseCase>())
          .thenAnswer((invocation) => GetPartByNsnUseCase(mockPartRepo));
      when(() => mockGetIt<GetPartByPartNumberUsecase>())
          .thenAnswer((invocation) => GetPartByPartNumberUsecase(mockPartRepo));
      when(() => mockGetIt<GetPartBySerialNumberUsecase>()).thenAnswer(
          (invocation) => GetPartBySerialNumberUsecase(mockPartRepo));
      when(() => mockGetIt<GetDatabaseLength>())
          .thenAnswer((invocation) => GetDatabaseLength(mockPartRepo));
      when(() => mockGetIt<AddCheckoutPart>()).thenAnswer(
          (invocation) => AddCheckoutPart(mockCheckoutPartRepo, mockPartRepo));
      when(() => mockGetIt<GetAllCheckoutParts>()).thenAnswer(
          (invocation) => GetAllCheckoutParts(mockCheckoutPartRepo));
      when(() => mockGetIt<VerifyCheckoutPart>()).thenAnswer((invocation) =>
          VerifyCheckoutPart(mockCheckoutPartRepo, mockPartRepo));
      when(() => mockGetIt<GetUnverifiedCheckoutParts>()).thenAnswer(
          (invocation) => GetUnverifiedCheckoutParts(mockCheckoutPartRepo));
      when(() => mockGetIt<GetLowQuantityParts>())
          .thenAnswer((invocation) => GetLowQuantityParts(mockPartRepo));
      //order
      when(() => mockGetIt<CreatePartOrderUsecase>())
          .thenAnswer((_) => CreatePartOrderUsecase(mockPartOrderRepo));
      when(() => mockGetIt<DeletePartOrderUsecase>())
          .thenAnswer((_) => DeletePartOrderUsecase(mockPartOrderRepo));
      when(() => mockGetIt<EditPartOrderUsecase>())
          .thenAnswer((_) => EditPartOrderUsecase(mockPartOrderRepo));
      when(() => mockGetIt<FulfillPartOrdersUsecase>()).thenAnswer(
          (_) => FulfillPartOrdersUsecase(mockPartRepo, mockPartOrderRepo));
      when(() => mockGetIt<GetAllPartOrdersUsecase>())
          .thenAnswer((_) => GetAllPartOrdersUsecase(mockPartOrderRepo));
      when(() => mockGetIt<GetPartOrderUsecase>())
          .thenAnswer((_) => GetPartOrderUsecase(mockPartOrderRepo));
      when(() => mockGetIt<DiscontinuePartUsecase>()).thenAnswer(
          (_) => DiscontinuePartUsecase(mockPartOrderRepo, mockPartRepo));
    }

    test('initial state is correct', () {
      expect(sut.state.isHiveOpen, false);
      expect(sut.state.isServiceLocatorOpen, false);
      expect(sut.state.isPartRepoInit, false);
      expect(sut.state.isPathAccessible, false);
      expect(sut.state.isUsecasesInit, false);
      expect(sut.state.isCheckoutPartRepoInit, false);
      expect(sut.state.dependencyCheckStateStatus,
          DependencyCheckStateStatus.loading);
    });

    test('All dependencies are initialized', () async {
      //setup
      mockSetup();
      //expectations
      expectLater(
          sut.stream.map((state) => state.dependencyCheckStateStatus),
          emitsInOrder([
            DependencyCheckStateStatus.loadedSuccessfully,
          ]));
      //evoke the function
      await sut.checkDependencies();
      //verifications
      //verify that the service locator was called once for the path
      verify(() => mockPathProviderPlatform.getApplicationDocumentsPath())
          .called(1);
      //verify that the service locator was called once for the repo
      verify(() => mockGetIt<PartRepository>()).called(1);
      //verify that the service locator was only called once per usecase
      verify(() => mockGetIt<AddPartUsecase>()).called(1);
      verify(() => mockGetIt<DeletePartUsecase>()).called(1);
      verify(() => mockGetIt<EditPartUsecase>()).called(1);
      verify(() => mockGetIt<GetAllPartsUsecase>()).called(1);
      verify(() => mockGetIt<GetPartByNsnUseCase>()).called(1);
      verify(() => mockGetIt<GetPartByNameUseCase>()).called(1);
      verify(() => mockGetIt<GetPartByPartNumberUsecase>()).called(1);
      verify(() => mockGetIt<GetPartBySerialNumberUsecase>()).called(1);
      verify(() => mockGetIt<GetDatabaseLength>()).called(1);
    });

    test('One or more dependency not init', () async {
      //setup
      mockSetup();
      //return null
      when(() => mockPathProviderPlatform.getApplicationDocumentsPath())
          .thenAnswer((invocation) async => null);
      //expectations
      expectLater(
          sut.stream.map((state) => state.dependencyCheckStateStatus),
          emitsInOrder([
            DependencyCheckStateStatus.loadedUnsuccessfully,
          ]));
      //evoke the function
      await sut.checkDependencies();
      //verifications
      //verify that the service locator was called once for the path
      verify(() => mockPathProviderPlatform.getApplicationDocumentsPath())
          .called(1);
      //verify that the service locator was called once for the repo
      verify(() => mockGetIt<PartRepository>()).called(1);
      //verify that the service locator was only called once per usecase
      verify(() => mockGetIt<AddPartUsecase>()).called(1);
      verify(() => mockGetIt<DeletePartUsecase>()).called(1);
      verify(() => mockGetIt<EditPartUsecase>()).called(1);
      verify(() => mockGetIt<GetAllPartsUsecase>()).called(1);
      verify(() => mockGetIt<GetPartByNsnUseCase>()).called(1);
      verify(() => mockGetIt<GetPartByNameUseCase>()).called(1);
      verify(() => mockGetIt<GetPartByPartNumberUsecase>()).called(1);
      verify(() => mockGetIt<GetPartBySerialNumberUsecase>()).called(1);
      verify(() => mockGetIt<GetDatabaseLength>()).called(1);
    });
  });
  group('path', () {
    void mockSetup() {
      when(() => mockPathProviderPlatform.getApplicationDocumentsPath())
          .thenAnswer((invocation) async => 'not_null');
    }

    test('path is accessible', () async {
//setups
      mockSetup();

      expectLater(sut.stream.map((state) => state.isPathAccessible),
          emitsInOrder([true]));
      await sut.checkDependencies();
      //verify that the path was called once
      verify(() => mockPathProviderPlatform.getApplicationDocumentsPath())
          .called(1);
    });

    test('path is not  accessible', () async {
//setups
      mockSetup();
      //return null
      when(() => mockPathProviderPlatform.getApplicationDocumentsPath())
          .thenAnswer((invocation) async => null);
      //start the stream listener before the actual call so that all emitted state are captured
      expectLater(sut.stream.map((state) => state.isPathAccessible),
          emitsInOrder([false]));
      //evoke the function
      await sut.checkDependencies();
      //verify that the path was called once
      verify(() => mockPathProviderPlatform.getApplicationDocumentsPath())
          .called(1);
    });
  });

  group('Hive', () {
    test('hive is open', () async {
//setups

      expectLater(
          sut.stream.map((state) => state.isHiveOpen), emitsInOrder([true]));
      await sut.checkDependencies();
    });

    test('hive is not open', () async {
//setups
      //close the previous cubit
      sut.close();
      //initialize new cubit with hive flagged false
      sut = DependencyCheckCubit(
          isHiveInitialized: false,
          sl: mockGetIt,
          pathProviderPlatform: mockPathProviderPlatform);
      //open the stream listener before the call so all emitted state can be
      //captured
      expectLater(
          sut.stream.map((state) => state.isHiveOpen), emitsInOrder([false]));
      await sut.checkDependencies();

      sut.close();
    });
  });

  group('Part Repo', () {
    void mockSetup() {
      when(() => mockGetIt<PartRepository>())
          .thenAnswer((invocation) => PartRepositoryImplementation(mockBox));
    }

    test('part repo is open', () async {
      mockSetup();
      //expectations, start the stream listener before the actual call to the function
      //so all emitted state can be captured
      expectLater(sut.stream.map((state) => state.isPartRepoInit),
          emitsInOrder([true]));
      //evoke the function
      await sut.checkDependencies();
      //verify that the service locator was only called once
      verify(() => mockGetIt<PartRepository>()).called(1);
    });

    test('part repo is not open', () async {
      when(() => mockGetIt<PartRepository>())
          .thenAnswer((invocation) => throw Exception());
      //expectations, start the stream listener before the actual call to the function
      //so all emitted state can be captured
      expectLater(sut.stream.map((state) => state.isPartRepoInit),
          emitsInOrder([false]));
      //evoke the function
      await sut.checkDependencies();
      //verify that the service locator was only called once
      verify(() => mockGetIt<PartRepository>()).called(1);
    });
  });

  group('Checkout Repo', () {
    void mockSetup() {
      when(() => mockGetIt<CheckedOutPartRepository>()).thenAnswer(
          (invocation) =>
              CheckedOutPartRepositoryImplementation(mockCheckoutBox));
    }

    test('checkout part repo is open', () async {
      mockSetup();
      //expectations, start the stream listener before the actual call to the function
      //so all emitted state can be captured
      expectLater(sut.stream.map((state) => state.isCheckoutPartRepoInit),
          emitsInOrder([true]));
      //evoke the function
      await sut.checkDependencies();
      //verify that the service locator was only called once
      verify(() => mockGetIt<CheckedOutPartRepository>()).called(1);
    });

    test('checkout part repo is not open', () async {
      when(() => mockGetIt<CheckedOutPartRepository>())
          .thenAnswer((invocation) => throw Exception());
      //expectations, start the stream listener before the actual call to the function
      //so all emitted state can be captured
      expectLater(sut.stream.map((state) => state.isCheckoutPartRepoInit),
          emitsInOrder([false]));
      //evoke the function
      await sut.checkDependencies();
      //verify that the service locator was only called once
      verify(() => mockGetIt<CheckedOutPartRepository>()).called(1);
    });
  });
  group('Usecases', () {
    //setup
    void mockSetup() {
      //setup the service locator to work with the usecases

      when(() => mockGetIt<AddPartUsecase>())
          .thenAnswer((invocation) => AddPartUsecase(mockPartRepo));
      when(() => mockGetIt<DeletePartUsecase>())
          .thenAnswer((invocation) => DeletePartUsecase(mockPartRepo));
      when(() => mockGetIt<EditPartUsecase>())
          .thenAnswer((invocation) => EditPartUsecase(mockPartRepo));
      when(() => mockGetIt<GetAllPartsUsecase>())
          .thenAnswer((invocation) => GetAllPartsUsecase(mockPartRepo));
      when(() => mockGetIt<GetPartByNameUseCase>())
          .thenAnswer((invocation) => GetPartByNameUseCase(mockPartRepo));
      when(() => mockGetIt<GetPartByNsnUseCase>())
          .thenAnswer((invocation) => GetPartByNsnUseCase(mockPartRepo));
      when(() => mockGetIt<GetPartByPartNumberUsecase>())
          .thenAnswer((invocation) => GetPartByPartNumberUsecase(mockPartRepo));
      when(() => mockGetIt<GetPartBySerialNumberUsecase>()).thenAnswer(
          (invocation) => GetPartBySerialNumberUsecase(mockPartRepo));
      when(() => mockGetIt<GetDatabaseLength>())
          .thenAnswer((invocation) => GetDatabaseLength(mockPartRepo));
      when(() => mockGetIt<AddCheckoutPart>()).thenAnswer(
          (invocation) => AddCheckoutPart(mockCheckoutPartRepo, mockPartRepo));
      when(() => mockGetIt<GetAllCheckoutParts>()).thenAnswer(
          (invocation) => GetAllCheckoutParts(mockCheckoutPartRepo));
      when(() => mockGetIt<VerifyCheckoutPart>()).thenAnswer((invocation) =>
          VerifyCheckoutPart(mockCheckoutPartRepo, mockPartRepo));
      when(() => mockGetIt<GetUnverifiedCheckoutParts>()).thenAnswer(
          (invocation) => GetUnverifiedCheckoutParts(mockCheckoutPartRepo));
      when(() => mockGetIt<GetLowQuantityParts>())
          .thenAnswer((invocation) => GetLowQuantityParts(mockPartRepo));
      //order
      when(() => mockGetIt<CreatePartOrderUsecase>())
          .thenAnswer((_) => CreatePartOrderUsecase(mockPartOrderRepo));
      when(() => mockGetIt<DeletePartOrderUsecase>())
          .thenAnswer((_) => DeletePartOrderUsecase(mockPartOrderRepo));
      when(() => mockGetIt<EditPartOrderUsecase>())
          .thenAnswer((_) => EditPartOrderUsecase(mockPartOrderRepo));
      when(() => mockGetIt<FulfillPartOrdersUsecase>()).thenAnswer(
          (_) => FulfillPartOrdersUsecase(mockPartRepo, mockPartOrderRepo));
      when(() => mockGetIt<GetAllPartOrdersUsecase>())
          .thenAnswer((_) => GetAllPartOrdersUsecase(mockPartOrderRepo));
      when(() => mockGetIt<GetPartOrderUsecase>())
          .thenAnswer((_) => GetPartOrderUsecase(mockPartOrderRepo));
      when(() => mockGetIt<DiscontinuePartUsecase>()).thenAnswer(
          (_) => DiscontinuePartUsecase(mockPartOrderRepo, mockPartRepo));
    }

    test('Usecases are initialized', () async {
      mockSetup();
      //expectations, start the stream listener before the actual call to the function
      //so all emitted state can be captured
      expectLater(sut.stream.map((state) => state.isUsecasesInit),
          emitsInOrder([true]));
      //evoke the function
      await sut.checkDependencies();
      //verify that the service locator was only called once per usecase
      verify(() => mockGetIt<AddPartUsecase>()).called(1);
      verify(() => mockGetIt<DeletePartUsecase>()).called(1);
      verify(() => mockGetIt<EditPartUsecase>()).called(1);
      verify(() => mockGetIt<GetAllPartsUsecase>()).called(1);
      verify(() => mockGetIt<GetPartByNsnUseCase>()).called(1);
      verify(() => mockGetIt<GetPartByNameUseCase>()).called(1);
      verify(() => mockGetIt<GetPartByPartNumberUsecase>()).called(1);
      verify(() => mockGetIt<GetPartBySerialNumberUsecase>()).called(1);
      verify(() => mockGetIt<GetDatabaseLength>()).called(1);
    });

    test('Usecases are not initialized', () async {
      mockSetup();

      when(() => mockGetIt<GetPartByPartNumberUsecase>())
          .thenAnswer((invocation) => throw Exception());
      //expectations, start the stream listener before the actual call to the function
      //so all emitted state can be captured
      expectLater(sut.stream.map((state) => state.isUsecasesInit),
          emitsInOrder([false]));
      //evoke the function
      await sut.checkDependencies();
      //verify that the service locator was only called once per usecase
      verify(() => mockGetIt<AddPartUsecase>()).called(1);
      verify(() => mockGetIt<DeletePartUsecase>()).called(1);
      verify(() => mockGetIt<EditPartUsecase>()).called(1);
      verify(() => mockGetIt<GetAllPartsUsecase>()).called(1);
      verify(() => mockGetIt<GetPartByNsnUseCase>()).called(1);
      verify(() => mockGetIt<GetPartByNameUseCase>()).called(1);
      verify(() => mockGetIt<GetPartByPartNumberUsecase>()).called(1);
      //after the above throws an exception the following should not be called
      verifyNever(() => mockGetIt<GetPartBySerialNumberUsecase>());
      verifyNever(() => mockGetIt<GetDatabaseLength>());
    });
  });
}
