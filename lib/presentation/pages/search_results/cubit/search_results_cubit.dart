import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/core/util/main_section_enum.dart';
import 'package:inventory_v1/domain/entities/checked-out/cart_check_out_entity.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
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

  @override
  Future<void> close() {
    state.scrollController.dispose();
    state.searchBarController.dispose();
    return super.close();
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

  ///add parts to the checkout list
  void addPartToCart(
    PartEntity addPart,
    int quantity,
  ) {
    List<CartCheckoutEntity> cartCheckoutEntities = state.cartItems.toList();
    bool isPartInCart = false;

    for (var checkoutEntity in cartCheckoutEntities) {
      if (checkoutEntity.partEntity.index == addPart.index) {
        isPartInCart = true;
      }
    }

    if (quantity > 0 && !isPartInCart) {
      var newCartEntry = CheckedOutEntity(
          section: MaintenanceSection.unknown,
          taskName: '',
          aircraftTailNumber: '',
          checkoutUser: '',
          index: -1,
          checkedOutQuantity: quantity,
          dateTime: DateTime.now(),
          partEntityIndex: addPart.index,
          quantityDiscrepancy: 0);
      cartCheckoutEntities.add(CartCheckoutEntity(
          checkedOutEntity: newCartEntry, partEntity: addPart));
      emit(state.copyWith(cartItems: cartCheckoutEntities));
    }
  }

  void removeCheckoutPart(int checkoutPartIndex) {
    List<CartCheckoutEntity> newCartList = state.cartItems.toList();

    newCartList.removeAt(checkoutPartIndex);

    emit(state.copyWith(cartItems: newCartList));
  }

  void updateCheckoutQuantity(
      {required int checkoutPartIndex, required int newQuantity}) {
    var checkoutPart = state.cartItems[checkoutPartIndex].checkedOutEntity;

    var newCheckOutPart =
        checkoutPart.copyWith(checkedOutQuantity: newQuantity);
    List<CartCheckoutEntity> newCartList = state.cartItems.toList();
    newCartList[checkoutPartIndex] = newCartList[checkoutPartIndex]
        .copyWith(checkedOutEntity: newCheckOutPart);
    emit(state.copyWith(cartItems: newCartList));
  }

  void checkout() {
    emit(state.copyWith(
      cartItems: [],
    ));
  }
}
