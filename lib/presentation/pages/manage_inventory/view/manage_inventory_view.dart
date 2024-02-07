import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_cubit.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_state.dart';
import 'package:inventory_v1/presentation/widgets/generic_app_bar_widget.dart';
import 'package:inventory_v1/presentation/widgets/loading_widget.dart';
import 'package:inventory_v1/presentation/widgets/part_display_card_widget.dart';
import 'package:inventory_v1/service_locator.dart';
import 'package:logging/logging.dart';

class ManageInventory extends StatelessWidget {
  ManageInventory()
      : _logger = Logger('manage-inv-logger'),
        super(key: const Key('manage-inventory-view'));
  final Logger _logger;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ManageInventoryCubit>(
        create: (_) => ManageInventoryCubit(
            scrollController: ScrollController(),
            getAllPartsUsecase: locator<GetAllPartsUsecase>(),
            getDatabaseLength: locator<GetDatabaseLength>())
          ..init(),
        child: BlocBuilder<ManageInventoryCubit, ManageInventoryState>(
          builder: (context, state) {
            if (state.status == ManageInventoryStateStatus.loading) {
              return const LoadingView();
            }
            if (state.status ==
                ManageInventoryStateStatus.loadedUnsuccessfully) {
              return const Center(
                child: Text('Unable to load data'),
              );
            }
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              if (state.status == ManageInventoryStateStatus.fetchingData) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.blue,
                    duration: Durations.short4,
                    content: Center(
                      child: CircularProgressIndicator(),
                    )));
              }
              if (state.status ==
                  ManageInventoryStateStatus.fetchedDataSuccessfully) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  duration: Duration(milliseconds: 10),
                  content: SizedBox(
                    height: 5,
                  ),
                ));
              }
              if (state.status ==
                  ManageInventoryStateStatus.fetchedDataUnsuccessfully) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    duration: const Duration(microseconds: 250),
                    content: Text("${state.error}")));
              }
            });

            return Scaffold(
              appBar: genericAppBar(context, 'Manage Inventory'),
              body: ListView.builder(
                controller: state.scrollController,
                itemCount: state.parts.length,
                itemBuilder: (context, index) {
                  _logger.finest('Loading part $index into view');
                  return PartCardDisplay(
                    left: state.parts[index].nsn,
                    center: state.parts[index].name,
                    right: "Location: ${state.parts[index].location}",
                    bottom:
                        "Checked out: ${state.parts[index].quantity} ${state.parts[index].unitOfIssue.displayValue}",
                  );
                },
              ),
            );
          },
        ));
  }
}
