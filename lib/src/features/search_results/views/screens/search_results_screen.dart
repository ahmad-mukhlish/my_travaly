import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../controllers/search_results_controller.dart';
import '../../../home/model/property_search_type.dart';
import '../../data/models/search_result_model.dart';

class SearchResultsScreen extends GetView<SearchResultsController> {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final query = controller.query;
    final searchTypeLabel = controller.searchType.label.toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: Text('Results for "$query"'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32),
          child: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Searching by $searchTypeLabel',
                style: Theme.of(context).textTheme.bodySmall,
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
                    _SearchResultCard(result: result),
                firstPageProgressIndicatorBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
                newPageProgressIndicatorBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
                firstPageErrorIndicatorBuilder: (_) => _ErrorIndicator(
                  message:
                      state.error?.toString() ?? 'Failed to load results.',
                  onRetry: fetchNextPage,
                ),
                newPageErrorIndicatorBuilder: (_) => _ErrorIndicator(
                  message:
                      state.error?.toString() ?? 'Failed to load more results.',
                  onRetry: fetchNextPage,
                ),
                noItemsFoundIndicatorBuilder: (_) => Center(
                  child: Text(
                    'No properties found for "$query". Try refining your search.',
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

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.result});

  final SearchResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result.imageUrl.isNotEmpty)
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Image.network(
                result.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: theme.colorScheme.surfaceVariant,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported_outlined, size: 48),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.propertyName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatLocation(result),
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: theme.colorScheme.secondary,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      result.rating > 0 ? result.rating.toStringAsFixed(1) : 'NR',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${result.totalReviews} reviews)',
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      result.priceDisplayAmount.isNotEmpty
                          ? result.priceDisplayAmount
                          : '--',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  result.propertyType.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                    letterSpacing: 0.6,
                  ),
                ),
                if (result.street.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    result.street,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                if (result.propertyUrl.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => _openPropertyUrl(result.propertyUrl),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('View details'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatLocation(SearchResult result) {
    final buffer = StringBuffer();
    if (result.city.isNotEmpty) {
      buffer.write(result.city);
    }
    if (result.state.isNotEmpty) {
      if (buffer.isNotEmpty) buffer.write(', ');
      buffer.write(result.state);
    }
    if (result.country.isNotEmpty) {
      if (buffer.isNotEmpty) buffer.write(', ');
      buffer.write(result.country);
    }
    return buffer.isEmpty ? 'Location unavailable' : buffer.toString();
  }

  static void _openPropertyUrl(String url) {
    Get.snackbar(
      'Coming soon',
      'Opening property links is not implemented yet.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class _ErrorIndicator extends StatelessWidget {
  const _ErrorIndicator({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
