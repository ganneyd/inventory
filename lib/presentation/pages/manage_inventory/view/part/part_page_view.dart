import 'package:flutter/material.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_cubit.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/view/order/order_part_alert_dialog.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/view/part/restock_part_alert_dialog.dart';
import 'package:inventory_v1/presentation/widgets/buttons/checkbox_widget.dart';
import 'package:inventory_v1/presentation/widgets/form/part_form_widget.dart';
import 'package:inventory_v1/presentation/widgets/part_display_card_widget.dart';
import 'package:inventory_v1/presentation/widgets/widget_bucket.dart';

class PartsPageView extends StatefulWidget {
  PartsPageView({
    required this.allParts,
    required this.cubit,
  })  : lowQuantityParts = cubit.filterLowQuantityParts(allParts),
        filteredByLocation = cubit.filterByLocation(),
        super(key: const Key('parts-page-view'));

  final List<PartEntity> allParts;
  final List<PartEntity> lowQuantityParts;
  final List<PartEntity> filteredByLocation;
  final ManageInventoryCubit cubit;

  @override
  State<PartsPageView> createState() => _PartsPageViewState();
}

class _PartsPageViewState extends State<PartsPageView> {
  bool showAllParts = true;
  bool filterByLocation = false;
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
                  Column(
                    children: [
                      Row(
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
                              child: const Text('Low Quantity Parts')),
                          CustomCheckbox(
                              onChanged: (value) => setState(() {
                                    filterByLocation = value ?? false;
                                  }),
                              checkBoxName: 'Sort by Location',
                              value: filterByLocation)
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ];
        },
        body: ListView.builder(
            controller: controller,
            itemCount: showAllParts
                ? filterByLocation
                    ? widget.filteredByLocation.length
                    : widget.allParts.length
                : widget.lowQuantityParts.length,
            itemBuilder: (context, index) {
              isExpandedList.add(false);
              return getAllPartExpansionTile(
                  showAllParts
                      ? filterByLocation
                          ? widget.filteredByLocation[index]
                          : widget.allParts[index]
                      : widget.lowQuantityParts[index],
                  index);
            }));
  }

  ExpansionTile getAllPartExpansionTile(PartEntity part, int index) {
    return ExpansionTile(
      expandedAlignment: Alignment.center,
      expandedCrossAxisAlignment: CrossAxisAlignment.center,
      initiallyExpanded: isExpandedList[index],
      title: PartCardDisplay(
          actionButton: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => showDialog(
                context: context,
                builder: (dialogContext) {
                  return SizedBox(
                    width: MediaQuery.of(dialogContext).size.width * 0.3,
                    child: Dialog(
                      child: PartForm(
                        minimumQuantity: 0,
                        buttonName: 'Update',
                        partEntity: part,
                        key: const Key('edit-part-form'),
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
                            required unitOfIssue}) {
                          widget.cubit.updatePart(PartEntity(
                              isDiscontinued: part.isDiscontinued,
                              checksum: part.checksum,
                              index: part.index,
                              nsn: nsn,
                              name: name,
                              partNumber: partNumber,
                              location: location,
                              quantity: int.tryParse(quantity) ?? -1,
                              requisitionPoint:
                                  int.tryParse(requisitionPoint) ?? -1,
                              requisitionQuantity:
                                  int.tryParse(requisitionQuantity) ?? -1,
                              serialNumber: serialNumber,
                              unitOfIssue: unitOfIssue));

                          Navigator.of(dialogContext).pop();
                        },
                      ),
                    ),
                  );
                }),
          ),
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Text(part.partNumber), Text(part.serialNumber)],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Requisition Point: ${part.requisitionPoint}'),
                  Text('Requisition Quantity: ${part.requisitionQuantity}')
                ],
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: SmallButton(
                  buttonName: showAllParts ? 'Order More' : 'On-Order',
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return OrderPartDialog(
                            part: showAllParts
                                ? filterByLocation
                                    ? widget.filteredByLocation[index]
                                    : widget.allParts[index]
                                : widget.lowQuantityParts[index],
                            onOrder: (int quantity, PartEntity partEntity) {
                              widget.cubit.orderPart(
                                  orderAmount: quantity,
                                  partEntityIndex: partEntity.index);
                            },
                          );
                        });
                  }),
            ),
            part.isDiscontinued
                ? Expanded(
                    child: SmallButton(
                        buttonName: 'Re-Stock',
                        onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return RestockPartDialog(
                                part: showAllParts
                                    ? filterByLocation
                                        ? widget.filteredByLocation[index]
                                        : widget.allParts[index]
                                    : widget.lowQuantityParts[index],
                                onOrder: (int quantity, PartEntity partEntity) {
                                  widget.cubit.restockPart(
                                      newQuantity: quantity,
                                      partEntity: partEntity);
                                },
                              );
                            })),
                  )
                : Expanded(
                    child: SmallButton(
                        buttonName: 'Discontinue',
                        onPressed: () =>
                            widget.cubit.discontinuePart(partEntity: part)),
                  )
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
