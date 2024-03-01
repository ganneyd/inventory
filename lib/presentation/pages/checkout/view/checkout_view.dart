import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/core/util/main_section_enum.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/domain/entities/checked-out/cart_check_out_entity.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/checkout/cubit/checkout_cubit.dart';
import 'package:inventory_v1/presentation/pages/checkout/cubit/checkout_state.dart';
import 'package:inventory_v1/presentation/pages/checkout/view/checkout_part_dialog.dart';
import 'package:inventory_v1/presentation/widgets/dialogs/go_to_homeview_dialog.dart';
import 'package:inventory_v1/presentation/widgets/generic_app_bar_widget.dart';
import 'package:inventory_v1/presentation/widgets/loading_widget.dart';
import 'package:inventory_v1/presentation/widgets/part_display_card_widget.dart';
import 'package:inventory_v1/presentation/widgets/widget_bucket.dart';
import 'package:inventory_v1/service_locator.dart';

class CheckOutView extends StatelessWidget {
  CheckOutView(this.cartItems) : super(key: const Key('checkout-view'));
  final List<CartCheckoutEntity> cartItems;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckoutCubit>(
      create: (_) => CheckoutCubit(
        addCheckoutPart: locator<AddCheckoutPart>(),
        cartItems: cartItems,
      )..init(),
      child:
          BlocBuilder<CheckoutCubit, CheckoutState>(builder: (context, state) {
        // Post-frame callbacks for showing SnackBars based on state
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (state.status == CheckoutStateStatus.addedUserUnsuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unable to add user ${state.error}'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
          if (state.status == CheckoutStateStatus.loadedUnsuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unable to load ${state.error}'),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state.status ==
              CheckoutStateStatus.checkedOutUnsuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unable to checkout part ${state.error}'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
          if (state.status == CheckoutStateStatus.completed) {
            Navigator.of(context).pushNamed('/home_page');
          }
        });
        if (state.status == CheckoutStateStatus.loading) {
          return const LoadingView();
        }

        return Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(
            key: const Key('search-results-app-bar'),
            // Directly use AppBar here
            title: 'Checkout Parts',
            showBackButton: !state.isCheckoutCompleted,
            backButtonCallback: () async {
              if (state.cartItems.isNotEmpty) {
                await showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return getBackToHomeDialog(
                          message:
                              'You still got items in your cart, do you still want to continue browsing?',
                          context: context,
                          dialogContext: dialogContext);
                    });
              } else if (!state.isCheckoutCompleted) {
                Navigator.of(context).pop();
              }
            },
          ),
          body: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: state.cartItems.length,
                      itemBuilder: (context, index) {
                        var checkoutQuantity = state.cartItems[index]
                            .checkedOutEntity.checkedOutQuantity;
                        var part = state.cartItems[index].partEntity;

                        return ExpansionTile(
                          expandedAlignment: Alignment.center,
                          expandedCrossAxisAlignment: CrossAxisAlignment.center,
                          title: PartCardDisplay(
                            left: part.nsn,
                            center: part.name,
                            right: state.isCheckoutCompleted
                                ? 'Location: ${part.location}'
                                : part.partNumber,
                            bottom:
                                ' ${state.isCheckoutCompleted ? 'Checked out' : 'Checking out'}: $checkoutQuantity ${part.unitOfIssue.displayValue}',
                          ),
                          children: state.isCheckoutCompleted
                              ? []
                              : <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () => checkoutQuantity > 1
                                            ? BlocProvider.of<CheckoutCubit>(
                                                    context)
                                                .updateCheckoutQuantity(
                                                    cartItemIndex: index,
                                                    newQuantity:
                                                        checkoutQuantity - 1)
                                            : null,
                                      ),
                                      Text(checkoutQuantity.toString()),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () => checkoutQuantity <
                                                part.quantity
                                            ? BlocProvider.of<CheckoutCubit>(
                                                    context)
                                                .updateCheckoutQuantity(
                                                    cartItemIndex: index,
                                                    newQuantity:
                                                        checkoutQuantity + 1)
                                            : null,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.cancel_rounded),
                                        onPressed: () =>
                                            BlocProvider.of<CheckoutCubit>(
                                                    context)
                                                .removeCheckoutPart(index),
                                      ),
                                    ],
                                  ),
                                ],
                        );
                      })),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  state.isCheckoutCompleted
                      ? SmallButton(
                          buttonName: 'Retrieved All My Parts',
                          onPressed: () =>
                              BlocProvider.of<CheckoutCubit>(context)
                                  .partRetrievalCompleted())
                      : SmallButton(
                          buttonName: 'Checkout',
                          onPressed: state.status ==
                                  CheckoutStateStatus.addedUserSuccessfully
                              ? () => BlocProvider.of<CheckoutCubit>(context)
                                  .checkoutCart()
                              : () => showDialog(
                                  context: context,
                                  builder: ((dialogContext) {
                                    return CheckoutPartDialog(
                                        updateCheckout: (
                                                {required MaintenanceSection
                                                    section,
                                                required String tailNumber,
                                                required String taskName,
                                                required String
                                                    checkoutUser}) =>
                                            BlocProvider.of<CheckoutCubit>(
                                                    context)
                                                .addCheckoutUser(
                                                    section: section,
                                                    tailNumber: tailNumber,
                                                    taskName: taskName,
                                                    checkoutUser:
                                                        checkoutUser));
                                  })))
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
