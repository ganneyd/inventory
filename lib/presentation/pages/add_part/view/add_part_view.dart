import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/presentation/pages/add_part/cubit/add_part_cubit.dart';
import 'package:inventory_v1/presentation/pages/add_part/cubit/add_part_state.dart';
import 'package:inventory_v1/presentation/widgets/widget_bucket.dart';

class AddPartView extends StatelessWidget {
  AddPartView() : super(key: const Key('add-part-view-constructor'));

  final double paddingValue = 200.0;
//method to return the text fields wrapped in a padding along with a sized box
//between each text field
// Function to wrap widgets with Padding and SizedBox
  Widget _wrapWithPadding(List<Widget> widgets, double paddingValue) {
    List<Widget> wrappedWidgets = [];

    // Loop through the widgets and wrap each one with Padding and SizedBox
    for (int i = 0; i < widgets.length; i++) {
      wrappedWidgets.add(
        Expanded(
          flex: 3,
          child: widgets[i],
        ),
      );

      if (i != widgets.length - 1) {
        wrappedWidgets.add(const Expanded(flex: 1, child: SizedBox()));
      }
    }

    // Return a Column with the wrapped widgets
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingValue),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: wrappedWidgets,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddPartCubit>(
        create: (_) => AddPartCubit(AddPartState(
              addPartStateStatus: AddPartStateStatus.loadedSuccessfully,
              locationController: TextEditingController(),
              nsnController: TextEditingController(),
              nomenclatureController: TextEditingController(),
              partNumberController: TextEditingController(),
              requisitionPointController: TextEditingController(),
              requisitionQuantityController: TextEditingController(),
              quantityController: TextEditingController(),
              unitOfIssueController: TextEditingController(),
              serialNumberController: TextEditingController(),
            )),
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
                  duration: const Duration(seconds: 2),
                  content: Text('created part : ${state.part}')));
            }
          });

          if (state.addPartStateStatus ==
              AddPartStateStatus.createdDataUnsuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 2),
                content: Text('Unable to save part ${state.error}')));
          }

          return LayoutBuilder(builder: (builder, constraints) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Add Part'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _wrapWithPadding([
                          CustomTextField(
                              controller: state.nsnController, hintText: 'NSN'),
                          CustomTextField(
                              controller: state.nomenclatureController,
                              hintText: 'NOMENCLATURE'),
                        ], paddingValue),
                        _wrapWithPadding([
                          CustomTextField(
                              controller: state.partNumberController,
                              hintText: 'PART NO.'),
                          CustomTextField(
                              controller: state.locationController,
                              hintText: 'LOCATION'),
                        ], paddingValue),
                        _wrapWithPadding([
                          CustomTextField(
                              controller: state.serialNumberController,
                              hintText: 'SERIAL NUMBER'),
                          CustomTextField(
                              controller: state.unitOfIssueController,
                              hintText: 'UNIT OF ISSUE'),
                        ], paddingValue),
                        _wrapWithPadding([
                          CustomTextField(
                              controller: state.quantityController,
                              hintText: 'QUANTITY'),
                          CustomTextField(
                              controller: state.requisitionQuantityController,
                              hintText: 'REQUISITION OBJ'),
                          CustomTextField(
                              controller: state.requisitionPointController,
                              hintText: 'REQUISITION POINT'),
                        ], paddingValue),
                        _wrapWithPadding([
                          SmallButton(
                              buttonName: 'Add Part',
                              onPressed: () {
                                BlocProvider.of<AddPartCubit>(context)
                                    .savePart();
                              }),
                          SmallButton(
                              buttonName: 'Apply',
                              onPressed: () {
                                BlocProvider.of<AddPartCubit>(context)
                                    .applyPart();
                              }),
                        ], paddingValue)
                      ])),
            );
          });
        }));
  }
}
