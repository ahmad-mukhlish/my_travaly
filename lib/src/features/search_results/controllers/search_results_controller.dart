import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../home/models/property_search_type.dart';
import '../../login/controllers/login_controller.dart';
import '../data/models/search_result_model.dart';
import '../data/repositories/search_results_repository.dart';
import '../models/search_results_arguments.dart';

class SearchResultsController extends GetxController {
  SearchResultsController({
    SearchResultsRepository? repository,
    required SearchResultsArguments arguments,
  })  : _repository = repository ?? Get.find<SearchResultsRepository>(),
        _arguments = arguments;

  static const int _pageSize = 5;

  final SearchResultsRepository _repository;
  final SearchResultsArguments _arguments;
  final LoginController _loginController = Get.find<LoginController>();

  late final PagingController<int, SearchResult> pagingController =
      PagingController<int, SearchResult>(
    getNextPageKey: _getNextPageKey,
    fetchPage: _fetchPage,
  );

  final Set<String> _excludedHotelCodes = <String>{};

  PropertySearchType get searchType => _arguments.searchType;
  String get query => _arguments.query;

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
      throw Exception(
        'Visitor token missing. Please sign out and sign in again.',
      );
    }

    if (query.trim().isEmpty) {
      throw Exception('Missing search query.');
    }

    if (pageKey == 0) {
      _excludedHotelCodes.clear();
    }

    try {
      final page = await _repository.fetchSearchResults(
        visitorToken: visitorToken,
        query: query,
        searchType: searchType.apiValue,
        limit: _pageSize,
        excludedHotelCodes: _excludedHotelCodes.toList(),
        pageKey: pageKey,
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

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
