import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';
import 'package:inventory_v1/domain/usecases/authentication/login_usecase.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_state.dart';
import 'package:logging/logging.dart';

class ManageInventoryCubit extends Cubit<ManageInventoryState> {
  ManageInventoryCubit(
      {int fetchPartAmount = 20,
      required UserEntity authenticatedUser,
      required this.getAllPartsUsecase,
      required this.getUnverifiedCheckoutParts,
      required this.getAllCheckoutParts,
      required this.getLowQuantityParts,
      required this.verifyCheckoutPartUsecase,
      required this.fulfillPartOrdersUsecase,
      required this.createPartOrderUsecase,
      required this.getAllPartOrdersUsecase,
      required LoginUsecase loginUsecase,
      required DeleteUserUsecase deleteUserUsecase,
      required UpdateUserViewRightsUsecase updateUserViewRightsUsecase,
      required ExportUsersUsecase exportUsersUsecase,
      required ClearDatabaseUsecase clearDatabaseUsecase,
      required GetPartByIndexUsecase getPartByIndexUsecase,
      required ImportFromExcelUsecase importFromExcelUsecase,
      required ExportToExcelUsecase exportToExcelUsecase,
      required EditPartUsecase editPartUsecase,
      required DiscontinuePartUsecase discontinuePartUsecase,
      required DeletePartOrderUsecase deletePartOrderUsecase,
      required UpdatePasswordUsecase updatePasswordUsecase,
      required GetUsersUsecase getUsersUsecase})
      : _logger = Logger('manage-inv-cubit'),
        _loginUsecase = loginUsecase,
        _getUsersUsecase = getUsersUsecase,
        _deleteUserUsecase = deleteUserUsecase,
        _updateUserViewRightsUsecase = updateUserViewRightsUsecase,
        _exportUsersUsecase = exportUsersUsecase,
        _updatePasswordUsecase = updatePasswordUsecase,
        _clearDatabaseUsecase = clearDatabaseUsecase,
        _getPartByIndexUsecase = getPartByIndexUsecase,
        _importFromExcelUsecase = importFromExcelUsecase,
        _exportToExcelUsecase = exportToExcelUsecase,
        _editPartUsecase = editPartUsecase,
        _deletePartOrderUsecase = deletePartOrderUsecase,
        _discontinuePartUsecase = discontinuePartUsecase,
        super(ManageInventoryState(
            fetchPartAmount: fetchPartAmount,
            authenticatedUser: authenticatedUser));

  //usecase init
  final GetAllPartsUsecase getAllPartsUsecase;
  final GetLowQuantityParts getLowQuantityParts;
  final GetUnverifiedCheckoutParts getUnverifiedCheckoutParts;
  final VerifyCheckoutPart verifyCheckoutPartUsecase;
  final GetAllCheckoutParts getAllCheckoutParts;
  final FulfillPartOrdersUsecase fulfillPartOrdersUsecase;
  final CreatePartOrderUsecase createPartOrderUsecase;
  final GetAllPartOrdersUsecase getAllPartOrdersUsecase;
  final DeletePartOrderUsecase _deletePartOrderUsecase;
  final DiscontinuePartUsecase _discontinuePartUsecase;
  final EditPartUsecase _editPartUsecase;
  final ExportToExcelUsecase _exportToExcelUsecase;
  final ImportFromExcelUsecase _importFromExcelUsecase;
  final GetPartByIndexUsecase _getPartByIndexUsecase;
  final ClearDatabaseUsecase _clearDatabaseUsecase;
  final GetUsersUsecase _getUsersUsecase;
  final UpdatePasswordUsecase _updatePasswordUsecase;
  final DeleteUserUsecase _deleteUserUsecase;
  final UpdateUserViewRightsUsecase _updateUserViewRightsUsecase;
  final ExportUsersUsecase _exportUsersUsecase;
  final LoginUsecase _loginUsecase;
  //for debugging
  final Logger _logger;
//initialization method
  void init() async {
    emit(state.copyWith(status: ManageInventoryStateStatus.loading));
    loadParts();
    loadCheckedOutParts();
    loadPartOrders();
    loadUsers();
  }

