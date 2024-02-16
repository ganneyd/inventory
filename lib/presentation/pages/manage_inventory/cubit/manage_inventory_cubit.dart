import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_state.dart';
import 'package:logging/logging.dart';

class ManageInventoryCubit extends Cubit<ManageInventoryState> {
  ManageInventoryCubit({
    int fetchPartAmount = 20,
    required this.getAllPartsUsecase,
    required this.getDatabaseLength,
    required this.getUnverifiedCheckoutParts,
    required this.getAllCheckoutParts,
    required this.getLowQuantityParts,
    required this.verifyCheckoutPartUsecase,
  })  : _logger = Logger('manage-inv-cubit'),
        super(ManageInventoryState(fetchPartAmount: fetchPartAmount));

  //usecase init
  final GetAllPartsUsecase getAllPartsUsecase;
  final GetLowQuantityParts getLowQuantityParts;
  final GetDatabaseLength getDatabaseLength;
  final GetUnverifiedCheckoutParts getUnverifiedCheckoutParts;
  final VerifyCheckoutPart verifyCheckoutPartUsecase;
  final GetAllCheckoutParts getAllCheckoutParts;
  //for debugging
  final Logger _logger;

  ///Method uses the [GetAllPartsUsecase] to retrieve the parts lazily
  void loadParts() async {
    //set the indexes that the parts should be gotten from
    var startIndex = state.parts.length;
    //retrieve 20 elements at a time
    var pageIndex = startIndex + state.fetchPartAmount;
    //get the current list of parts
    List<PartEntity> oldList = state.parts.toList();
    //!debug
    _logger
        .finest('loading parts, startIndex:$startIndex pageIndex:$pageIndex');

    var results = await getAllPartsUsecase
        .call(GetAllPartParams(pageIndex: pageIndex, startIndex: startIndex));

    //unfold the results and return proper data to the UI
    results.fold((l) {
      //!debug
      _logger.warning('error while retrieving all parts');
      //emit the state with the error message and status
      emit(state.copyWith(
          error: l.errorMessage,
          status: ManageInventoryStateStatus.fetchedDataUnsuccessfully));
    }, (newParts) {
      for (var part in newParts) {
        oldList.add(part);
      }
      _logger.finest('retrieved all parts: ${state.parts.length}');
      //emit the state with the retrieved parts and status
      emit(state.copyWith(
          status: ManageInventoryStateStatus.fetchedDataSuccessfully,
          parts: oldList));
    });
  }

  //initialization method
  void init() async {
    var length = await getDatabaseLength.call(NoParams());
    //load up the first 20 parts
    //tell the UI the data is loading
    length.fold(
        (l) => emit(state.copyWith(databaseLength: 0)),
        (r) => emit(state.copyWith(
            databaseLength: r, status: ManageInventoryStateStatus.loading)));
    loadParts();
    loadCheckedOutParts();
  }

