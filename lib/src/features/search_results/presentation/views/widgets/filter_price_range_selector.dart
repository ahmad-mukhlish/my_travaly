import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_travaly/src/features/search_results/controllers/filter_price_range_controller.dart';
import 'package:my_travaly/src/features/search_results/presentation/models/search_results_filter.dart';

class FilterPriceRangeSelector extends StatelessWidget {
  const FilterPriceRangeSelector({
    super.key,
    required this.filter,
    required this.onChanged,
    this.controllerTag,
  });

  final SearchResultsFilter filter;
  final void Function(int low, int high) onChanged;
  final String? controllerTag;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilterPriceRangeController>(
      init: FilterPriceRangeController(filter: filter, onChanged: onChanged),
      global: false,
      tag: controllerTag,
      builder: (controller) {
        controller.syncWithFilter(filter);
        final theme = Theme.of(context);
        final currentValues = controller.currentValues;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price range', style: theme.textTheme.labelMedium),
            const SizedBox(height: 4),
            RangeSlider(
              min: 0,
              max: kSearchResultsMaxPrice.toDouble(),
              divisions: kSearchResultsMaxPrice ~/ 100,
              values: currentValues,
              labels: RangeLabels(
                controller.formatPrice(currentValues.start),
                controller.formatPrice(currentValues.end),
              ),
              onChanged: controller.handleRangeChanged,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.formatPrice(currentValues.start),
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  controller.formatPrice(currentValues.end),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
