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
      required DeletePartOrderUsecase deletePartOrderUsecase})
      : _logger = Logger('manage-inv-cubit'),
        _deletePartOrderUsecase = deletePartOrderUsecase,
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

    var partEntity = newPartEntityList[checkedOutEntity.partEntityIndex];
    //reflect change in the parts list
    newPartEntityList[checkedOutEntity.partEntityIndex] = partEntity.copyWith(
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
    var partEntity = allParts[fulfilledOrder.partEntityIndex];

    partEntity = partEntity.copyWith(
        quantity: partEntity.quantity + fulfilledOrder.orderAmount);

    allParts[partEntity.index] = partEntity;

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

  Future<void> _updateDatabase() async {
    _logger.finest('placing verified parts in the database');
    emit(state.copyWith(status: ManageInventoryStateStatus.verifyingPart));

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
