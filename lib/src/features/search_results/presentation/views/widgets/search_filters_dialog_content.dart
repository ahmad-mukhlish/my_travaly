import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_travaly/src/features/search_results/controllers/search_results_controller.dart';
import 'package:my_travaly/src/features/search_results/controllers/search_filters_dialog_controller.dart';
import 'package:my_travaly/src/features/search_results/presentation/views/widgets/filter_counter_selector.dart';
import 'package:my_travaly/src/features/search_results/presentation/views/widgets/filter_date_selector.dart';
import 'package:my_travaly/src/features/search_results/presentation/views/widgets/filter_price_range_selector.dart';

class SearchFiltersDialogContent extends StatelessWidget {
  const SearchFiltersDialogContent({super.key, required this.controller});

  final SearchResultsController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchFiltersDialogController>(
      init: SearchFiltersDialogController(parent: controller),
      global: false,
      builder: (dialogController) {
        final filter = dialogController.filter;
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
                    date: filter.checkIn,
                    onTap: () async {
                      final selected = await _pickDate(
                        context,
                        initial: filter.checkIn,
                        firstDate: DateTime.now(),
                      );
                      if (selected != null) {
                        dialogController.setCheckIn(selected);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  FilterDateSelector(
                    label: 'Check-out',
                    date: filter.checkOut,
                    onTap: () async {
                      final selected = await _pickDate(
                        context,
                        initial: filter.checkOut,
                        firstDate: filter.checkIn.add(
                          const Duration(days: 1),
                        ),
                      );
                      if (selected != null) {
                        dialogController.setCheckOut(selected);
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
                    value: filter.rooms,
                    minValue: 1,
                    onChanged: dialogController.setRooms,
                  ),
                  const SizedBox(height: 12),
                  FilterCounterSelector(
                    label: 'Adults',
                    value: filter.adults,
                    minValue: filter.rooms,
                    onChanged: dialogController.setAdults,
                  ),
                  const SizedBox(height: 12),
                  FilterCounterSelector(
                    label: 'Children',
                    value: filter.children,
                    minValue: 0,
                    onChanged: dialogController.setChildren,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilterPriceRangeSelector(
                filter: filter,
                onChanged: dialogController.setPriceRange,
                controllerTag: 'searchFiltersPriceRange',
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    dialogController.applySelection();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Apply'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<DateTime?> _pickDate(
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
}
