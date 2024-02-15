import 'package:flutter/material.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_cubit.dart';
import 'package:inventory_v1/presentation/widgets/buttons/small_button_widget.dart';
import 'package:inventory_v1/presentation/widgets/part_display_card_widget.dart';

class CheckoutPartPageView extends StatefulWidget {
  const CheckoutPartPageView(
      {required this.allCheckedOutParts,
      required this.allUnverifiedCheckedOutParts,
      required this.cubit})
      : super(key: const Key('checkout-page-view'));

  final List<CheckedOutEntity> allCheckedOutParts;
  final List<CheckedOutEntity> allUnverifiedCheckedOutParts;
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
    widget.cubit.loadCheckedOutParts();
    widget.cubit.filterUnverifiedParts();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        widget.cubit.loadCheckedOutParts();
        widget.cubit.filterUnverifiedParts();
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
                      child: const Text('Checked Out Parts')),
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
        body: ListView.builder(
            controller: controller,
            itemCount: showAllCheckedOutParts
                ? widget.allCheckedOutParts.length
                : widget.allUnverifiedCheckedOutParts.length,
            itemBuilder: (context, index) {
              isExpandedList.add(false);

              return getAllCheckedOutPartExpansionTiles(
                  showAllCheckedOutParts
                      ? widget.allCheckedOutParts[index]
                      : widget.allUnverifiedCheckedOutParts[index],
                  index);
            }));
  }

  ExpansionTile getAllCheckedOutPartExpansionTiles(
      CheckedOutEntity checkedOutPart, int index) {
    var part = checkedOutPart.part;

    return ExpansionTile(
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
            : getButtons(checkedOutPart),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
                'Checked out ${checkedOutPart.checkedOutQuantity} in stock: ${part.quantity} ${part.unitOfIssue.displayValue}')
          ],
        ),
        Row(
          children: [
            checkedOutPart.isVerified ?? false
                ? Container()
                : SmallButton(
                    buttonName: 'Verify',
                    onPressed: () => widget.cubit
                        .verifyPart(checkedOutEntity: checkedOutPart)),
          ],
        ),
      ],
    );
  }

  Widget getButtons(CheckedOutEntity checkedOutEntity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => widget.cubit.updateCheckoutQuantity(
                checkoutPart: checkedOutEntity, quantityChange: -1)),
        const SizedBox(
          width: 10,
        ),
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => widget.cubit.updateCheckoutQuantity(
                checkoutPart: checkedOutEntity, quantityChange: 1)),
      ],
    );
  }
}
