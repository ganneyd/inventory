import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/edit_part/cubit/edit_part_state.dart';

class EditPartCubit extends Cubit<EditPartState> {
  EditPartCubit(
      {required PartEntity partEntity,
      required EditPartUsecase editPartUsecase})
      : _editPartUsecase = editPartUsecase,
        super(EditPartState(partEntity: partEntity));

  final EditPartUsecase _editPartUsecase;
  void init() {
    emit(state.copyWith(status: EditPartStateStatus.loadedSuccessfully));
  }

  void editPart(PartEntity editPart) async {
    var results =
        await _editPartUsecase.call(EditPartParams(partEntity: editPart));
    emit(state.copyWith(status: EditPartStateStatus.updating));
    results.fold(
        (failure) => emit(state.copyWith(
            status: EditPartStateStatus.updatedUnsuccessfully,
            errorMsg: failure.errorMessage)),
        (_) => emit(
            state.copyWith(status: EditPartStateStatus.updatedSuccessfully)));
  }
}
