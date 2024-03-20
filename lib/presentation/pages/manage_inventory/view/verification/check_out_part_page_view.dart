import 'package:flutter/material.dart';
import 'package:inventory_v1/core/util/main_section_enum.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_cubit.dart';
import 'package:inventory_v1/presentation/widgets/buttons/small_button_widget.dart';
import 'package:inventory_v1/presentation/widgets/part_display_card_widget.dart';

class CheckoutPartPageView extends StatefulWidget {
  CheckoutPartPageView(
      {required this.allCheckedOutParts,
      required this.allParts,
      required this.cubit})
      : allUnverifiedCheckedOutParts =
            cubit.filterUnverifiedParts(allCheckedOutParts),
        super(key: const Key('checkout-page-view'));

  final List<CheckedOutEntity> allCheckedOutParts;
  final List<CheckedOutEntity> allUnverifiedCheckedOutParts;
  final List<PartEntity> allParts;
  final ManageInventoryCubit cubit;
  @override
  State<CheckoutPartPageView> createState() => _CheckoutPartPageViewState();
}

class _CheckoutPartPageViewState extends State<CheckoutPartPageView> {
  bool showAllCheckedOutParts = true;
  List<bool> isExpandedList = [];
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        widget.cubit.loadCheckedOutParts();
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
                            showAllCheckedOutParts = true;
                          }),
                      child: const Text(
                        'Checked Out Parts',
                      )),
                  TextButton(
                      onPressed: () => setState(() {
                            // controller.jumpTo(controller.initialScrollOffset);
                            showAllCheckedOutParts = false;
                          }),
                      child: const Text('Unverified Parts'))
                ],
              ),
            )
          ];
        },
        body: widget.allCheckedOutParts.isEmpty
            ? const Center(
                child: Text('No checked out parts to show'),
              )
            : ListView.builder(
                controller: controller,
                itemCount: showAllCheckedOutParts
                    ? widget.allCheckedOutParts.length
                    : widget.allUnverifiedCheckedOutParts.length,
                itemBuilder: (context, index) {
                  isExpandedList.add(false);

                  var thisCheckoutPart = showAllCheckedOutParts
                      ? widget.allCheckedOutParts[index]
                      : widget.allUnverifiedCheckedOutParts[index];
                  var part = widget.allParts.singleWhere(
                      (element) =>
                          element.index == thisCheckoutPart.partEntityIndex,
                      orElse: () => widget.cubit
                          .getPart(thisCheckoutPart.partEntityIndex));

                  return getAllCheckedOutPartExpansionTiles(
                      thisCheckoutPart, part, index);
                }));
  }

  ExpansionTile getAllCheckedOutPartExpansionTiles(
      CheckedOutEntity checkedOutPart, PartEntity part, int index) {
    return ExpansionTile(
      expandedAlignment: Alignment.center,
      initiallyExpanded: isExpandedList[index],
      title: PartCardDisplay(
          color: checkedOutPart.isVerified ?? false ? null : Colors.amber,
          left: part.nsn,
          center: part.name,
          right: "#${checkedOutPart.index} Location: ${part.location}",
          bottom: isExpandedList[index]
              ? ''
              : checkedOutPart.isVerified ?? false
                  ? 'Verified'
                  : 'Not Verified'),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Checked out by: ${checkedOutPart.checkoutUser}'),
            Text('Task: ${checkedOutPart.taskName}')
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('ACFT: ${checkedOutPart.aircraftTailNumber}'),
            Text('Section: ${checkedOutPart.section.enumToString()}')
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              part.partNumber,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              part.serialNumber,
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Date Checked out: ${checkedOutPart.dateTime}'),
            checkedOutPart.isVerified ?? false
                ? Text('Date verified: ${checkedOutPart.verifiedDate}')
                : Container(),
          ],
        ),
        checkedOutPart.isVerified ?? false
            ? Container()
            : getButtons(checkedOutPart, part),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            checkedOutPart.isVerified ?? false
                ? Text(
                    'Checked out ${checkedOutPart.checkedOutQuantity} in stock:  ${part.quantity} ${part.unitOfIssue.displayValue}')
                : Text(
                    'Checked out ${checkedOutPart.checkedOutQuantity} in stock:  ${part.quantity - checkedOutPart.quantityDiscrepancy} ${part.unitOfIssue.displayValue}'),
          ],
        ),
        Row(
          children: [
            checkedOutPart.isVerified ?? false
                ? Container()
                : Expanded(
                    child: SmallButton(
                        buttonName: 'Verify',
                        onPressed: () => widget.cubit
                            .verifyPart(checkedOutEntity: checkedOutPart)),
                  ),
          ],
        ),
      ],
    );
  }

  Widget getButtons(CheckedOutEntity checkedOutEntity, PartEntity part) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            icon: const Icon(Icons.remove),
            onPressed: checkedOutEntity.checkedOutQuantity - 1 >= 0
                ? () => widget.cubit.updateCheckoutQuantity(
                    checkoutPart: checkedOutEntity, quantityChange: -1)
                : null),
        const SizedBox(
          width: 10,
        ),
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: part.quantity - checkedOutEntity.quantityDiscrepancy > 0
                ? () => widget.cubit.updateCheckoutQuantity(
                    checkoutPart: checkedOutEntity, quantityChange: 1)
                : null),
      ],
    );
  }
}
