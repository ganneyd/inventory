import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/add_part/cubit/add_part_cubit.dart';
import 'package:inventory_v1/presentation/pages/add_part/cubit/add_part_state.dart';
import 'package:inventory_v1/presentation/widgets/form/part_form_widget.dart';
import 'package:inventory_v1/presentation/widgets/generic_app_bar_widget.dart';
import 'package:inventory_v1/service_locator.dart';

class AddPartView extends StatelessWidget {
  const AddPartView() : super(key: const Key('add-part-view-constructor'));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddPartCubit>(
        create: (_) => AddPartCubit(
            addPartUsecase: locator<AddPartUsecase>(),
            formKey: GlobalKey<FormState>(),
            nsnController: TextEditingController(),
            nomenclatureController: TextEditingController(),
            partNumberController: TextEditingController(),
            requisitionPointController: TextEditingController(),
            requisitionQuantityController: TextEditingController(),
            quantityController: TextEditingController(),
            serialNumberController: TextEditingController(),
            locationController: TextEditingController()),
        child:
            BlocBuilder<AddPartCubit, AddPartState>(builder: (context, state) {
          if (state.addPartStateStatus == AddPartStateStatus.loading) {
            return const CircularProgressIndicator();
          }

          if (state.addPartStateStatus == AddPartStateStatus.creatingData) {
            return const Scaffold(
              body: Column(children: [
                Text('Creating data'),
                CircularProgressIndicator()
              ]),
            );
          }

          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            if (state.addPartStateStatus ==
                AddPartStateStatus.createdDataSuccessfully) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(milliseconds: 100),
                  content: Text('created part : ${state.part?.nsn}')));
            }
            if (state.addPartStateStatus ==
                AddPartStateStatus.createdDataUnsuccessfully) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Text('Unable to save part ${state.error}')));
            }
          });

          return LayoutBuilder(builder: (builder, constraints) {
            return Scaffold(
                appBar: const CustomAppBar(
                    key: Key('add-part-app-bar'), title: 'Add Part'),
                body: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: PartForm(
                      key: const Key('add-part-form'),
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
                          BlocProvider.of<AddPartCubit>(context).addPart(
                              nsn: nsn,
                              name: name,
                              partNumber: partNumber,
                              location: location,
                              quantity: quantity,
                              requisitionPoint: requisitionPoint,
                              requisitionQuantity: requisitionQuantity,
                              serialNumber: serialNumber,
                              unitOfIssue: unitOfIssue)),
                ));
          });
        }));
  }
}
