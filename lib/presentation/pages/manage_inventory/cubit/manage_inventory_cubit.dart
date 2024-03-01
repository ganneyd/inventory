import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_state.dart';
import 'package:logging/logging.dart';

class ManageInventoryCubit extends Cubit<ManageInventoryState> {
  ManageInventoryCubit(
      {int fetchPartAmount = 20,
      required this.getAllPartsUsecase,
      required this.getUnverifiedCheckoutParts,
      required this.getAllCheckoutParts,
      required this.getLowQuantityParts,
      required this.verifyCheckoutPartUsecase,
      required this.fulfillPartOrdersUsecase,
      required this.createPartOrderUsecase,
      required this.getAllPartOrdersUsecase,
      required EditPartUsecase editPartUsecase,
      required DiscontinuePartUsecase discontinuePartUsecase,
      required DeletePartOrderUsecase deletePartOrderUsecase})
      : _logger = Logger('manage-inv-cubit'),
        _editPartUsecase = editPartUsecase,
        _deletePartOrderUsecase = deletePartOrderUsecase,
        _discontinuePartUsecase = discontinuePartUsecase,
        super(ManageInventoryState(fetchPartAmount: fetchPartAmount));

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
  //for debugging
  final Logger _logger;
//initialization method
  void init() async {
    emit(state.copyWith(status: ManageInventoryStateStatus.loading));
    loadParts();
    loadCheckedOutParts();
    loadPartOrders();
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
            status: ManageInventoryStateStatus.fetchedDataUnsuccessfully)),
        (orders) {
      allPartOrdersList.addAll(orders);
      emit(state.copyWith(
        status: ManageInventoryStateStatus.fetchedDataSuccessfully,
        allPartOrders: allPartOrdersList,
      ));
    });
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

  void updatePart(PartEntity partEntity) {
    var editedList = state.editedParts.toList();
    var partsList = state.allParts.toList();
    editedList.add(partEntity);
    var index =
        partsList.indexWhere((element) => element.index == partEntity.index);
    if (index >= 0) {
      partsList[index] = partEntity;
    }
    emit(state.copyWith(editedParts: editedList, allParts: partsList));
  }

  void updateCheckoutQuantity({
    required CheckedOutEntity checkoutPart,
    required int quantityChange,
  }) {
    List<CheckedOutEntity> newCheckoutPartList = state.checkedOutParts.toList();
    var indexInList = newCheckoutPartList.indexOf(checkoutPart);

    var newCheckoutPart = checkoutPart.copyWith(
      checkedOutQuantity: checkoutPart.checkedOutQuantity + quantityChange,
      quantityDiscrepancy: checkoutPart.quantityDiscrepancy + quantityChange,
    );

    newCheckoutPartList[indexInList] = newCheckoutPart;
    emit(state.copyWith(
      checkedOutParts: newCheckoutPartList,
    ));
  }

  void verifyPart({required CheckedOutEntity checkedOutEntity}) {
    List<CheckedOutEntity> newVerifiedList = state.newlyVerifiedParts.toList();
    List<CheckedOutEntity> newCheckoutPartList = state.checkedOutParts.toList();
    List<PartEntity> newPartEntityList = state.allParts.toList();
    var indexInList = newCheckoutPartList.indexOf(checkedOutEntity);

    //update part

    var newCheckoutPart = checkedOutEntity.copyWith(
      isVerified: true,
      verifiedDate: DateTime.now(),
    );

    newCheckoutPartList[indexInList] = newCheckoutPart;
    var partIndex = newPartEntityList
        .indexWhere((part) => part.index == checkedOutEntity.partEntityIndex);
    var partEntity = newPartEntityList[partIndex];
    //reflect change in the parts list
    newPartEntityList[partIndex] = partEntity.copyWith(
        quantity: partEntity.quantity - newCheckoutPart.quantityDiscrepancy);
    //add checkout part to verified list
    newVerifiedList.add(newCheckoutPart);
    //emit changes
    emit(state.copyWith(
        newlyVerifiedParts: newVerifiedList,
        checkedOutParts: newCheckoutPartList,
        allParts: newPartEntityList));
  }

  void fulfillPartOrder({required OrderEntity orderEntity}) {
    List<PartEntity> allParts = state.allParts.toList();
    List<OrderEntity> allPartOrders = state.allPartOrders.toList();
    List<OrderEntity> newlyFulfilledPartOrders =
        state.newlyFulfilledPartOrders.toList();
    var index = allPartOrders.indexOf(orderEntity);
    var fulfilledOrder = allPartOrders[index]
        .copyWith(fulfillmentDate: DateTime.now(), isFulfilled: true);
    allPartOrders[index] = fulfilledOrder;
    var partIndex = allParts
        .indexWhere((part) => part.index == fulfilledOrder.partEntityIndex);

    var partEntity = allParts[partIndex];

    partEntity = partEntity.copyWith(
        quantity: partEntity.quantity + fulfilledOrder.orderAmount);

    allParts[partIndex] = partEntity;

    newlyFulfilledPartOrders.add(fulfilledOrder);

    emit(state.copyWith(
        allPartOrders: allPartOrders,
        newlyFulfilledPartOrders: newlyFulfilledPartOrders,
        allParts: allParts));
  }

  ///order parts methods
  void orderPart(
      {required int orderAmount, required int partEntityIndex}) async {
    emit(state.copyWith(status: ManageInventoryStateStatus.creatingPartOrder));
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
      emit(state.copyWith(
          status: ManageInventoryStateStatus.createdPartOrderUnsuccessfully));
    }, (_) {
      emit(state.copyWith(
        status: ManageInventoryStateStatus.createdPartOrderSuccessfully,
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
              error: failure.errorMessage,
              status: ManageInventoryStateStatus.updatedDataUnsuccessfully)),
          (_) {
        //remove all current orders for this discontinued part and add it to the list to be deleted
        allParts[index] = partEntity.copyWith(isDiscontinued: true);
        emit(state.copyWith(
            allPartOrders: [],
            allParts: allParts,
            status: ManageInventoryStateStatus.updatedDataSuccessfully));
        loadPartOrders();
      });
    }
  }

  void deletePartOrder({required OrderEntity orderEntity}) async {
    emit(state.copyWith(status: ManageInventoryStateStatus.deletingPartOrder));
    var partOrders = state.allPartOrders.toList();

    var results = await _deletePartOrderUsecase
        .call(DeletePartOrderParams(orderEntity: orderEntity));

    results.fold(
        (failure) => emit(state.copyWith(
            status: ManageInventoryStateStatus.deletedPartOrderUnsuccessfully)),
        (_) {
      partOrders.remove(orderEntity);

      emit(state.copyWith(
        status: ManageInventoryStateStatus.deletedPartOrderSuccessfully,
        allPartOrders: partOrders,
      ));
    });
  }

  void restockPart(
      {required PartEntity partEntity, required int newQuantity}) async {
    emit(state.copyWith(status: ManageInventoryStateStatus.updatingData));
    var restockedPart =
        partEntity.copyWith(isDiscontinued: false, quantity: newQuantity);
    var results =
        await _editPartUsecase.call(EditPartParams(partEntity: restockedPart));

    results.fold(
        (failure) => emit(state.copyWith(
            error: failure.errorMessage,
            status: ManageInventoryStateStatus.updatedDataUnsuccessfully)),
        (_) {
      var allParts = state.allParts.toList();
      var partIndex =
          allParts.indexWhere((part) => part.index == partEntity.index);
      allParts[partIndex] = restockedPart;
      emit(state.copyWith(
          status: ManageInventoryStateStatus.updatedDataSuccessfully,
          allParts: allParts));
    });
  }

  Future<void> _updateDatabase() async {
    _logger.finest('placing verified parts in the database');
    emit(state.copyWith(status: ManageInventoryStateStatus.verifyingPart));

    for (var part in state.editedParts) {
      _editPartUsecase.call(EditPartParams(partEntity: part));
    }
    await verifyCheckoutPartUsecase.call(VerifyCheckoutPartParams(
        checkedOutEntityList: state.newlyVerifiedParts));
    await fulfillPartOrdersUsecase.call(FulfillPartOrdersParams(
        fulfillmentEntities: state.newlyFulfilledPartOrders));
  }

  @override
  Future<void> close() async {
    await _updateDatabase();
    super.close();
  }
}