  ///Method uses the [GetAllPartsUsecase] to retrieve the parts lazily
  void loadParts() async {
    //get the current list of parts
    List<PartEntity> oldList = state.allParts.toList();
    var results = await getAllPartsUsecase.call(GetAllPartParams(
        currentDatabaseLength: state.allParts.length,
        fetchAmount: state.fetchPartAmount));

    //unfold the results and return proper data to the UI
    results.fold((l) {
      //!debug
      _logger.warning('error while retrieving all parts');
      //emit the state with the error message and status
      emit(state.copyWith(
          error: l.errorMessage,
          status: ManageInventoryStateStatus.fetchedDataUnsuccessfully));
    }, (newParts) {
      oldList.addAll(newParts);
      _logger.finest('retrieved all parts: ${state.allParts.length}');
      //emit the state with the retrieved parts and status
      emit(state.copyWith(
          status: ManageInventoryStateStatus.fetchedDataSuccessfully,
          allParts: oldList));
    });
  }

  void loadCheckedOutParts() async {
    List<CheckedOutEntity> oldCheckoutPartList = state.checkedOutParts.toList();

    var results = await getAllCheckoutParts.call(GetAllCheckoutPartsParams(
        currentListLength: state.checkedOutParts.length,
        fetchAmount: state.fetchPartAmount));
    results.fold((failure) {
      _logger.warning('error while retrieving checked out parts');
      emit(state.copyWith(
          error: failure.errorMessage,
          status: ManageInventoryStateStatus.fetchedDataUnsuccessfully));
    }, (newParts) {
      _logger.finest('retrieved all checked out parts: ${newParts.length}');

      oldCheckoutPartList.addAll(newParts); // Use addAll for efficiency

      emit(state.copyWith(
        status: ManageInventoryStateStatus.fetchedDataSuccessfully,
        checkedOutParts: oldCheckoutPartList,
      ));
      _logger.finest(
          'state has ${state.checkedOutParts.length} checked out parts');
    });
  }

  void loadPartOrders() async {
    var allPartOrdersList = state.allPartOrders.toList();
    var results = await getAllPartOrdersUsecase.call(GetAllPartOrdersParams(
        currentOrderListLength: state.allPartOrders.length,
        fetchAmount: state.fetchPartAmount));

    results.fold(
        (l) => emit(state.copyWith(
            error: l.errorMessage,
            status: ManageInventoryStateStatus.fetchedDataUnsuccessfully)),
        (orders) {
      allPartOrdersList.addAll(orders);
      emit(state.copyWith(
        status: ManageInventoryStateStatus.fetchedDataSuccessfully,
        allPartOrders: allPartOrdersList,
      ));
    });
  }

  void loadUsers() async {
    if (state.authenticatedUser.viewRights.contains(ViewRightsEnum.admin)) {
      var results = await _getUsersUsecase.call(NoParams());

      results.fold(
          (l) => emit(state.copyWith(
              status: ManageInventoryStateStatus.fetchedDataUnsuccessfully,
              error: l.errorMessage)),
          (r) => emit(state.copyWith(
              allUsers: r
                  .where((e) => e.username != state.authenticatedUser.username)
                  .toList(),
              error: 'Retrieved users!',
              status: ManageInventoryStateStatus.fetchedDataSuccessfully)));
    }
  }

  PartEntity getPart(int index) {
    var results =
        _getPartByIndexUsecase.call(GetPartByIndexParams(index: index));
    return results.fold(
        (l) => PartEntity(
            index: index,
            name: 'part not found',
            nsn: 'part not found',
            partNumber: 'part not found',
            location: 'part not found',
            quantity: -1,
            requisitionPoint: -1,
            requisitionQuantity: -1,
            serialNumber: 'part not found',
            unitOfIssue: UnitOfIssue.NOT_SPECIFIED,
            checksum: 0,
            isDiscontinued: true),
        (part) => part);
  }

  Future<bool> isUserCredentialsValid(String password) async {
    var results = await _loginUsecase.call(LoginParams(
        username: state.authenticatedUser.username, password: password));
    return results.fold((l) => false, (r) => true);
  }

