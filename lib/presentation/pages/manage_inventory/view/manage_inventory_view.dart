import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_cubit.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_state.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/view/check_out_part_page_view.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/view/part_page_view.dart';
import 'package:inventory_v1/presentation/widgets/generic_app_bar_widget.dart';
import 'package:inventory_v1/presentation/widgets/loading_widget.dart';
import 'package:inventory_v1/service_locator.dart';

class ManageInventory extends StatelessWidget {
  ManageInventory()
      : _pageController = PageController(),
        super(key: const Key('manage-inventory-view'));
  final PageController _pageController;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ManageInventoryCubit>(
        create: (_) => ManageInventoryCubit(
            verifyCheckoutPartUsecase: locator<VerifyCheckoutPart>(),
            getLowQuantityParts: locator<GetLowQuantityParts>(),
            getAllCheckoutParts: locator<GetAllCheckoutParts>(),
            getUnverifiedCheckoutParts: locator<GetUnverifiedCheckoutParts>(),
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
                  ManageInventoryStateStatus.verifiedPartSuccessfully) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.purple,
                  duration: Duration(milliseconds: 10),
                  content: SizedBox(
                    height: 5,
                    child: Text('Verified part'),
                  ),
                ));
              }
              if (state.status ==
                  ManageInventoryStateStatus.verifiedPartUnsuccessfully) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.pink,
                  duration: Duration(milliseconds: 10),
                  content: SizedBox(
                    height: 5,
                    child: Center(
                      child: Text('Could not verify part'),
                    ),
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
                appBar: CustomAppBar(
                  key: const Key('manage-inventory-app-bar'),
                  title: 'Manage Inventory',
                  actions: [
                    TextButton(
                        onPressed: () {
                          BlocProvider.of<ManageInventoryCubit>(context)
                              .loadParts();
                          _pageController.jumpToPage(0);
                        },
                        child: const Text("All Parts")),
                    TextButton(
                        onPressed: () {
                          BlocProvider.of<ManageInventoryCubit>(context)
                              .loadParts();
                          _pageController.jumpToPage(1);
                        },
                        child: const Text('Checked Out Parts')),
                  ],
                ),
                body: PageView(
                  controller: _pageController,
                  children: [
                    PartsPageView(
                        allParts: state.parts,
                        lowQuantityParts: state.lowQuantityParts,
                        cubit: BlocProvider.of<ManageInventoryCubit>(context)),
                    CheckoutPartPageView(
                        allCheckedOutParts: state.checkedOutParts,
                        allUnverifiedCheckedOutParts: state.unverifiedParts,
                        cubit: BlocProvider.of<ManageInventoryCubit>(context)),
                  ],
                ));
          },
        ));
  }
}
