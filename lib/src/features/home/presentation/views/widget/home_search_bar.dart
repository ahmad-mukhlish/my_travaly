import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:my_travaly/src/features/home/controllers/home_search_bar_controller.dart';
import 'package:my_travaly/src/features/home/presentation/models/home_auto_complete_entry.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
    required this.controller,
    required this.onQueryChanged,
    required this.onQuerySubmitted,
    required this.onRefreshRequested,
    required this.onSuggestionSelected,
  });

  final HomeSearchBarController controller;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onQuerySubmitted;
  final Future<void> Function(String) onRefreshRequested;
  final Future<void> Function(HomeAutoCompleteItem) onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
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
                builder: _buildSearchInput,
                itemBuilder: _buildSuggestionEntry,
                onSelected: _handleEntrySelected,
                emptyBuilder: _buildEmptyState,
                loadingBuilder: _buildLoadingState,
                errorBuilder: _buildErrorState,
                decorationBuilder: _decorateSuggestions,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchInput(
    BuildContext context,
    TextEditingController textController,
    FocusNode focusNode,
  ) {
    return SearchBar(
      controller: textController,
      focusNode: focusNode,
      hintText: 'Search your next stay...',
      leading: const Icon(Icons.search),
      trailing: [
        IconButton(
          onPressed: () {
            textController.clear();
            onQueryChanged('');
          },
          icon: const Icon(Icons.close),
          tooltip: 'Clear search',
        ),
        IconButton(
          onPressed: () {
            onRefreshRequested(textController.text);
          },
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh results',
        ),
      ],
      onChanged: onQueryChanged,
      onSubmitted: onQuerySubmitted,
      textInputAction: TextInputAction.search,
    );
  }

  Widget _buildSuggestionEntry(
    BuildContext context,
    HomeAutoCompleteEntry entry,
  ) {
    if (entry is HomeAutoCompleteHeader) {
      return _buildHeaderTile(context, entry);
    }
    if (entry is HomeAutoCompleteItem) {
      return _buildSuggestionTile(context, entry);
    }
    return const SizedBox.shrink();
  }

  Widget _buildHeaderTile(BuildContext context, HomeAutoCompleteHeader entry) {
    final theme = Theme.of(context);
    return IgnorePointer(
      ignoring: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          '${entry.title} (${entry.count})',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionTile(
    BuildContext context,
    HomeAutoCompleteItem entry,
  ) {
    final theme = Theme.of(context);
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
      leading: Icon(entry.category.icon, color: theme.colorScheme.primary),
      title: Text(entry.title, style: theme.textTheme.bodyLarge),
      subtitle: subtitleParts.isEmpty
          ? null
          : Text(subtitleParts.join(', '), style: theme.textTheme.bodySmall),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  void _handleEntrySelected(HomeAutoCompleteEntry entry) {
    if (entry is HomeAutoCompleteItem) {
      onSuggestionSelected(entry);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('No suggestions found.'),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _buildErrorState(BuildContext context, Object? error) {
    final theme = Theme.of(context);
    final errorMessage = controller.autoCompleteError.value;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        errorMessage.isNotEmpty ? errorMessage : 'Failed to load suggestions.',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    );
  }

  Widget _decorateSuggestions(BuildContext context, Widget child) {
    final theme = Theme.of(context);
    return Material(
      elevation: 4,
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: child,
    );
  }
}