  List<PartEntity> filterLowQuantityParts(List<PartEntity> allParts) {
    return allParts
        .where((part) => part.quantity <= part.requisitionPoint)
        .toList();
  }

  List<CheckedOutEntity> filterUnverifiedParts(
      List<CheckedOutEntity> checkoutEntityList) {
    return checkoutEntityList
        .where((entity) => !(entity.isVerified ?? false))
        .toList();
  }

  List<OrderEntity> filterUnfulfilledPartOrders(
      List<OrderEntity> unfilteredList) {
    return unfilteredList.where((order) => !order.isFulfilled).toList();
  }

  List<PartEntity> filterByLocation() {
    var list = state.allParts.toList();
    list.sort((partA, partB) {
      var comparator =
          partA.location.toLowerCase().compareTo(partB.location.toLowerCase());

      return comparator;
    });

    return list;
  }

  void filterPartsByNsn({required String nsnQuery}) async {}

  void updatePart(PartEntity partEntity) {
    var editedList = state.editedParts.toList();
    var partsList = state.allParts.toList();

    var index =
        partsList.indexWhere((element) => element.index == partEntity.index);
    if (index >= 0) {
      partsList[index] = partEntity;
      editedList.add(partEntity);
      emit(state.copyWith(
          editedParts: editedList,
          allParts: partsList,
          error:
              'Updated part successfully  ${partEntity.nsn} - ${partEntity.name}',
          status: ManageInventoryStateStatus.operationSuccess));
      _logger.fine(
          'updated part entity ${partEntity.nsn} - ${partEntity.name} index is : $index');
    } else {
      _logger.warning(
          'could not update part entity ${partEntity.nsn} - ${partEntity.name} index found is : $index');
      emit(state.copyWith(
          error: 'Could not update part ${partEntity.nsn} - ${partEntity.name}',
          status: ManageInventoryStateStatus.errorOccurred));
    }
  }

  void updateCheckoutQuantity({
    required CheckedOutEntity checkoutPart,
    required int quantityChange,
  }) {
    List<CheckedOutEntity> newCheckoutPartList = state.checkedOutParts.toList();
    var indexInList = newCheckoutPartList.indexOf(checkoutPart);
    if (indexInList < 0) {
      _logger.warning('index is out of bounds, it is : $indexInList');
      emit(state.copyWith(
          status: ManageInventoryStateStatus.errorOccurred,
          error: 'Unexpected error occurred. Check log for details'));
    } else {
      var newCheckoutPart = checkoutPart.copyWith(
        checkedOutQuantity: checkoutPart.checkedOutQuantity + quantityChange,
        quantityDiscrepancy: checkoutPart.quantityDiscrepancy + quantityChange,
      );

      newCheckoutPartList[indexInList] = newCheckoutPart;
      emit(state.copyWith(
        status: ManageInventoryStateStatus.noStatusChange,
        checkedOutParts: newCheckoutPartList,
      ));
    }
  }

  void updateUserViewRights(
      UserEntity user, List<ViewRightsEnum> newRights) async {
    emit(state.copyWith(status: ManageInventoryStateStatus.evokingFunction));
    var results = await _updateUserViewRightsUsecase.call(
        UpdateUserViewRightsParams(
            requestingUser: state.authenticatedUser,
            userToUpdate: user,
            newViewRights: newRights));

    results.fold(
        (l) => emit(state.copyWith(
            error: l.errorMessage,
            status: ManageInventoryStateStatus.errorOccurred)), (r) {
      loadUsers();
      emit(state.copyWith(
          error: 'Updated rights for user ${user.username}',
          status: ManageInventoryStateStatus.operationSuccess));
    });
  }

  void resetUserPassword(UserEntity user, String password) async {
    emit(state.copyWith(status: ManageInventoryStateStatus.evokingFunction));
    var results = await _updatePasswordUsecase.call(UpdatePasswordParams(
        newPassword: 'default',
        username: state.authenticatedUser.username,
        currentPassword: password,
        userToUpdate: user));

    results.fold(
        (l) => emit(state.copyWith(
            status: ManageInventoryStateStatus.errorOccurred,
            error: l.errorMessage)),
        (r) => emit(state.copyWith(
            status: ManageInventoryStateStatus.operationSuccess,
            error: 'Successfully reset password for ${user.username}')));
  }

