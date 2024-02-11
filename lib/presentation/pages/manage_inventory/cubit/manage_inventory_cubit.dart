import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/data/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_state.dart';
import 'package:logging/logging.dart';

class ManageInventoryCubit extends Cubit<ManageInventoryState> {
  ManageInventoryCubit(
      {int fetchPartAmount = 20,
      required this.getAllPartsUsecase,
      required this.getDatabaseLength,
      required this.getUnverifiedCheckoutParts,
      required this.getAllCheckoutParts,
      required this.getLowQuantityParts,
      required this.verifyCheckoutPartUsecase,
      required ScrollController scrollController})
      : _logger = Logger('manage-inv-cubit'),
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

  Future<void> loadCheckedOutParts() async {
    // Indicate loading state, especially useful for UI indicators
    emit(state.copyWith(status: ManageInventoryStateStatus.loading));

    var startIndex = state.checkedOutParts.length;
    var endIndex = startIndex + state.fetchPartAmount;
    List<CheckedOutEntity> oldCheckoutPartList = state.checkedOutParts.toList();

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

  void loadUnverifiedParts({bool verifiedPartSuccessfully = false}) async {
    // Assuming loadCheckedOutParts() updates state.checkedOutParts correctly
    await loadCheckedOutParts();

    // Efficiently filter out unverified parts
    var newUnverifiedList = state.checkedOutParts
        .where((part) => !(part.isVerified ?? true))
        .toList();

    emit(state.copyWith(
      unverifiedParts: newUnverifiedList,
      // Update the status only if verification was successful
      status: verifiedPartSuccessfully
          ? ManageInventoryStateStatus.verifiedPartSuccessfully
          : state.status,
    ));

    _logger
        .finest('state has ${state.unverifiedParts.length} unverified parts');
  }

  void loadLowQuantityParts() async {
    loadParts();
    List<PartEntity> newLowQuantityList = [];
    for (var part in state.parts) {
      if (part.quantity <= part.requisitionPoint) {
        newLowQuantityList.add(part);
      }
    }
    emit(state.copyWith(lowQuantityParts: newLowQuantityList));
  }

  void verifyCheckoutPart(CheckedOutEntity checkoutPart) async {
    emit(state.copyWith(status: ManageInventoryStateStatus.verifyingPart));

    var results = await verifyCheckoutPartUsecase
        .call(VerifyCheckoutPartParams(checkedOutEntity: checkoutPart));

    results.fold(
        (fail) => emit(state.copyWith(
            error: fail.errorMessage,
            status: ManageInventoryStateStatus.verifiedPartUnsuccessfully)),
        (_) {
      // Directly move to loading unverified parts without clearing the lists
      loadUnverifiedParts(verifiedPartSuccessfully: true);
    });
  }
}
