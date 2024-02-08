import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_state.dart';
import 'package:logging/logging.dart';

class ManageInventoryCubit extends Cubit<ManageInventoryState> {
  ManageInventoryCubit(
      {int fetchPartAmount = 20,
      required this.getAllPartsUsecase,
      required this.getDatabaseLength,
      required ScrollController scrollController})
      : _logger = Logger('manage-inv-cubit'),
        super(ManageInventoryState(
            scrollController: scrollController,
            fetchPartAmount: fetchPartAmount));

  //usecase init
  final GetAllPartsUsecase getAllPartsUsecase;
  final GetDatabaseLength getDatabaseLength;
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
    //initialize the scroll controller callback function
    state.scrollController.addListener(_fetchMoreParts);
  }

  //method to fetch more parts when the user scrolls to the end of the list
  void _fetchMoreParts() async {
    //check if user is actually at the end
    if (state.scrollController.position.pixels ==
            state.scrollController.position.maxScrollExtent &&
        state.parts.length < state.databaseLength) {
      emit(state.copyWith(status: ManageInventoryStateStatus.fetchingData));
      loadParts();
    }
  }

//ensures the scroll controller is properly disposed of
  @override
  Future<void> close() {
    state.scrollController.dispose();
    return super.close();
  }
}
