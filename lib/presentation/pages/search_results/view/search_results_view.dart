import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/search_results/cubit/search_results_cubit.dart';
import 'package:inventory_v1/presentation/pages/search_results/cubit/search_results_state.dart';
import 'package:inventory_v1/presentation/pages/search_results/view/cart_drawer.dart';
import 'package:inventory_v1/presentation/pages/search_results/view/part_not_found.dart';
import 'package:inventory_v1/presentation/pages/search_results/view/search_results_section.dart';
import 'package:inventory_v1/presentation/widgets/buttons/checkbox_widget.dart';
import 'package:inventory_v1/presentation/widgets/dialogs/go_to_homeview_dialog.dart';
import 'package:inventory_v1/presentation/widgets/generic_app_bar_widget.dart';
import 'package:inventory_v1/presentation/widgets/widget_bucket.dart';
import 'package:inventory_v1/service_locator.dart';

class SearchResults extends StatefulWidget {
  final TextEditingController textEditingController;

  const SearchResults({
    required this.textEditingController,
  }) : super(key: const Key('search-part-view'));

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late FocusNode _focusNode; // Declare a FocusNode
  bool showPartsByNsn = true;
  bool showPartsByName = true;
  bool showPartsBySerialNumber = true;
  bool showPartsByPartNumber = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(); // Initialize the FocusNode
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose the FocusNode to release resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchPartCubit>(
      // Initialize the Cubit with required dependencies
      create: (_) => SearchPartCubit(
        editingController: widget
            .textEditingController, // Use the TextEditingController from the widget
        scrollController: ScrollController(), // Initialize a ScrollController
        getPartByNameUseCase: locator<GetPartByNameUseCase>(),
        getPartByNsnUseCase: locator<GetPartByNsnUseCase>(),
        getPartByPartNumberUsecase: locator<GetPartByPartNumberUsecase>(),
        getPartBySerialNumberUsecase: locator<GetPartBySerialNumberUsecase>(),
      )..init(),
      child: BlocBuilder<SearchPartCubit, SearchResultsState>(
        builder: (context, state) {
          // Post-frame callbacks for showing SnackBars based on state
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (state.status == SearchResultsStateStatus.loadedUnsuccessfully) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Unable to load ${state.error}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            } else if (state.status ==
                SearchResultsStateStatus.searchUnsuccessful) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Unable to search part ${state.error}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          });

          return Scaffold(
            key: _scaffoldKey,
            endDrawer: buildDrawer(
                context: context,
                cartItems: state.cartItems,
                subtractCallback: (index, newQuantity) =>
                    BlocProvider.of<SearchPartCubit>(context)
                        .updateCheckoutQuantity(
                            checkoutPartIndex: index, newQuantity: newQuantity),
                addCallback: (index, newQuantity) {
                  BlocProvider.of<SearchPartCubit>(context)
                      .updateCheckoutQuantity(
                          checkoutPartIndex: index, newQuantity: newQuantity);
                }),
            appBar: CustomAppBar(
              key: const Key('search-results-app-bar'),
              title: 'Search Results',
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
                } else {
                  Navigator.of(context).pop();
                }
              },
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 30, top: 15),
                  child: Badge(
                    label: Text('${state.cartItems.length}'),
                    child: IconButton(
                      iconSize: 30,
                      onPressed: () => _scaffoldKey.currentState
                          ?.openEndDrawer(), // Use openEndDrawer if the drawer is on the right
                      icon: const Icon(Icons.shopping_cart_checkout_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 50.0),
              ],
              bottom: PreferredSize(
                // Wrap your CustomSearchBar in PreferredSize
                preferredSize: const Size.fromHeight(
                    kToolbarHeight + 30), // You can adjust the height as needed
                child: Column(
                  children: [
                    CustomSearchBar(
                      textFieldKey: const Key('search-results-search-bar'),
                      controller: state.searchBarController,
                      focusNode:
                          _focusNode, // Assign the FocusNode to the CustomSearchBar
                      onPressed: state.status ==
                              SearchResultsStateStatus.textFieldNotEmpty
                          ? () => context.read<SearchPartCubit>().searchPart()
                          : null,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        state.partsByNsn.isNotEmpty
                            ? CustomCheckbox(
                                onChanged: (value) => setState(() {
                                      showPartsByNsn = value ?? false;
                                    }),
                                checkBoxName: 'NSN',
                                value: showPartsByNsn)
                            : Container(),
                        state.partsByName.isNotEmpty
                            ? CustomCheckbox(
                                onChanged: (value) => setState(() {
                                      showPartsByName = value ?? false;
                                    }),
                                checkBoxName: 'Name',
                                value: showPartsByName)
                            : Container(),
                        state.partsByPartNumber.isNotEmpty
                            ? CustomCheckbox(
                                onChanged: (value) => setState(() {
                                      showPartsByPartNumber = value ?? false;
                                    }),
                                checkBoxName: 'Part Number',
                                value: showPartsByPartNumber)
                            : Container(),
                        state.partsBySerialNumber.isNotEmpty
                            ? CustomCheckbox(
                                onChanged: (value) => setState(() {
                                      showPartsBySerialNumber = value ?? false;
                                    }),
                                checkBoxName: 'Serial Number',
                                value: showPartsBySerialNumber)
                            : Container()
                      ],
                    )
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: state.status == SearchResultsStateStatus.searchNotFound
                      ? const PartNotFound()
                      : ListView(
                          children: [
                            showPartsByNsn
                                ? buildSection(
                                    'Parts by NSN', state.partsByNsn, context)
                                : Container(),
                            showPartsByName
                                ? buildSection(
                                    'Parts by Name', state.partsByName, context)
                                : Container(),
                            showPartsByPartNumber
                                ? buildSection('Parts by Part Number',
                                    state.partsByPartNumber, context)
                                : Container(),
                            showPartsBySerialNumber
                                ? buildSection('Parts by Serial Number',
                                    state.partsBySerialNumber, context)
                                : Container(),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