  void verifyPart({required CheckedOutEntity checkedOutEntity}) async {
    List<CheckedOutEntity> newVerifiedList = state.newlyVerifiedParts.toList();
    List<CheckedOutEntity> newCheckoutPartList = state.checkedOutParts.toList();
    List<PartEntity> newPartEntityList = state.allParts.toList();
    var indexInList = newCheckoutPartList
        .indexWhere((element) => element.index == checkedOutEntity.index);

    //update part

    if (indexInList >= 0) {
      _logger.finest('found index for checkout entity and its $indexInList');
      var newCheckoutPart = checkedOutEntity.copyWith(
        isVerified: true,
        verifiedDate: DateTime.now(),
      );

      newCheckoutPartList[indexInList] = newCheckoutPart;
      var partIndex = newPartEntityList
          .indexWhere((part) => part.index == checkedOutEntity.partEntityIndex);
      //part not found
      if (partIndex == -1) {
        var results = await verifyCheckoutPartUsecase.call(
            VerifyCheckoutPartParams(checkedOutEntityList: [newCheckoutPart]));
        results.fold((l) {
          _logger
              .warning('Could not verify part index is $partIndex failure $l');
          emit(state.copyWith(
              status: ManageInventoryStateStatus.errorOccurred,
              error: 'Could not verify part'));
        },
            (r) => emit(state.copyWith(
                error: 'Successfully verified part',
                status: ManageInventoryStateStatus.operationSuccess)));
      } else if (partIndex >= 0 && partIndex <= newPartEntityList.length) {
        var partEntity = newPartEntityList[partIndex];
        //reflect change in the parts list
        newPartEntityList[partIndex] = partEntity.copyWith(
            quantity:
                partEntity.quantity - newCheckoutPart.quantityDiscrepancy);
        //add checkout part to verified list
        newVerifiedList.add(newCheckoutPart);
        emit(state.copyWith(
            error:
                'Successfully verified part ${partEntity.nsn} - ${partEntity.name}',
            status: ManageInventoryStateStatus.operationSuccess,
            newlyVerifiedParts: newVerifiedList,
            checkedOutParts: newCheckoutPartList,
            allParts: newPartEntityList));
      } else {
        _logger.warning('index is out of bounds for part, and is $partIndex');
      }
    } else {
      _logger.warning(
          'index is out of bounds for checked out part, and is $indexInList');
    }
  }

  void fulfillPartOrder({required OrderEntity orderEntity}) async {
    List<PartEntity> allParts = state.allParts.toList();
    List<OrderEntity> allPartOrders = state.allPartOrders.toList();
    List<OrderEntity> newlyFulfilledPartOrders =
        state.newlyFulfilledPartOrders.toList();
    var index = allPartOrders.indexOf(orderEntity);
    if (index >= 0 && index < allPartOrders.length) {
      var fulfilledOrder = allPartOrders[index]
          .copyWith(fulfillmentDate: DateTime.now(), isFulfilled: true);
      allPartOrders[index] = fulfilledOrder;
      var partIndex = allParts
          .indexWhere((part) => part.index == fulfilledOrder.partEntityIndex);
      if (partIndex == -1) {
        var results = await fulfillPartOrdersUsecase.call(
            FulfillPartOrdersParams(fulfillmentEntities: [fulfilledOrder]));

        results.fold(
            (l) => emit(state.copyWith(
                status: ManageInventoryStateStatus.errorOccurred,
                error:
                    'Could not complete order fulfillment, please see log for details')),
            (r) => emit(state.copyWith(
                status: ManageInventoryStateStatus.operationSuccess,
                error: 'Successfully fulfilled part order')));
      } else if (partIndex >= 0 && partIndex < allParts.length) {
        var partEntity = allParts[partIndex];

        partEntity = partEntity.copyWith(
            quantity: partEntity.quantity + fulfilledOrder.orderAmount);

        allParts[partIndex] = partEntity;

        newlyFulfilledPartOrders.add(fulfilledOrder);

        emit(state.copyWith(
            error:
                'Successfully fulfilled part order for ${partEntity.nsn} - ${partEntity.name} added ${fulfilledOrder.orderAmount}${partEntity.unitOfIssue.displayValue}',
            status: ManageInventoryStateStatus.operationSuccess,
            allPartOrders: allPartOrders,
            newlyFulfilledPartOrders: newlyFulfilledPartOrders,
            allParts: allParts));
      } else {
        emit(state.copyWith(
            status: ManageInventoryStateStatus.errorOccurred,
            error:
                'Unexpected error occurred while fulfilling order, please see log for details'));
        _logger.warning(
            'index out of bounds for part when completing order fulfillment index is $partIndex');
      }
    } else {
      emit(state.copyWith(
          status: ManageInventoryStateStatus.errorOccurred,
          error:
              'Unexpected error occurred while fulfilling order, please see log for details'));
      _logger.warning(
          'index out of bounds for part order fulfillment index is $index');
    }
  }

