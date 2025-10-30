import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../login/controllers/login_controller.dart';
import '../../login/model/login_model.dart';
import '../data/models/search_auto_complete_result.dart' hide AutoCompleteCategory;
import '../data/repositories/home_repository.dart';
import '../model/auto_complete_entry.dart';
import '../model/home_auto_complete_entry.dart';
import '../model/auto_complete_search_type.dart';

class HomeSearchBarController extends GetxController {
  HomeSearchBarController({
    HomeRepository? repository,
    LoginController? loginController,
  })  : _repository = repository ?? Get.find<HomeRepository>(),
        _loginController = loginController ?? Get.find<LoginController>();

  static final List<String> _autoCompleteDisplayOrder = AutoCompleteSearchType.displayOrderKeys;
  static final List<String> _autoCompleteSearchTypes = AutoCompleteSearchType.searchTypeKeys;

  final HomeRepository _repository;
  final LoginController _loginController;

  final SearchController searchController = SearchController();
  final RxBool isAutoCompleteLoading = false.obs;
  final Rxn<SearchAutoCompleteResult> autoCompleteResult = Rxn<SearchAutoCompleteResult>();
  final RxString autoCompleteError = ''.obs;

  String _lastAutoCompleteQuery = '';
  List<HomeAutoCompleteEntry> _cachedAutoCompleteEntries = const <HomeAutoCompleteEntry>[];

  LoginUser? get user => _loginController.user.value;

  void clearAutoCompleteState() {
    _lastAutoCompleteQuery = '';
    autoCompleteResult.value = null;
    autoCompleteError.value = '';
    _cachedAutoCompleteEntries = const <HomeAutoCompleteEntry>[];
  }

  Future<List<HomeAutoCompleteEntry>> searchAutoComplete(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      clearAutoCompleteState();
      return _cachedAutoCompleteEntries;
    }

    if (trimmed == _lastAutoCompleteQuery &&
        autoCompleteError.value.isEmpty &&
        _cachedAutoCompleteEntries.isNotEmpty) {
      return _cachedAutoCompleteEntries;
    }

    final visitorToken = user?.visitorToken ?? '';
    if (visitorToken.isEmpty) {
      autoCompleteError.value =
          'Visitor token missing. Please sign out and sign in again.';
      autoCompleteResult.value = null;
      _cachedAutoCompleteEntries = const <HomeAutoCompleteEntry>[];
      return _cachedAutoCompleteEntries;
    }

    _lastAutoCompleteQuery = trimmed;
    isAutoCompleteLoading.value = true;
    autoCompleteError.value = '';

    try {
      final result = await _repository.searchAutoComplete(
        visitorToken: visitorToken,
        inputText: trimmed,
        searchTypes: _autoCompleteSearchTypes,
      );
      autoCompleteResult.value = result;
      _cachedAutoCompleteEntries = _buildAutoCompleteEntries(result);
      return _cachedAutoCompleteEntries;
    } catch (error) {
      autoCompleteError.value = 'Failed to fetch suggestions: $error';
      autoCompleteResult.value = null;
      _lastAutoCompleteQuery = '';
      _cachedAutoCompleteEntries = const <HomeAutoCompleteEntry>[];
      throw Exception(autoCompleteError.value);
    } finally {
      isAutoCompleteLoading.value = false;
    }
  }

  List<HomeAutoCompleteEntry> _buildAutoCompleteEntries(
    SearchAutoCompleteResult result,
  ) {
    final entries = <HomeAutoCompleteEntry>[];
    final orderedKeys = result.categories.keys.toList()
      ..sort((a, b) {
        final indexA = _autoCompleteDisplayOrder.indexOf(a);
        final indexB = _autoCompleteDisplayOrder.indexOf(b);
        if (indexA == -1 && indexB == -1) {
          return a.compareTo(b);
        }
        if (indexA == -1) {
          return 1;
        }
        if (indexB == -1) {
          return -1;
        }
        return indexA.compareTo(indexB);
      });

    for (final key in orderedKeys) {
      final category = result.categories[key];
      if (category == null) {
        continue;
      }
      if (!category.present || category.suggestions.isEmpty) {
        continue;
      }
      final resolvedCategory = categoryFromKey(key);
      entries.add(
        HomeAutoCompleteHeader(
          category: resolvedCategory,
          title: resolvedCategory.displayName,
          count: category.numberOfResult,
        ),
      );
      for (final suggestion in category.suggestions) {
        entries.add(
          HomeAutoCompleteItem(
            category: resolvedCategory,
            categoryKey: key,
            suggestion: suggestion,
          ),
        );
      }
    }
    return entries;
  }


  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
