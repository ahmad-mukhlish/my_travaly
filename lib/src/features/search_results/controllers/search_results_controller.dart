import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:my_travaly/src/features/home/model/property_search_type.dart';
import 'package:my_travaly/src/features/login/controllers/login_controller.dart';
import 'package:my_travaly/src/features/search_results/data/models/search_result_model.dart';
import 'package:my_travaly/src/features/search_results/data/repositories/search_results_repository.dart';
import 'package:my_travaly/src/features/search_results/models/search_results_arguments.dart';
import 'package:my_travaly/src/features/search_results/models/search_results_filter.dart';
import 'package:my_travaly/src/features/search_results/views/widgets/search_filters_dialog_content.dart';

class SearchResultsController extends GetxController {
  SearchResultsController({
    SearchResultsRepository? repository,
    required SearchResultsArguments arguments,
  })  : _repository = repository ?? Get.find<SearchResultsRepository>(),
        _arguments = arguments,
        filter = (arguments.initialFilter ?? SearchResultsFilter.defaults()).obs {
    pagingController = PagingController<int, SearchResult>(
      getNextPageKey: _getNextPageKey,
      fetchPage: _fetchPage,
    );
  }

  static const int _pageSize = 5;

  final SearchResultsRepository _repository;
  final SearchResultsArguments _arguments;
  final LoginController _loginController = Get.find<LoginController>();

  late final PagingController<int, SearchResult> pagingController;
  final Rx<SearchResultsFilter> filter;
  final Set<String> _excludedHotelCodes = <String>{};

  PropertySearchType get searchType => _arguments.searchType;
  String get _apiSearchType => _arguments.customSearchType ?? _arguments.searchType.apiValue;
  List<String> get queries => _arguments.queries;
  String get title {
    if (_arguments.title != null && _arguments.title!.isNotEmpty) {
      return _arguments.title!;
    }
    final normalized = _normalizedQueries();
    return normalized.isNotEmpty ? normalized.first : '';
  }

  SearchResultsFilter get currentFilter => filter.value;

  Future<void> refreshResults() {
    pagingController.refresh();
    return Future.value();
  }

  Future<void> showFiltersDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SearchFiltersDialogContent(controller: this),
          ),
        );
      },
    );
  }

  void updateFilter(SearchResultsFilter newFilter, {bool refresh = true}) {
    filter.value = newFilter;
    if (refresh) {
      refreshResults();
    }
  }

  void setCheckInDate(DateTime date) {
    final truncated = _truncate(date);
    var nextCheckOut = currentFilter.checkOut;
    if (!nextCheckOut.isAfter(truncated)) {
      nextCheckOut = truncated.add(const Duration(days: 1));
    }
    updateFilter(
      currentFilter.copyWith(checkIn: truncated, checkOut: nextCheckOut),
    );
  }

  void setCheckOutDate(DateTime date) {
    final truncated = _truncate(date);
    var resolved = truncated;
    if (!resolved.isAfter(currentFilter.checkIn)) {
      resolved = currentFilter.checkIn.add(const Duration(days: 1));
    }
    updateFilter(currentFilter.copyWith(checkOut: resolved));
  }

  void incrementRooms() => _setRooms(currentFilter.rooms + 1);
  void decrementRooms() => _setRooms(currentFilter.rooms - 1);
  void incrementAdults() => _setAdults(currentFilter.adults + 1);
  void decrementAdults() => _setAdults(currentFilter.adults - 1);
  void incrementChildren() => _setChildren(currentFilter.children + 1);
  void decrementChildren() => _setChildren(currentFilter.children - 1);

  void setPriceRange(int low, int high, {bool refresh = true}) {
    final normalizedLow = low.clamp(0, kSearchResultsMaxPrice);
    final normalizedHigh = high.clamp(normalizedLow, kSearchResultsMaxPrice);
    updateFilter(
      currentFilter.copyWith(
        lowPrice: normalizedLow,
        highPrice: normalizedHigh,
      ),
      refresh: refresh,
    );
  }

  int? _getNextPageKey(PagingState<int, SearchResult> state) {
    if (!state.hasNextPage) {
      return null;
    }

    final keys = state.keys;
    if (keys == null || keys.isEmpty) {
      return 0;
    }

    return keys.last + 1;
  }

  Future<List<SearchResult>> _fetchPage(int pageKey) async {
    final visitorToken = _loginController.user.value?.visitorToken ?? '';
    if (visitorToken.isEmpty) {
      throw Exception('Visitor token missing. Please sign out and sign in again.');
    }

    if (pageKey > 0) {
      pagingController.value = pagingController.value.copyWith(hasNextPage: false);
      return const <SearchResult>[];
    }

    final normalizedQueries = _normalizedQueries();
    if (normalizedQueries.isEmpty) {
      throw Exception('Missing search query.');
    }

    if (pageKey == 0) {
      _excludedHotelCodes.clear();
    }

    final filterValue = currentFilter;

    try {
      final page = await _repository.fetchSearchResults(
        visitorToken: visitorToken,
        queries: normalizedQueries,
        searchType: _apiSearchType,
        limit: _pageSize,
        excludedHotelCodes: _excludedHotelCodes.toList(),
        checkIn: filterValue.checkIn,
        checkOut: filterValue.checkOut,
        rooms: filterValue.rooms,
        adults: filterValue.adults,
        children: filterValue.children,
        lowPrice: filterValue.lowPrice,
        highPrice: filterValue.highPrice,
      );

      _excludedHotelCodes.addAll(page.excludedHotelCodes);
      _excludedHotelCodes.addAll(
        page.results.map((result) => result.propertyCode),
      );

      final isLastPage = page.results.length < _pageSize;
      if (isLastPage) {
        pagingController.value = pagingController.value.copyWith(
          hasNextPage: false,
        );
      }

      return page.results;
    } catch (error) {
      if (error is Exception) {
        rethrow;
      }
      throw Exception(error.toString());
    }
  }

  List<String> _normalizedQueries() {
    return queries
        .map((q) => q.trim())
        .where((q) => q.isNotEmpty)
        .toList(growable: false);
  }

  DateTime _truncate(DateTime date) => DateTime(date.year, date.month, date.day);

  void _setRooms(int rooms) {
    final clamped = rooms.clamp(1, 10);
    updateFilter(currentFilter.copyWith(rooms: clamped));
  }

  void _setAdults(int adults) {
    final clamped = adults.clamp(1, 10);
    updateFilter(currentFilter.copyWith(adults: clamped));
  }

  void _setChildren(int children) {
    final clamped = children.clamp(0, 10);
    updateFilter(currentFilter.copyWith(children: clamped));
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