  ///order parts methods
  void orderPart(
      {required int orderAmount, required int partEntityIndex}) async {
    emit(state.copyWith(status: ManageInventoryStateStatus.evokingFunction));
    var partOrders = state.allPartOrders.toList();
    var index = state.allPartOrders.isEmpty ? 0 : partOrders.first.index + 1;
    var orderEntity = OrderEntity(
        index: index,
        partEntityIndex: partEntityIndex,
        orderAmount: orderAmount,
        orderDate: DateTime.now());
    partOrders.insert(0, orderEntity);
    var results = await createPartOrderUsecase
        .call(CreatePartOrderParams(orderEntity: orderEntity));

    results.fold((failure) {
      _logger.warning(
          'error encountered while creating part order failure: $failure');
      emit(state.copyWith(
          error:
              'Could not create part order at this time, please see log for details',
          status: ManageInventoryStateStatus.errorOccurred));
    }, (_) {
      emit(state.copyWith(
        error: 'Created part order successfully',
        status: ManageInventoryStateStatus.operationSuccess,
        allPartOrders: partOrders,
      ));
    });
  }

  void discontinuePart({required PartEntity partEntity}) async {
    var allParts = state.allParts.toList();
    var index = allParts.indexWhere((part) => part.index == partEntity.index);
    if (index >= 0) {
      var results = await _discontinuePartUsecase
          .call(DiscontinuePartParams(discontinuedPartEntity: allParts[index]));
      results.fold(
          (failure) => emit(state.copyWith(
              error: 'Could not discontinue part',
              status: ManageInventoryStateStatus.errorOccurred)), (_) {
        //remove all current orders for this discontinued part and add it to the list to be deleted
        allParts[index] = partEntity.copyWith(isDiscontinued: true);
        emit(state.copyWith(
            allPartOrders: [],
            allParts: allParts,
            error: 'Discontinued part successfully',
            status: ManageInventoryStateStatus.operationSuccess));
        loadPartOrders();
      });
    }
  }

  void deletePartOrder({required OrderEntity orderEntity}) async {
    emit(state.copyWith(status: ManageInventoryStateStatus.evokingFunction));
    var partOrders = state.allPartOrders.toList();

    var results = await _deletePartOrderUsecase
        .call(DeletePartOrderParams(orderEntity: orderEntity));

    results.fold((failure) {
      _logger.warning(
          'error occurred while deleting part order failure: $failure');
      emit(state.copyWith(
          error: 'Could not delete part order',
          status: ManageInventoryStateStatus.errorOccurred));
    }, (_) {
      partOrders.remove(orderEntity);

      emit(state.copyWith(
        error: 'Deleted part order',
        status: ManageInventoryStateStatus.operationSuccess,
        allPartOrders: partOrders,
      ));
    });
  }

