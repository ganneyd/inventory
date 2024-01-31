import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_state.dart';
import 'package:logging/logging.dart';

class ManageInventoryCubit extends Cubit<ManageInventoryState> {
  ManageInventoryCubit({required PartRepository partRepository})
      : _getAllPartsUsecase = GetAllPartsUsecase(partRepository),
        _logger = Logger('manage-inventory-cubit'),
        _isFetching = false,
        super(ManageInventoryState(scrollController: ScrollController()));

  final GetAllPartsUsecase _getAllPartsUsecase;
  final Logger _logger;
  bool _isFetching;
  void loadParts() async {
    var startIndex = state.part.length;
    var pageIndex = startIndex + 20;
    List<Part> oldList = state.part.toList();
    _logger.finest(
        'loading parts into state startIndex is $startIndex and pageIndex is $pageIndex');
    emit(state.copyWith(
        manageInventoryStateStatus: ManageInventoryStateStatus.loading));
    _isFetching = true;

    //delay for a bit
    await Future.delayed(const Duration(milliseconds: 100));

    //evoke usecase
    var results = await _getAllPartsUsecase
        .call(GetAllPartParams(pageIndex: pageIndex, startIndex: startIndex));

    results.fold((l) {
      _logger
          .warning('error encountered while getting parts from usecase', [l]);
      emit(state.copyWith(
          error: 'Unable to get parts at the time',
          manageInventoryStateStatus: _isFetching
              ? ManageInventoryStateStatus.fetchedDataUnsuccessfully
              : ManageInventoryStateStatus.loadedUnsuccessfully));
    }, (newList) {
      for (var element in newList) {
        oldList.add(element);
      }

      emit(state.copyWith(
          part: oldList,
          manageInventoryStateStatus: _isFetching
              ? ManageInventoryStateStatus.fetchedDataSuccessfully
              : ManageInventoryStateStatus.loadedSuccessfully));
    });
    _logger.finest(
        'Retrieved a list of parts. emit list has length of ${state.part.length}');
  }

  void init() {
    loadParts();
    state.scrollController.addListener(() => _fetchMoreParts());
  }

  void _fetchMoreParts() {
    _logger.finest('fetching more parts ');
    if (state.scrollController.position.pixels ==
        state.scrollController.position.maxScrollExtent) {
      _logger.finest('scroll out of fetching more');
      emit(state.copyWith(
          manageInventoryStateStatus: ManageInventoryStateStatus.fetchingData));

      loadParts();
    }
  }

  @override
  Future<void> close() {
    state.scrollController.dispose();
    return super.close();
  }
}
