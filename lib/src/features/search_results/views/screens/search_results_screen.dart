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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Searching by ${controller.searchType.label.toLowerCase()}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  controller.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 160,
                  child: OutlinedButton.icon(
                    onPressed: () => controller.showFiltersDialog(context),
                    icon: const Icon(Icons.filter_alt_outlined),
                    label: const Text('Filter Results'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Expanded(
            child: PagingListener<int, SearchResult>(
              controller: controller.pagingController,
              builder: (context, state, fetchNextPage) {
                final theme = Theme.of(context);
                return RefreshIndicator(
                  onRefresh: controller.refreshResults,
                  child: PagedListView<int, SearchResult>(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    state: state,
                    fetchNextPage: fetchNextPage,
                    builderDelegate: PagedChildBuilderDelegate<SearchResult>(
                      itemBuilder: (context, result, index) => SearchResultCard(result: result),
                      firstPageProgressIndicatorBuilder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                      newPageProgressIndicatorBuilder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                      firstPageErrorIndicatorBuilder: (_) => SearchResultsErrorIndicator(
                        message: state.error?.toString() ?? 'Failed to load results.',
                        onRetry: fetchNextPage,
                      ),
                      newPageErrorIndicatorBuilder: (_) => SearchResultsErrorIndicator(
                        message: state.error?.toString() ?? 'Failed to load more results.',
                        onRetry: fetchNextPage,
                      ),
                      noItemsFoundIndicatorBuilder: (_) => Center(
                        child: Text(
                          'No properties found for "${controller.title}". Try refining your search.',
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
