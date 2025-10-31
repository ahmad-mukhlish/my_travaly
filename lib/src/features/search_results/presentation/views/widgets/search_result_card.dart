import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_travaly/src/features/search_results/data/models/search_result_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({required this.result, super.key});

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
                  color: theme.colorScheme.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                  ),
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
                      result.rating > 0
                          ? result.rating.toStringAsFixed(1)
                          : 'NR',
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
                  Text(result.street, style: theme.textTheme.bodySmall),
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

  String _formatLocation(SearchResult result) {
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

  Future<void> _openPropertyUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      Get.snackbar(
        'Invalid link',
        'The property URL appears to be malformed.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    if (!launched) {
      Get.snackbar(
        'Unable to open',
        'Could not open the property link on this device.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
