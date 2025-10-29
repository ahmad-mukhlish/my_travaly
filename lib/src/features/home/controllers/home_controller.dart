import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../login/controllers/login_controller.dart';
import '../../login/model/login_model.dart';
import '../data/models/property_model.dart';
import '../data/repositories/home_repository.dart';
import '../model/entity_type.dart';
import '../model/property_search_type.dart';

class HomeController extends GetxController {
  HomeController({HomeRepository? repository})
      : _repository = repository ?? Get.find<HomeRepository>();

  final HomeRepository _repository;

  final RxBool isSigningOut = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<Property> properties = <Property>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<PropertySearchType> selectedSearchType = PropertySearchType.city.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedTabIndex = 0.obs;
  final Rx<EntityType> selectedEntityType = EntityType.any.obs;

  final LoginController loginController = Get.find<LoginController>();
  final SearchController searchController = SearchController();
  Timer? _searchDebounce;

  LoginUser? get user => loginController.user.value;

  @override
  void onInit() {
    super.onInit();
    fetchProperties();
  }

  @override
  void onClose() {
    searchController.dispose();
    _searchDebounce?.cancel();
    super.onClose();
  }

  Future<void> fetchProperties({String? query, EntityType? entityType}) async {
    final visitorToken = user?.visitorToken ?? '';
    if (visitorToken.isEmpty) {
      errorMessage.value = 'Visitor token missing. Please sign out and sign in again.';
      properties.clear();
      return;
    }

    final searchInput = (query ?? searchQuery.value).trim();
    final effectiveQuery = searchInput.isEmpty ? '' : searchInput;

    searchQuery.value = effectiveQuery;
    if (searchController.text.trim() != effectiveQuery) {
      searchController.text = effectiveQuery;
    }

    final EntityType nextEntityType = entityType ?? selectedEntityType.value;
    if (selectedEntityType.value != nextEntityType) {
      selectedEntityType.value = nextEntityType;
    }

    final (searchType, searchInfo) =
        _buildSearchParams(selectedSearchType.value, effectiveQuery);

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final fetched = await _repository.getProperties(
        visitorToken: visitorToken,
        searchType: searchType,
        searchInfo: searchInfo,
        entityType: nextEntityType.backendValue,
      );
      properties.assignAll(fetched);
    } catch (error) {
      errorMessage.value = 'Failed to load properties: $error';
      properties.clear();
    } finally {
      isLoading.value = false;
    }
  }

  (String, Map<String, dynamic>) _buildSearchParams(
    PropertySearchType type,
    String query,
  ) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return ('byRandom', const {});
    }

    switch (type) {
      case PropertySearchType.hotelName:
        return (
          'byRandom',
          {
            'keyword': trimmedQuery,
            'propertyName': trimmedQuery,
          },
        );
      case PropertySearchType.city:
        return (
          'byCity',
          {
            'city': trimmedQuery,
          },
        );
      case PropertySearchType.state:
        return (
          'byState',
          {
            'state': trimmedQuery,
          },
        );
      case PropertySearchType.country:
        return (
          'byCountry',
          {
            'country': trimmedQuery,
          },
        );
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      searchAutoComplete(searchQuery.value);
    });
  }

  void onSearchSubmitted(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return;
    }
    searchQuery.value = trimmed;
    // Get.toNamed(
    //   AppRoutes.searchResults,
    //   arguments: SearchResultsArguments(
    //     query: trimmed,
    //     searchType: selectedSearchType.value,
    //   ),
    // );
    Get.snackbar(
      'Search autocomplete submit',
      'Query: $value',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  void onSearchTypeChanged(PropertySearchType type) {
    selectedSearchType.value = type;
    fetchProperties();
  }

  void onEntityTypeSelected(EntityType type) {
    if (selectedEntityType.value == type) {
      return;
    }
    selectedEntityType.value = type;
    fetchProperties(entityType: type);
  }

  void searchAutoComplete(String query) {
    Get.snackbar(
      'Search autocomplete',
      'Query: $query',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  void changeTab(int index) {
    if (selectedTabIndex.value != index) {
      selectedTabIndex.value = index;
    }
  }

  void signOut() async {
    isSigningOut.value = true;
    await loginController.signOut();
    isSigningOut.value = false;
  }
}