  void loadCheckedOutParts() async {
    // Indicate loading state, especially useful for UI indicators
    emit(state.copyWith(status: ManageInventoryStateStatus.loading));

    List<CheckedOutEntity> oldCheckoutPartList =
        _updateCheckoutListParts(state.checkedOutParts.toList());

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
          unverifiedParts: _filterUnverifiedParts(oldCheckoutPartList)));
      _logger.finest(
          'state has ${state.checkedOutParts.length} checked out parts');
    });
  }

  void filterLowQuantityParts() async {
    List<PartEntity> newLowQuantityList = state.parts
        .where((part) => part.quantity <= part.requisitionPoint)
        .toList();

    emit(state.copyWith(lowQuantityParts: newLowQuantityList));
  }

  Future<void> updateDatabaseWithVerifiedParts() async {
    _logger.finest('placing verified parts in the database');
    emit(state.copyWith(status: ManageInventoryStateStatus.verifyingPart));

    await verifyCheckoutPartUsecase.call(VerifyCheckoutPartParams(
        checkedOutEntityList: state.newlyVerifiedParts));
  }

  void updateCheckoutQuantity({
    required CheckedOutEntity checkoutPart,
    required int quantityChange,
  }) {
    List<CheckedOutEntity> newCheckoutPartList = state.checkedOutParts.toList();
    var accuratePart = _getAccuratePart(checkoutPart.part);
    var newPart = accuratePart.copyWith(
        quantity: checkoutPart.part.quantity - quantityChange);
    var newCheckoutPart = checkoutPart.copyWith(
        checkedOutQuantity: checkoutPart.checkedOutQuantity + quantityChange,
        quantityDiscrepancy: checkoutPart.quantityDiscrepancy + quantityChange,
        partEntity: newPart);

    newCheckoutPartList[checkoutPart.index] = newCheckoutPart;
    emit(state.copyWith(
      unverifiedParts: _filterUnverifiedParts(newCheckoutPartList),
      checkedOutParts: newCheckoutPartList,
    ));
  }

  PartEntity _getAccuratePart(PartEntity part) {
    var accuratePart = part;

    _logger.finest(
        'checksum ${part.checksum} state part: ${state.parts[part.index].checksum} failed ${part.name}  ${part.quantity}ea');

    if (state.parts[part.index].checksum != part.checksum &&
        state.parts[part.index].checksum > part.checksum) {
      _logger.finest(
          'checksum ${part.checksum} does not match ${state.parts[part.index].checksum} failed ${part.name}  ${part.quantity}ea');
      accuratePart = state.parts[part.index];
    }
    return accuratePart;
  }

  void verifyPart({required CheckedOutEntity checkedOutEntity}) {
    List<CheckedOutEntity> newVerifiedList = state.newlyVerifiedParts.toList();
    List<CheckedOutEntity> newCheckoutPartList = state.checkedOutParts.toList();
    List<PartEntity> newPartEntityList = state.parts.toList();

    var updatedPart = checkedOutEntity.part.updateChecksum();
    _logger.finest(
        'updated part has ${updatedPart.quantity}ea and the discrepancy is ${checkedOutEntity.quantityDiscrepancy}');

    //update part

    var newCheckoutPart = checkedOutEntity.copyWith(
        isVerified: true,
        verifiedDate: DateTime.now(),
        partEntity: updatedPart);

    newCheckoutPartList[checkedOutEntity.index] = newCheckoutPart;
    newCheckoutPartList =
        _updatePartInCheckoutPartsList(newCheckoutPartList, updatedPart);
    //reflect change in the parts list
    newPartEntityList[checkedOutEntity.part.index] = updatedPart;
    //add checkout part to verified list
    newVerifiedList.add(newCheckoutPart);
    //emit changes
    emit(state.copyWith(
        unverifiedParts: _filterUnverifiedParts(newCheckoutPartList),
        newlyVerifiedParts: newVerifiedList,
        checkedOutParts: newCheckoutPartList,
        parts: newPartEntityList));
  }

  List<CheckedOutEntity> _filterUnverifiedParts(
      List<CheckedOutEntity> checkoutEntityList) {
    return checkoutEntityList.expand<CheckedOutEntity>((checkoutPart) {
      if (checkoutPart.isVerified ?? false) return [];

      return [
        checkoutPart.copyWith(partEntity: _getAccuratePart(checkoutPart.part))
      ];
    }).toList();
  }

  List<CheckedOutEntity> _updateCheckoutListParts(
    List<CheckedOutEntity> checkoutEntityList,
  ) {
    return checkoutEntityList
        .map((checkoutPart) => checkoutPart.isVerified ?? false
            ? checkoutPart
            : checkoutPart.copyWith(
                partEntity: _getAccuratePart(checkoutPart.part)))
        .toList();
  }

  List<CheckedOutEntity> _updatePartInCheckoutPartsList(
      List<CheckedOutEntity> checkoutEntityList, PartEntity part) {
    return checkoutEntityList
        .map((checkoutPart) => checkoutPart.isVerified ?? false
            ? checkoutPart
            : checkoutPart.copyWith(
                checkedOutQuantity: checkoutPart.part.index == part.index
                    ? checkoutPart.checkedOutQuantity -
                        checkoutPart.quantityDiscrepancy
                    : null,
                quantityDiscrepancy:
                    checkoutPart.part.index == part.index ? 0 : null,
                partEntity: checkoutPart.part.index == part.index
                    ? part
                    : checkoutPart.part))
        .toList();
  }

  @override
  Future<void> close() async {
    await updateDatabaseWithVerifiedParts();
    super.close();
  }
}
