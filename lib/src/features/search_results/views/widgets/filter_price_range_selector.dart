import 'package:flutter/material.dart';
import 'package:my_travaly/src/features/search_results/models/search_results_filter.dart';

class FilterPriceRangeSelector extends StatefulWidget {
  const FilterPriceRangeSelector({
    super.key,
    required this.filter,
    required this.onChanged,
  });

  final SearchResultsFilter filter;
  final void Function(int low, int high) onChanged;

  @override
  State<FilterPriceRangeSelector> createState() => _FilterPriceRangeSelectorState();
}

class _FilterPriceRangeSelectorState extends State<FilterPriceRangeSelector> {
  late RangeValues _currentValues;

  @override
  void initState() {
    super.initState();
    _currentValues = _normalizeRange(
      widget.filter.lowPrice,
      widget.filter.highPrice,
    );
  }

  @override
  void didUpdateWidget(covariant FilterPriceRangeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filter.lowPrice != widget.filter.lowPrice ||
        oldWidget.filter.highPrice != widget.filter.highPrice) {
      _currentValues = _normalizeRange(
        widget.filter.lowPrice,
        widget.filter.highPrice,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Price range', style: theme.textTheme.labelMedium),
        const SizedBox(height: 4),
        RangeSlider(
          min: 0,
          max: kSearchResultsMaxPrice.toDouble(),
          divisions: kSearchResultsMaxPrice ~/ 100,
          values: _currentValues,
          labels: RangeLabels(
            _formatPrice(_currentValues.start),
            _formatPrice(_currentValues.end),
          ),
          onChanged: (values) {
            setState(() {
              _currentValues = values;
            });
            widget.onChanged(values.start.round(), values.end.round());
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatPrice(_currentValues.start), style: theme.textTheme.bodySmall),
            Text(_formatPrice(_currentValues.end), style: theme.textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  RangeValues _normalizeRange(int low, int high) {
    final normalizedLow = low.clamp(0, kSearchResultsMaxPrice).toDouble();
    final normalizedHigh = high
        .clamp(normalizedLow, kSearchResultsMaxPrice.toDouble())
        .toDouble();
    return RangeValues(normalizedLow, normalizedHigh);
  }

  String _formatPrice(double value) {
    final rounded = value.round();
    if (rounded >= 100000) {
      final lakhs = (rounded / 100000).toStringAsFixed(1);
      return '₹${lakhs}L';
    }
    return '₹$rounded';
  }
}
