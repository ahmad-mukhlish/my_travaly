import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_travaly/src/features/search_results/presentation/models/search_results_filter.dart';

class FilterPriceRangeController extends GetxController {
  FilterPriceRangeController({
    required SearchResultsFilter filter,
    required void Function(int low, int high) onChanged,
  })  : _currentValues = _normalizeRange(filter.lowPrice, filter.highPrice),
        _onChanged = onChanged;

  RangeValues _currentValues;
  final void Function(int low, int high) _onChanged;

  RangeValues get currentValues => _currentValues;

  void syncWithFilter(SearchResultsFilter filter) {
    final nextValues = _normalizeRange(filter.lowPrice, filter.highPrice);
    if (_currentValues != nextValues) {
      _currentValues = nextValues;
    }
  }

  void handleRangeChanged(RangeValues values) {
    if (_currentValues != values) {
      _currentValues = values;
      update();
    }
    _onChanged(values.start.round(), values.end.round());
  }

  String formatPrice(double value) {
    final rounded = value.round();
    if (rounded >= 100000) {
      final lakhs = (rounded / 100000).toStringAsFixed(1);
      return '₹${lakhs}L';
    }
    return '₹$rounded';
  }

  static RangeValues _normalizeRange(int low, int high) {
    final normalizedLow = low.clamp(0, kSearchResultsMaxPrice).toDouble();
    final normalizedHigh =
        high.clamp(normalizedLow, kSearchResultsMaxPrice.toDouble()).toDouble();
    return RangeValues(normalizedLow, normalizedHigh);
  }
}
