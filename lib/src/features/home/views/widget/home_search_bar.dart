import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:my_travaly/src/features/home/model/property_search_type.dart';

import '../../controllers/home_controller.dart';
import '../../model/auto_complete_entry.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Obx(() {
          final placeholder =
              controller.selectedSearchType.value.placeholder;
          return Row(
            children: [
              Expanded(
                child: TypeAheadField<HomeAutoCompleteEntry>(
                  controller: controller.searchController,
                  debounceDuration: const Duration(milliseconds: 400),
                  suggestionsCallback: controller.searchAutoComplete,
                  constraints: const BoxConstraints(maxHeight: 360),
                  hideOnEmpty: true,
                  hideOnError: false,
                  hideOnLoading: false,
                  builder: (context, textController, focusNode) {
                    return SearchBar(
                      controller: textController,
                      focusNode: focusNode,
                      hintText: placeholder,
                      leading: const Icon(Icons.search),
                      trailing: [
                        IconButton(
                          onPressed: () {
                            textController.clear();
                            controller.onSearchChanged('');
                          },
                          icon: const Icon(Icons.close),
                          tooltip: 'Clear search',
                        ),
                        IconButton(
                          onPressed: () => controller.fetchProperties(
                            query: textController.text,
                          ),
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Refresh results',
                        ),
                      ],
                      onChanged: controller.onSearchChanged,
                      onSubmitted: controller.onSearchSubmitted,
                      textInputAction: TextInputAction.search,
                    );
                  },
                  itemBuilder: (context, entry) {
                    if (entry is HomeAutoCompleteHeader) {
                      return IgnorePointer(
                        ignoring: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Text(
                            '${entry.title} (${entry.count})',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }

                    if (entry is! HomeAutoCompleteItem) {
                      return const SizedBox.shrink();
                    }

                    final address = entry.address;
                    final subtitleParts = <String>[];
                    final city = address?.city?.trim();
                    final state = address?.state?.trim();
                    final country = address?.country?.trim();
                    if (city != null && city.isNotEmpty) {
                      subtitleParts.add(city);
                    }
                    if (state != null && state.isNotEmpty) {
                      subtitleParts.add(state);
                    }
                    if (country != null &&
                        country.isNotEmpty &&
                        !subtitleParts.contains(country)) {
                      subtitleParts.add(country);
                    }

                    return ListTile(
                      leading: Icon(
                        entry.category.icon,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        entry.title,
                        style: theme.textTheme.bodyLarge,
                      ),
                      subtitle: subtitleParts.isEmpty
                          ? null
                          : Text(
                              subtitleParts.join(', '),
                              style: theme.textTheme.bodySmall,
                            ),
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                    );
                  },
                  onSelected: (entry) {
                    if (entry is HomeAutoCompleteItem) {
                      controller.handleAutoCompleteSelection(entry);
                    }
                  },
                  emptyBuilder: (context) => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No suggestions found.'),
                  ),
                  loadingBuilder: (context) => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorBuilder: (context, error) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      controller.autoCompleteError.value.isNotEmpty
                          ? controller.autoCompleteError.value
                          : 'Failed to load suggestions.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                  decorationBuilder: (context, child) {
                    return Material(
                      elevation: 4,
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      child: child,
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
