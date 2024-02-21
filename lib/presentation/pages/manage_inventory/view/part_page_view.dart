import 'package:flutter/material.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_cubit.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/view/order_part_alert_dialog.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/view/restock_part_alert_dialog.dart';
import 'package:inventory_v1/presentation/widgets/part_display_card_widget.dart';
import 'package:inventory_v1/presentation/widgets/widget_bucket.dart';

class PartsPageView extends StatefulWidget {
  PartsPageView({required this.allParts, required this.cubit})
      : lowQuantityParts = cubit.filterLowQuantityParts(allParts),
        super(key: const Key('parts-page-view'));

  final List<PartEntity> allParts;
  final List<PartEntity> lowQuantityParts;
  final ManageInventoryCubit cubit;

  @override
  State<PartsPageView> createState() => _PartsPageViewState();
}

class _PartsPageViewState extends State<PartsPageView> {
  bool showAllParts = true;
  List<bool> isExpandedList = [];
  final ScrollController controller = ScrollController();
  @override
  void initState() {
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        widget.cubit.loadParts();
      }
    });
    super.initState();
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
                            showAllParts = true;
                          }),
                      child: const Text('All Parts')),
                  TextButton(
                      onPressed: () => setState(() {
                            showAllParts = false;
                          }),
                      child: const Text('Low Quantity Parts'))
                ],
              ),
            )
          ];
        },
        body: ListView.builder(
            controller: controller,
            itemCount: showAllParts
                ? widget.allParts.length
                : widget.lowQuantityParts.length,
            itemBuilder: (context, index) {
              isExpandedList.add(false);
              return getAllPartExpansionTile(
                  showAllParts
                      ? widget.allParts[index]
                      : widget.lowQuantityParts[index],
                  index);
            }));
  }

  ExpansionTile getAllPartExpansionTile(PartEntity part, int index) {
    return ExpansionTile(
      initiallyExpanded: isExpandedList[index],
      title: PartCardDisplay(
          color: showAllParts
              ? null
              : part.quantity <= part.requisitionPoint * .2
                  ? Colors.red
                  : part.isDiscontinued
                      ? Colors.blueGrey
                      : Colors.amber,
          left: part.nsn,
          center: part.name,
          right: "Part #${part.index} Location: ${part.location}",
          bottom: isExpandedList[index]
              ? ''
              : part.isDiscontinued
                  ? 'Discontinued'
                  : 'In Stock: ${part.quantity} ${part.unitOfIssue.displayValue}'),
      children: [
        Row(
          children: [Text(part.partNumber), Text(part.serialNumber)],
        ),
        Row(
          children: [
            part.isDiscontinued
                ? const Text('Discontinued')
                : Text(
                    'Currently in stock: ${part.quantity} ${part.unitOfIssue.displayValue}')
          ],
        ),
        part.isDiscontinued
            ? Container()
            : Row(
                children: [
                  Text('Requisition Point: ${part.requisitionPoint}'),
                  Text('Requisition Quantity: ${part.requisitionQuantity}')
                ],
              ),
        Row(
          children: [
            SmallButton(
                buttonName: showAllParts ? 'Order More' : 'On-Order',
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return OrderPartDialog(
                          part: widget.allParts[index],
                          onOrder: (int quantity, int partEntityIndex) {
                            widget.cubit.orderPart(
                                orderAmount: quantity,
                                partEntityIndex: partEntityIndex);
                          },
                        );
                      });
                }),
            part.isDiscontinued
                ? SmallButton(
                    buttonName: 'Re-Stock',
                    onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return RestockPartDialog(
                            part: widget.allParts[index],
                            onOrder: (int quantity, int partEntityIndex) {
                              widget.cubit.restockPart(
                                  newQuantity: quantity,
                                  partEntity: widget.allParts[partEntityIndex]);
                            },
                          );
                        }))
                : SmallButton(
                    buttonName: 'Discontinue',
                    onPressed: () =>
                        widget.cubit.discontinuePart(partEntity: part))
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
