import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:my_travaly/src/features/search_results/controllers/search_results_controller.dart';
import 'package:my_travaly/src/features/search_results/data/models/search_result_model.dart';
import 'package:my_travaly/src/features/search_results/views/widgets/search_result_card.dart';
import 'package:my_travaly/src/features/search_results/views/widgets/search_results_error_indicator.dart';

class SearchResultsScreen extends GetView<SearchResultsController> {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Result Page'),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Text(
                    'Keyword ${controller.title}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Searching by ${controller.searchType.label.toLowerCase()}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: PagingListener<int, SearchResult>(
        controller: controller.pagingController,
        builder: (context, state, fetchNextPage) {
          final theme = Theme.of(context);
          return RefreshIndicator(
            onRefresh: () async {
              controller.pagingController.refresh();
              controller.pagingController.fetchNextPage();
            },
            child: PagedListView<int, SearchResult>(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              state: state,
              fetchNextPage: fetchNextPage,
              builderDelegate: PagedChildBuilderDelegate<SearchResult>(
                itemBuilder: (context, result, index) =>
                    SearchResultCard(result: result),
                firstPageProgressIndicatorBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
                newPageProgressIndicatorBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
                firstPageErrorIndicatorBuilder: (_) =>
                    SearchResultsErrorIndicator(
                  message:
                      state.error?.toString() ?? 'Failed to load results.',
                  onRetry: fetchNextPage,
                ),
                newPageErrorIndicatorBuilder: (_) =>
                    SearchResultsErrorIndicator(
                  message:
                      state.error?.toString() ?? 'Failed to load more results.',
                  onRetry: fetchNextPage,
                ),
                noItemsFoundIndicatorBuilder: (_) => Center(
                  child: Text(
                    'No properties found for "${controller.title}. Try refining your search.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
