import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/search_results/cubit/search_results_state.dart';

class SearchPartCubit extends Cubit<SearchResultsState> {
  //variables
  final GetPartByNameUseCase getPartByNameUseCase;
  final GetPartByNsnUseCase getPartByNsnUseCase;
  final GetPartByPartNumberUsecase getPartByPartNumberUsecase;
  final GetPartBySerialNumberUsecase getPartBySerialNumberUsecase;

  ///Constructor
  SearchPartCubit({
    required TextEditingController editingController,
    required ScrollController scrollController,
    required this.getPartByNameUseCase,
    required this.getPartByNsnUseCase,
    required this.getPartByPartNumberUsecase,
    required this.getPartBySerialNumberUsecase,
  }) : super(SearchResultsState(
            scrollController: scrollController,
            searchBarController: editingController));

  //init
  void init() {
    state.scrollController.addListener(_fetchMoreParts);
    state.searchBarController.addListener(() {
      if (state.searchBarController.text.isNotEmpty) {
        emit(
            state.copyWith(status: SearchResultsStateStatus.textFieldNotEmpty));
      } else {
        emit(state.copyWith(status: SearchResultsStateStatus.textFieldEmpty));
      }
    });
    searchPart();
  }

  //method to fetch more parts when the user scrolls to the end of the list
  void _fetchMoreParts() async {
    //check if user is actually at the end
    if (state.scrollController.position.pixels ==
        state.scrollController.position.maxScrollExtent) {
      //do something
    }
  }

  void searchPart() async {
    //clear the lists already in the state
    emit(state.copyWith(
        status: SearchResultsStateStatus.loading,
        partsByName: [],
        partsByNsn: [],
        partsByPartNumber: [],
        partsBySerialNumber: []));
    if (state.searchBarController.text != '') {
      //evoke the usecase calls
      var searchName = await getPartByNameUseCase.call(
          GetAllPartByNameParams(queryKey: state.searchBarController.text));
      var searchNSN = await getPartByNsnUseCase.call(
          GetAllPartByNsnParams(queryKey: state.searchBarController.text));
      var searchSerial = await getPartBySerialNumberUsecase.call(
          GetAllPartBySerialNumberParams(
              queryKey: state.searchBarController.text));
      var searchPartNumber = await getPartByPartNumberUsecase.call(
          GetAllPartByPartNumberParams(
              queryKey: state.searchBarController.text));

      //unfold the results
      bool success = true;
      String errorMessage = '';
      //name
      searchName.fold((l) => success = false,
          (list) => emit(state.copyWith(partsByName: list)));
      //nsn
      searchNSN.fold((l) => success = false,
          (list) => emit(state.copyWith(partsByNsn: list)));
      //serial number
      searchSerial.fold((l) => success = false,
          (list) => emit(state.copyWith(partsBySerialNumber: list)));
      //part number
      searchPartNumber.fold((l) => success = false,
          (list) => emit(state.copyWith(partsByPartNumber: list)));

//if there was an error do emit the message with searchUnsuccessful,
// but if they weren't then emit that the search result was successful
      if (success) {
        if (state.partsByName.isEmpty &&
            state.partsByNsn.isEmpty &&
            state.partsByPartNumber.isEmpty &&
            state.partsBySerialNumber.isEmpty) {
          emit(state.copyWith(status: SearchResultsStateStatus.searchNotFound));
        } else {
          emit(state.copyWith(
              status: SearchResultsStateStatus.searchSuccessful));
        }
      } else {
        emit(state.copyWith(
            error: errorMessage,
            status: SearchResultsStateStatus.searchUnsuccessful));
      }
    } else {
      //if the search key was empty return this
      emit(state.copyWith(
          error:
              'Please enter a NSN,Part Number, Nomenclature or Serial Number',
          status: SearchResultsStateStatus.loadedUnsuccessfully));
    }
  }
}
