import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_cubit.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_state.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/view/verification/check_out_part_page_view.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/view/drawer_widget.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/view/order/part_order_view.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/view/part/part_page_view.dart';
import 'package:inventory_v1/presentation/widgets/generic_app_bar_widget.dart';
import 'package:inventory_v1/presentation/widgets/loading_widget.dart';
import 'package:inventory_v1/service_locator.dart';

class ManageInventory extends StatelessWidget {
  const ManageInventory({required this.authenticatedUser})
      : super(key: const Key('manage-inventory-view'));
  final UserEntity authenticatedUser;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ManageInventoryCubit>(
        create: (_) => ManageInventoryCubit(
              authenticatedUser: authenticatedUser,
              fetchPartAmount: 100,
              clearDatabaseUsecase: locator<ClearDatabaseUsecase>(),
              getPartByIndexUsecase: locator<GetPartByIndexUsecase>(),
              importFromExcelUsecase: locator<ImportFromExcelUsecase>(),
              exportToExcelUsecase: locator<ExportToExcelUsecase>(),
              editPartUsecase: locator<EditPartUsecase>(),
              discontinuePartUsecase: locator<DiscontinuePartUsecase>(),
              deletePartOrderUsecase: locator<DeletePartOrderUsecase>(),
              getAllPartOrdersUsecase: locator<GetAllPartOrdersUsecase>(),
              createPartOrderUsecase: locator<CreatePartOrderUsecase>(),
              fulfillPartOrdersUsecase: locator<FulfillPartOrdersUsecase>(),
              verifyCheckoutPartUsecase: locator<VerifyCheckoutPart>(),
              getLowQuantityParts: locator<GetLowQuantityParts>(),
              getAllCheckoutParts: locator<GetAllCheckoutParts>(),
              getUnverifiedCheckoutParts: locator<GetUnverifiedCheckoutParts>(),
              getAllPartsUsecase: locator<GetAllPartsUsecase>(),
            )..init(),
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
              if (state.status == ManageInventoryStateStatus.operationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                  content: Center(child: Text(state.error)),
                ));
              }
              if (state.status == ManageInventoryStateStatus.errorOccurred) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                  content: Text(state.error),
                ));
              }
              if (state.status ==
                  ManageInventoryStateStatus.fetchedDataUnsuccessfully) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                    content: Text('Could not fetch data ${state.error}')));
              }
            });

            return DefaultTabController(
                length: 3,
                child: Scaffold(
                    drawer: CustomDrawerWidget(
                        currentUser: state.authenticatedUser,
                        clearDatabase: () =>
                            BlocProvider.of<ManageInventoryCubit>(context)
                                .clearDatabase(),
                        importFromExcel: () async {
                          final cubit =
                              BlocProvider.of<ManageInventoryCubit>(context);

                          var results = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['xlsx', 'numbers'],
                            dialogTitle: 'Choose the excel file to import from',
                          );
                          if (results != null) {
                            var path = results.files.single.path;

                            if (path != null) {
                              cubit.importFromExcel(path);
                            }
                          }
                        },
                        exportToExcel: () async {
                          final cubit =
                              BlocProvider.of<ManageInventoryCubit>(context);

                          var results =
                              await FilePicker.platform.getDirectoryPath(
                            dialogTitle: 'Choose a destination for export',
                          );
                          if (results != null) {
                            var path = results;

                            cubit.exportToExcel(path);
                          }
                        },
                        onPressed: () {
                          BlocProvider.of<ManageInventoryCubit>(context)
                              .filterByLocation();
                        }),
                    appBar: CustomAppBar(
                        key: const Key('manage-inventory-view-search-bar'),
                        title: 'Manage Inventory',
                        actions: [
                          Builder(
                            builder: (BuildContext context) {
                              return IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                tooltip: MaterialLocalizations.of(context)
                                    .openAppDrawerTooltip,
                              );
                            },
                          ),
                        ],
                        bottom: const TabBar(
                          tabs: [
                            Tab(
                              text: 'Parts',
                            ),
                            Tab(
                              text: 'Checked out Parts',
                            ),
                            Tab(
                              text: 'Part Orders',
                            )
                          ],
                        )),
                    body: TabBarView(
                      children: [
                        PartsPageView(
                            allParts: state.allParts,
                            cubit:
                                BlocProvider.of<ManageInventoryCubit>(context)),
                        CheckoutPartPageView(
                            allParts: state.allParts,
                            allCheckedOutParts: state.checkedOutParts,
                            cubit:
                                BlocProvider.of<ManageInventoryCubit>(context)),
                        PartOrdersPageView(
                            allPartOrders: state.allPartOrders,
                            allParts: state.allParts,
                            cubit:
                                BlocProvider.of<ManageInventoryCubit>(context))
                      ],
                    )));
          },
        ));
  }
}