  void deleteUser(UserEntity user, String password) async {
    emit(state.copyWith(status: ManageInventoryStateStatus.evokingFunction));
    var results = await _deleteUserUsecase.call(DeleteUserParams(
        userEntity: user,
        password: password,
        username: state.authenticatedUser.username));

    results.fold(
        (l) => emit(state.copyWith(
            status: ManageInventoryStateStatus.errorOccurred,
            error: 'Could not delete user profile: ${l.errorMessage}')), (r) {
      emit(state.copyWith(
          status: ManageInventoryStateStatus.operationSuccess,
          error: 'Successfully deleted user : ${user.username}'));
      loadUsers();
    });
  }

  void clearDatabase() async {
    emit(state.copyWith(status: ManageInventoryStateStatus.loading));
    await _updateDatabase();
    var results = await _clearDatabaseUsecase.call(NoParams());
    results.fold((l) {
      _logger.warning('error occurred while clearing database $l');
      emit(state.copyWith(
          error: 'Error occurred while clearing database',
          status: ManageInventoryStateStatus.errorOccurred));
    },
        (r) => emit(state.copyWith(
            error: 'Cleared database successfully',
            allParts: [],
            checkedOutParts: [],
            newlyVerifiedParts: [],
            newlyFulfilledPartOrders: [],
            allPartOrders: [],
            editedParts: [],
            status: ManageInventoryStateStatus.operationSuccess)));
  }

  void restockPart(
      {required PartEntity partEntity, required int newQuantity}) async {
    emit(state.copyWith(status: ManageInventoryStateStatus.evokingFunction));
    var restockedPart =
        partEntity.copyWith(isDiscontinued: false, quantity: newQuantity);
    var results =
        await _editPartUsecase.call(EditPartParams(partEntity: restockedPart));

    results.fold(
        (failure) => emit(state.copyWith(
            error: failure.errorMessage,
            status: ManageInventoryStateStatus.errorOccurred)), (_) {
      var allParts = state.allParts.toList();
      var partIndex =
          allParts.indexWhere((part) => part.index == partEntity.index);
      allParts[partIndex] = restockedPart;
      emit(state.copyWith(
          status: ManageInventoryStateStatus.operationSuccess,
          allParts: allParts));
    });
  }

  Future<void> _updateDatabase() async {
    _logger.finest('placing verified parts in the database');
    emit(state.copyWith(status: ManageInventoryStateStatus.evokingFunction));

    for (var part in state.editedParts) {
      await _editPartUsecase.call(EditPartParams(partEntity: part));
    }
    await verifyCheckoutPartUsecase.call(VerifyCheckoutPartParams(
        checkedOutEntityList: state.newlyVerifiedParts));
    await fulfillPartOrdersUsecase.call(FulfillPartOrdersParams(
        fulfillmentEntities: state.newlyFulfilledPartOrders));
  }

  void exportToExcel(String path) async {
    _logger.finest('path is $path');
    emit(state.copyWith(status: ManageInventoryStateStatus.evokingFunction));
    await _updateDatabase();
    var results =
        await _exportToExcelUsecase.call(ExportToExcelParams(path: path));
    results.fold((l) {
      _logger.warning('error occurred when exporting to excel $l');
      emit(state.copyWith(
          status: ManageInventoryStateStatus.errorOccurred,
          error: 'Could not export to excel'));
    }, (r) {
      emit(state.copyWith(
          error: 'Exported file to excel located at $path',
          status: ManageInventoryStateStatus.operationSuccess));
    });
  }

  void importFromExcel(String path) async {
    var results =
        await _importFromExcelUsecase.call(ImportFromExcelParams(path: path));
    await results.fold((l) {
      _logger.warning('error occurred when importing from excel at $path');
      emit(state.copyWith(
          status: ManageInventoryStateStatus.errorOccurred,
          error: 'Error occurred when importing from excel sheet at $path'));
    }, (count) async {
      init();
      await Future.delayed(Durations.short1);
      emit(state.copyWith(
          status: ManageInventoryStateStatus.operationSuccess,
          error: ' Successfully imported $count parts from excel'));
    });
  }

  @override
  Future<void> close() async {
    await _updateDatabase();
    super.close();
  }
}
