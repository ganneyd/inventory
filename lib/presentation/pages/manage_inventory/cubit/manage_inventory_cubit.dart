import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/domain/models/part/part_model.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_state.dart';
import 'package:logging/logging.dart';

class ManageInventoryCubit extends Cubit<ManageInventoryState> {
  ManageInventoryCubit(PartRepository partRepository)
      : _getAllPartsUsecase = GetAllPartsUsecase(partRepository),
        _logger = Logger('manage-inv-cubit'),
        super(ManageInventoryState(scrollController: ScrollController()));

  //usecase init
  final GetAllPartsUsecase _getAllPartsUsecase;
  //for debugging
  final Logger _logger;
  void loadParts() async {
    //set the indexes that the parts should be gotten from
    var startIndex = state.parts.length;
    var pageIndex = startIndex + 20;
    //get the current list of parts
    List<Part> oldList = state.parts.toList();
    //!debug
    _logger
        .finest('loading parts, startIndex:$startIndex pageIndex:$pageIndex');

    var results = await _getAllPartsUsecase
        .call(GetAllPartParams(pageIndex: pageIndex, startIndex: startIndex));

    //unfold the results and return proper data to the UI
    results.fold((l) {
      //!debug
      _logger.warning('error while retrieving all parts');
      emit(state.copyWith(
          error: l.errorMessage,
          status: ManageInventoryStateStatus.fetchedDataUnsuccessfully));
    }, (newParts) {
      for (var part in newParts) {
        oldList.add(part);
      }
      _logger.finest('retrieved all parts: ${state.parts.length}');
      emit(state.copyWith(
          status: ManageInventoryStateStatus.fetchedDataSuccessfully,
          parts: oldList));
    });
  }

  //initialization method
  void init() {
    //load up the first 20 parts
    //tell the UI the data is loading
    emit(state.copyWith(status: ManageInventoryStateStatus.loading));
    loadParts();
    //initialize the scroll controller callback function
    state.scrollController.addListener(() => _fetchMoreParts());
  }

  //method to fetch more parts when the user scrolls to the end of the list
  void _fetchMoreParts() {
    //check if user is actually at the end
    if (state.scrollController.position.pixels ==
        state.scrollController.position.maxScrollExtent) {
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
