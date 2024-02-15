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

    var startIndex = state.checkedOutParts.length;
    var endIndex = startIndex + state.fetchPartAmount;
    List<CheckedOutEntity> oldCheckoutPartList = state.checkedOutParts.toList();
    oldCheckoutPartList = oldCheckoutPartList
        .map((checkoutPart) => checkoutPart.isVerified ?? false
            ? checkoutPart
            : checkoutPart.copyWith(
                partEntity: _getAccuratePart(checkoutPart.part)))
        .toList();
    _logger.finest(
        'loading checked out parts, startIndex:$startIndex endIndex:$endIndex');

    var results = await getAllCheckoutParts.call(
        GetAllCheckoutPartsParams(endIndex: endIndex, startIndex: startIndex));

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
          checkedOutParts: oldCheckoutPartList));
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
      checkedOutParts: newCheckoutPartList,
    ));
    filterUnverifiedParts();
  }

  PartEntity _getAccuratePart(PartEntity part) {
    var accuratePart = part;
    _logger.finest(
        'checksum ${part.checksum} state part: ${state.parts[part.index].checksum} failed ${part.name}  ${part.quantity}ea');
    if (state.parts[part.index].checksum != part.checksum) {
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

    var newCheckoutPart = checkedOutEntity.copyWith(
        isVerified: true, verifiedDate: DateTime.now());
    var updatedPart = checkedOutEntity.part;
    _logger.finest(
        'updated part has ${updatedPart.quantity}ea and the discrepancy is ${checkedOutEntity.quantityDiscrepancy}');
    updatedPart = updatedPart.updateChecksum();
    newCheckoutPart = newCheckoutPart.copyWith(partEntity: updatedPart);
    newCheckoutPartList[checkedOutEntity.index] = newCheckoutPart;
    newCheckoutPartList = newCheckoutPartList
        .map((checkoutPart) => checkoutPart.isVerified ?? false
            ? checkoutPart
            : checkoutPart.copyWith(
                partEntity: _getAccuratePart(checkoutPart.part)))
        .toList();
    newPartEntityList[checkedOutEntity.part.index] = updatedPart;
    newVerifiedList.add(newCheckoutPart);
    emit(state.copyWith(
        newlyVerifiedParts: newVerifiedList,
        checkedOutParts: newCheckoutPartList,
        parts: newPartEntityList));

    filterUnverifiedParts();
  }

  void filterUnverifiedParts() {
    List<CheckedOutEntity> unverifiedList =
        state.checkedOutParts.where((checkoutPart) {
      return !(checkoutPart.isVerified ?? false);
    }).toList();

    unverifiedList = unverifiedList.map((checkoutPart) {
      var newCheckoutPart = checkoutPart.copyWith(
          partEntity: _getAccuratePart(checkoutPart.part));
      return newCheckoutPart;
    }).toList();

    emit(state.copyWith(
      unverifiedParts: unverifiedList,
    ));
  }

  @override
  Future<void> close() async {
    await updateDatabaseWithVerifiedParts();
    super.close();
  }
}
