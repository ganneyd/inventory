import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/data/repositories/part_repository_implementation.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_cubit.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_state.dart';
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
            partRepository: locator<PartRepositoryImplementation>())
          ..init(),
        child: BlocBuilder<ManageInventoryCubit, ManageInventoryState>(
          builder: (context, state) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              if (state.manageInventoryStateStatus ==
                  ManageInventoryStateStatus.loading) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.blue,
                    duration: Durations.short4,
                    content: Center(
                      child: CircularProgressIndicator(),
                    )));
              }
              if (state.manageInventoryStateStatus ==
                  ManageInventoryStateStatus.fetchedDataSuccessfully) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.green,
                    duration: Duration(milliseconds: 100),
                    content: Icon(Icons.check)));
              }
              if (state.manageInventoryStateStatus ==
                  ManageInventoryStateStatus.fetchedDataUnsuccessfully) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    duration: const Duration(microseconds: 250),
                    content: Text("${state.error}")));
              }
            });

            if (state.manageInventoryStateStatus ==
                ManageInventoryStateStatus.loadedUnsuccessfully) {
              return const Center(
                child: Text('Unable to load data'),
              );
            }
            return Scaffold(
              appBar: AppBar(
                  title: const Text('Manage Inventory'),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              body: ListView.builder(
                controller: state.scrollController,
                itemCount: state.part.length,
                itemBuilder: (context, index) {
                  _logger.finest('Loading part $index into view');
                  return PartCardDisplay(
                      nsn: state.part[index].index.toString(),
                      checkedOutAmount: state.part[index].quantity.toString(),
                      location: state.part[index].location,
                      partName: state.part[index].name);
                },
              ),
            );
          },
        ));
  }
}
