import 'package:flutter/material.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_cubit.dart';
import 'package:inventory_v1/presentation/widgets/buttons/small_button_widget.dart';
import 'package:inventory_v1/presentation/widgets/part_display_card_widget.dart';

class PartOrdersPageView extends StatefulWidget {
  const PartOrdersPageView(
      {required this.allPartOrders,
      required this.unfulfilledPartOrders,
      required this.allParts,
      required this.cubit})
      : super(key: const Key('part-orders-page-view'));

  final List<OrderEntity> allPartOrders;
  final List<OrderEntity> unfulfilledPartOrders;
  final List<PartEntity> allParts;
  final ManageInventoryCubit cubit;
  @override
  State<PartOrdersPageView> createState() => _PartOrdersPageViewState();
}

class _PartOrdersPageViewState extends State<PartOrdersPageView> {
  bool showFulfilledPartOrders = true;
  List<bool> isExpandedList = [];
  late ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        widget.cubit.loadPartOrders();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: Container(),
              pinned: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () => setState(() {
                            //controller.jumpTo(controller.initialScrollOffset);
                            showFulfilledPartOrders = true;
                          }),
                      child: const Text('All Orders')),
                  TextButton(
                      onPressed: () => setState(() {
                            // controller.jumpTo(controller.initialScrollOffset);
                            showFulfilledPartOrders = false;
                          }),
                      child: const Text('Unfulfilled Orders'))
                ],
              ),
            )
          ];
        },
        body: ListView.builder(
            itemCount: showFulfilledPartOrders
                ? widget.allPartOrders.length
                : widget.unfulfilledPartOrders.length,
            controller: controller,
            itemBuilder: (context, index) {
              isExpandedList.add(false);
              var orderEntity = showFulfilledPartOrders
                  ? widget.allPartOrders[index]
                  : widget.unfulfilledPartOrders[index];
              var partEntity = widget.allParts.singleWhere(
                  (element) => element.index == orderEntity.partEntityIndex);

              return getAllPartOrdersExpansionTiles(
                  orderEntity, partEntity, index);
            }));
  }

  ExpansionTile getAllPartOrdersExpansionTiles(
      OrderEntity orderEntity, PartEntity partEntity, int index) {
    return ExpansionTile(
      initiallyExpanded: isExpandedList[index],
      title: PartCardDisplay(
        color: orderEntity.isFulfilled ? null : Colors.amber,
        left: partEntity.nsn,
        center: partEntity.name,
        right: 'Location ${partEntity.location}',
        bottom: isExpandedList[index]
            ? ''
            : orderEntity.isFulfilled
                ? 'Fulfilled'
                : 'Unfulfilled',
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              partEntity.partNumber,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              partEntity.serialNumber,
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Date ordered out: ${orderEntity.orderDate}'),
            orderEntity.isFulfilled
                ? Text('Date fulfilled: ${orderEntity.fulfillmentDate}')
                : Container(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            orderEntity.isFulfilled
                ? Text(
                    'Ordered on ${orderEntity.orderAmount} in stock:  ${partEntity.quantity} ${partEntity.unitOfIssue.displayValue}')
                : Text(
                    'Ordered on ${orderEntity.orderAmount} in stock:  ${partEntity.quantity + orderEntity.orderAmount} ${partEntity.unitOfIssue.displayValue}'),
          ],
        ),
        Row(
          children: [
            orderEntity.isFulfilled
                ? Container()
                : SmallButton(
                    buttonName: 'Fulfilled',
                    onPressed: () => widget.cubit
                        .fulfillPartOrder(orderEntityIndex: orderEntity.index)),
          ],
        ),
      ],
    );
  }
}
