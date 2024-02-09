import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/presentation/pages/checkout/cubit/checkout_cubit.dart';
import 'package:inventory_v1/presentation/pages/checkout/cubit/checkout_state.dart';
import 'package:inventory_v1/presentation/widgets/loading_widget.dart';

class CheckOutView extends StatelessWidget {
  const CheckOutView() : super(key: const Key('checkout-view'));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckoutCubit>(
      create: (_) => CheckoutCubit(),
      child:
          BlocBuilder<CheckoutCubit, CheckoutState>(builder: (context, state) {
        return const LoadingView();
      }),
    );
  }
}
