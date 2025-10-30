import 'package:flutter/material.dart';
import 'package:my_travaly/src/features/search_results/controllers/search_results_controller.dart';
import 'package:my_travaly/src/features/search_results/models/search_results_filter.dart';
import 'package:my_travaly/src/features/search_results/views/widgets/filter_counter_selector.dart';
import 'package:my_travaly/src/features/search_results/views/widgets/filter_date_selector.dart';
import 'package:my_travaly/src/features/search_results/views/widgets/filter_price_range_selector.dart';

class SearchFiltersDialogContent extends StatefulWidget {
  const SearchFiltersDialogContent({super.key, required this.controller});

  final SearchResultsController controller;

  @override
  State<SearchFiltersDialogContent> createState() => _SearchFiltersDialogContentState();
}

class _SearchFiltersDialogContentState extends State<SearchFiltersDialogContent> {
  late SearchResultsFilter _workingFilter;

  @override
  void initState() {
    super.initState();
    final current = widget.controller.currentFilter;
    final adjustedAdultsFilter = current.adults < current.rooms
        ? current.copyWith(adults: current.rooms)
        : current;
    final normalizedLowPrice = adjustedAdultsFilter.lowPrice.clamp(0, kSearchResultsMaxPrice).toInt();
    final normalizedHighPrice = adjustedAdultsFilter.highPrice
        .clamp(normalizedLowPrice, kSearchResultsMaxPrice)
        .toInt();
    _workingFilter = (normalizedLowPrice != adjustedAdultsFilter.lowPrice ||
            normalizedHighPrice != adjustedAdultsFilter.highPrice)
        ? adjustedAdultsFilter.copyWith(
            lowPrice: normalizedLowPrice,
            highPrice: normalizedHighPrice,
          )
        : adjustedAdultsFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilterDateSelector(
                label: 'Check-in',
                date: _workingFilter.checkIn,
                onTap: () async {
                  final selected = await _pickDate(
                    context,
                    initial: _workingFilter.checkIn,
                    firstDate: DateTime.now(),
                  );
                  if (selected != null) {
                    _updateCheckIn(selected);
                  }
                },
              ),
              const SizedBox(height: 12),
              FilterDateSelector(
                label: 'Check-out',
                date: _workingFilter.checkOut,
                onTap: () async {
                  final selected = await _pickDate(
                    context,
                    initial: _workingFilter.checkOut,
                    firstDate: _workingFilter.checkIn.add(const Duration(days: 1)),
                  );
                  if (selected != null) {
                    _updateCheckOut(selected);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilterCounterSelector(
                label: 'Rooms',
                value: _workingFilter.rooms,
                minValue: 1,
                onChanged: (value) => setState(() {
                  final updatedAdults = value > _workingFilter.adults ? value : _workingFilter.adults;
                  _workingFilter = _workingFilter.copyWith(
                    rooms: value,
                    adults: updatedAdults,
                  );
                }),
              ),
              const SizedBox(height: 12),
              FilterCounterSelector(
                label: 'Adults',
                value: _workingFilter.adults,
                minValue: _workingFilter.rooms,
                onChanged: (value) => setState(() {
                  _workingFilter = _workingFilter.copyWith(adults: value);
                }),
              ),
              const SizedBox(height: 12),
              FilterCounterSelector(
                label: 'Children',
                value: _workingFilter.children,
                minValue: 0,
                onChanged: (value) => setState(() {
                  _workingFilter = _workingFilter.copyWith(children: value);
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilterPriceRangeSelector(
            filter: _workingFilter,
            onChanged: (low, high) => setState(() {
              final normalizedLow = low.clamp(0, kSearchResultsMaxPrice).toInt();
              final normalizedHigh = high.clamp(normalizedLow, kSearchResultsMaxPrice).toInt();
              _workingFilter = _workingFilter.copyWith(
                lowPrice: normalizedLow,
                highPrice: normalizedHigh,
              );
            }),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                widget.controller.updateFilter(_workingFilter, refresh: true);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.check),
              label: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }

  void _updateCheckIn(DateTime newCheckIn) {
    final normalized = _truncate(newCheckIn);
    var nextCheckOut = _workingFilter.checkOut;
    if (!nextCheckOut.isAfter(normalized)) {
      nextCheckOut = normalized.add(const Duration(days: 1));
    }
    setState(() {
      _workingFilter = _workingFilter.copyWith(
        checkIn: normalized,
        checkOut: nextCheckOut,
      );
    });
  }

  void _updateCheckOut(DateTime newCheckOut) {
    var normalized = _truncate(newCheckOut);
    if (!normalized.isAfter(_workingFilter.checkIn)) {
      normalized = _workingFilter.checkIn.add(const Duration(days: 1));
    }
    setState(() {
      _workingFilter = _workingFilter.copyWith(checkOut: normalized);
    });
  }

  static Future<DateTime?> _pickDate(
    BuildContext context, {
    required DateTime initial,
    required DateTime firstDate,
  }) {
    final today = DateTime.now();
    final lastDate = DateTime(today.year + 2, today.month, today.day);
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  DateTime _truncate(DateTime date) => DateTime(date.year, date.month, date.day);
}
