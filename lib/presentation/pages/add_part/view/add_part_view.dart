import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/add_part/cubit/add_part_cubit.dart';
import 'package:inventory_v1/presentation/pages/add_part/cubit/add_part_state.dart';
import 'package:inventory_v1/presentation/widgets/buttons/small_button_widget.dart';
import 'package:inventory_v1/presentation/widgets/form/form_fields_widget.dart';
import 'package:inventory_v1/presentation/widgets/form/part_form_widget.dart';
import 'package:inventory_v1/presentation/widgets/generic_app_bar_widget.dart';
import 'package:inventory_v1/presentation/widgets/part_display_card_widget.dart';
import 'package:inventory_v1/service_locator.dart';

class AddPartView extends StatelessWidget {
  const AddPartView() : super(key: const Key('add-part-view-constructor'));

  void _showQuantityDialog(BuildContext context, PartEntity selectedPart) {
    // Initialize a TextEditingController to capture the quantity input
    TextEditingController quantityController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Center(
              child: Text('Enter quantity to add to ${selectedPart.name}')),
          content: SizedBox(
              width: MediaQuery.of(context).size.width * .75,
              height: MediaQuery.of(context).size.height * .50,
              child: Center(
                child: Form(
                  key: formKey,
                  child: CustomTextField(
                    isNumberInput: true,
                    controller: quantityController,
                    hintText: 'Quantity to add',
                  ),
                ),
              )),
          actionsPadding: const EdgeInsets.all(20),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: <Widget>[
            SmallButton(
                buttonName: 'Cancel',
                onPressed: () {
                  BlocProvider.of<AddPartCubit>(context)
                      .updateQuantity(additionalQuantity: 0);
                  Navigator.of(dialogContext).pop();
                }),
            SmallButton(
              buttonName: 'Update',
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  BlocProvider.of<AddPartCubit>(context).updateQuantity(
                      partEntity: selectedPart,
                      additionalQuantity:
                          int.tryParse(quantityController.text) ?? 0);
                  // Here you can handle what happens when the dialog is forcibly closed if you want
                  // For instance, you could navigate back or reset the form
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
      barrierDismissible: false, // Preve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddPartCubit>(
      create: (context) => AddPartCubit(
          editPartUsecase: locator<EditPartUsecase>(),
          getPartByNsnUseCase: locator<GetPartByNsnUseCase>(),
          addPartUsecase: locator<AddPartUsecase>()),
      child: BlocConsumer<AddPartCubit, AddPartState>(
          listenWhen: (previous, current) {
        // Return true if you want the listener to be called
        return current.addPartStateStatus == AddPartStateStatus.foundMatches;
      }, buildWhen: (previous, current) {
        // Return true only if you want the UI to rebuild
        // You might want to compare specific parts of the state
        return current.addPartStateStatus != AddPartStateStatus.foundMatches
            ? current.addPartStateStatus != AddPartStateStatus.searched
            : false;
      }, builder: (context, state) {
        if (state.addPartStateStatus == AddPartStateStatus.loading) {
          return const CircularProgressIndicator();
        }

        if (state.addPartStateStatus == AddPartStateStatus.creatingData) {
          return const Scaffold(
            body: Column(
                children: [Text('Creating data'), CircularProgressIndicator()]),
          );
        }

        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          if (state.addPartStateStatus ==
              AddPartStateStatus.createdDataSuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                content: Text('created part : ${state.part?.nsn}')));
          }
          if (state.addPartStateStatus ==
              AddPartStateStatus.updatedQuantitySuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                content: Text(
                    'Updated quantity for part : ${state.part?.nsn} ${state.part?.name}, new quantity is ${state.part?.quantity}')));
          }

          if (state.addPartStateStatus ==
              AddPartStateStatus.createdDataUnsuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
                content: Text('Unable to save part ${state.error}')));
          }
          if (state.addPartStateStatus ==
              AddPartStateStatus.updatedQuantityUnsuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
                content:
                    Text('Unable to update part quantity ${state.error}')));
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
                    nsnCompleted: ({required nsn}) =>
                        BlocProvider.of<AddPartCubit>(context)
                            .checkIfPartExists(nsn: nsn),
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
      }, listener: (context, state) {
        if (state.addPartStateStatus == AddPartStateStatus.foundMatches) {
          showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: const Center(
                    child: Text('Part already exist in BenchStock')),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * .75,
                  height: MediaQuery.of(context).size.height * .50,
                  child: SingleChildScrollView(
                      child: ListBody(
                    children: state.existingParts
                        .map((part) => PartCardDisplay(
                            callback: () {
                              Navigator.of(dialogContext).pop();
                              _showQuantityDialog(context, part);
                            },
                            left: part.nsn,
                            center: part.name,
                            right: part.location,
                            bottom: part.quantity.toString()))
                        .toList(),
                  )),
                ),
                actionsPadding: const EdgeInsets.all(20),
                actionsAlignment: MainAxisAlignment.spaceAround,
                actions: <Widget>[
                  SmallButton(
                    buttonName: 'Place part in new Location',
                    onPressed: () {
                      BlocProvider.of<AddPartCubit>(context)
                          .updateQuantity(additionalQuantity: 0);
                      // Here you can handle what happens when the dialog is forcibly closed if you want
                      // For instance, you could navigate back or reset the form
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              );
            },
            barrierDismissible: false, // Preve,
          );
        }
      }),
    );
  }
}
