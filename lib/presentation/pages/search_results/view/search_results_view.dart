import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/search_results/cubit/search_results_cubit.dart';
import 'package:inventory_v1/presentation/pages/search_results/cubit/search_results_state.dart';
import 'package:inventory_v1/presentation/pages/search_results/view/cart_drawer.dart';
import 'package:inventory_v1/presentation/pages/search_results/view/part_not_found.dart';
import 'package:inventory_v1/presentation/pages/search_results/view/search_results_section.dart';
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
                parts: state.partsByName,
                subtractCallback: () {},
                addCallback: () {}),
            appBar: CustomAppBar(
              key: const Key('search-results-app-bar'),
              // Directly use AppBar here
              title: 'Search Results',
              actions: [
                IconButton(
                  onPressed: () => _scaffoldKey.currentState
                      ?.openEndDrawer(), // Use openEndDrawer if the drawer is on the right
                  icon: const Icon(Icons.shopping_cart_checkout_rounded),
                ),
                const SizedBox(width: 20.0),
              ],
              bottom: PreferredSize(
                // Wrap your CustomSearchBar in PreferredSize
                preferredSize: const Size.fromHeight(
                    kToolbarHeight), // You can adjust the height as needed
                child: CustomSearchBar(
                  textFieldKey: const Key('search-results-search-bar'),
                  controller: state.searchBarController,
                  focusNode:
                      _focusNode, // Assign the FocusNode to the CustomSearchBar
                  onPressed:
                      state.status == SearchResultsStateStatus.textFieldNotEmpty
                          ? () => context.read<SearchPartCubit>().searchPart()
                          : null,
                ),
              ),
            ),
            body: Expanded(
              child: state.status == SearchResultsStateStatus.searchNotFound
                  ? const PartNotFound()
                  : ListView(
                      children: [
                        buildSection('Parts by NSN', state.partsByNsn),
                        buildSection('Parts by Name', state.partsByName),
                        buildSection(
                            'Parts by Part Number', state.partsByPartNumber),
                        buildSection('Parts by Serial Number',
                            state.partsBySerialNumber),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
