import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/edit_part/cubit/edit_part_cubit.dart';
import 'package:inventory_v1/presentation/pages/edit_part/cubit/edit_part_state.dart';
import 'package:inventory_v1/presentation/widgets/form/part_form_widget.dart';
import 'package:inventory_v1/presentation/widgets/generic_app_bar_widget.dart';
import 'package:inventory_v1/service_locator.dart';

class EditPartView extends StatelessWidget {
  const EditPartView({required PartEntity partEntity})
      : _partEntity = partEntity,
        super(key: const Key('edit-part-view-constructor'));
  final PartEntity _partEntity;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditPartCubit>(
        create: (_) => EditPartCubit(
              editPartUsecase: locator<EditPartUsecase>(),
              partEntity: _partEntity,
            )..init(),
        child: BlocBuilder<EditPartCubit, EditPartState>(
            builder: (context, state) {
          if (state.status == EditPartStateStatus.loading) {
            return const CircularProgressIndicator();
          }

          if (state.status == EditPartStateStatus.updating) {
            return const Scaffold(
              body: Column(children: [
                Text('Editing part'),
                CircularProgressIndicator()
              ]),
            );
          }

          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            if (state.status == EditPartStateStatus.updatedSuccessfully) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(milliseconds: 100),
                  content: Text('edited part : ${state.partEntity.nsn}')));
              Navigator.of(context).pop();
            }
            if (state.status == EditPartStateStatus.updatedUnsuccessfully) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Text('Unable to edit part ${state.errorMsg}')));
            }
          });

          return LayoutBuilder(builder: (builder, constraints) {
            return Scaffold(
                appBar: const CustomAppBar(
                    key: Key('edit-part-app-bar'), title: 'Edit Part'),
                body: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: PartForm(
                      buttonName: 'Update',
                      partEntity: state.partEntity,
                      key: const Key('edit-part-form'),
                      formKey: GlobalKey<FormState>(),
                      addPart: (
                              {required location,
                              required name,
                              required nsn,
                              required partNumber,
                              required quantity,
                              required requisitionPoint,
                              required requisitionQuantity,
                              required serialNumber,
                              required unitOfIssue}) =>
                          BlocProvider.of<EditPartCubit>(context).editPart(
                              PartEntity(
                                  isDiscontinued: _partEntity.isDiscontinued,
                                  checksum: _partEntity.checksum,
                                  index: _partEntity.index,
                                  nsn: nsn,
                                  name: name,
                                  partNumber: partNumber,
                                  location: location,
                                  quantity: int.tryParse(quantity) ?? -1,
                                  requisitionPoint:
                                      int.tryParse(requisitionPoint) ?? -1,
                                  requisitionQuantity:
                                      int.tryParse(requisitionQuantity) ?? -1,
                                  serialNumber: serialNumber,
                                  unitOfIssue: unitOfIssue)),
                    )));
          });
        }));
  }
}
