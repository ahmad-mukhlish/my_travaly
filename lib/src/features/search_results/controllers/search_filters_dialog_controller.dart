import 'package:get/get.dart';
import 'package:my_travaly/src/features/search_results/controllers/search_results_controller.dart';
import 'package:my_travaly/src/features/search_results/presentation/models/search_results_filter.dart';

class SearchFiltersDialogController extends GetxController {
  SearchFiltersDialogController({required SearchResultsController parent})
      : _parentController = parent,
        _filter = _normalizeInitial(parent.currentFilter);

  final SearchResultsController _parentController;
  SearchResultsFilter _filter;

  SearchResultsFilter get filter => _filter;

  void setCheckIn(DateTime newCheckIn) {
    final normalized = _truncate(newCheckIn);
    var nextCheckOut = _filter.checkOut;
    if (!nextCheckOut.isAfter(normalized)) {
      nextCheckOut = normalized.add(const Duration(days: 1));
    }
    _updateFilter(
      _filter.copyWith(
        checkIn: normalized,
        checkOut: nextCheckOut,
      ),
    );
  }

  void setCheckOut(DateTime newCheckOut) {
    var normalized = _truncate(newCheckOut);
    if (!normalized.isAfter(_filter.checkIn)) {
      normalized = _filter.checkIn.add(const Duration(days: 1));
    }
    _updateFilter(_filter.copyWith(checkOut: normalized));
  }

  void setRooms(int rooms) {
    final updatedAdults = rooms > _filter.adults ? rooms : _filter.adults;
    _updateFilter(
      _filter.copyWith(
        rooms: rooms,
        adults: updatedAdults,
      ),
    );
  }

  void setAdults(int adults) {
    if (adults < _filter.rooms) {
      adults = _filter.rooms;
    }
    _updateFilter(_filter.copyWith(adults: adults));
  }

  void setChildren(int children) {
    _updateFilter(_filter.copyWith(children: children));
  }

  void setPriceRange(int low, int high) {
    final normalizedLow = low.clamp(0, kSearchResultsMaxPrice).toInt();
    final normalizedHigh =
        high.clamp(normalizedLow, kSearchResultsMaxPrice).toInt();
    _updateFilter(
      _filter.copyWith(
        lowPrice: normalizedLow,
        highPrice: normalizedHigh,
      ),
    );
  }

  void applySelection() {
    _parentController.updateFilter(_filter, refresh: true);
  }

  void resetFilter(SearchResultsFilter nextFilter) {
    _updateFilter(_normalizeInitial(nextFilter), shouldUpdate: false);
  }

  void _updateFilter(SearchResultsFilter next, {bool shouldUpdate = true}) {
    if (_filtersEqual(next, _filter)) return;
    _filter = next;
    if (shouldUpdate) update();
  }

  static SearchResultsFilter _normalizeInitial(SearchResultsFilter filter) {
    final adjustedAdults =
        filter.adults < filter.rooms ? filter.copyWith(adults: filter.rooms) : filter;

    final normalizedLow = adjustedAdults.lowPrice
        .clamp(0, kSearchResultsMaxPrice)
        .toInt();
    final normalizedHigh = adjustedAdults.highPrice
        .clamp(normalizedLow, kSearchResultsMaxPrice)
        .toInt();

    if (normalizedLow != adjustedAdults.lowPrice ||
        normalizedHigh != adjustedAdults.highPrice) {
      return adjustedAdults.copyWith(
        lowPrice: normalizedLow,
        highPrice: normalizedHigh,
      );
    }
    return adjustedAdults;
  }

  static DateTime _truncate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool _filtersEqual(
    SearchResultsFilter a,
    SearchResultsFilter b,
  ) {
    return a.checkIn == b.checkIn &&
        a.checkOut == b.checkOut &&
        a.rooms == b.rooms &&
        a.adults == b.adults &&
        a.children == b.children &&
        a.lowPrice == b.lowPrice &&
        a.highPrice == b.highPrice;
  }
}
