import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_travaly/src/routes/app_routes.dart';

import '../../login/controllers/login_controller.dart';
import '../../login/model/login_model.dart';
import '../data/models/property_model.dart';
import '../data/repositories/home_repository.dart';
import '../model/property_search_type.dart';
import '../../search_results/models/search_results_arguments.dart';

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

  final LoginController loginController = Get.find<LoginController>();
  final SearchController searchController = SearchController();

  LoginUser? get user => loginController.user.value;

  @override
  void onInit() {
    super.onInit();
    fetchProperties();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchProperties({String? query}) async {
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

    final (searchType, searchInfo) =
        _buildSearchParams(selectedSearchType.value, effectiveQuery);

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final fetched = await _repository.getProperties(
        visitorToken: visitorToken,
        searchType: searchType,
        searchInfo: searchInfo,
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
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return ('byRandom', const {});
    }

    switch (type) {
      case PropertySearchType.hotelName:
        return (
          'byRandom',
          {
            'keyword': trimmed,
            'propertyName': trimmed,
          },
        );
      case PropertySearchType.city:
        return (
          'byCity',
          {
            'country': '',
            'state': '',
            'city': trimmed,
          },
        );
      case PropertySearchType.state:
        return (
          'byState',
          {
            'country': '',
            'state': trimmed,
          },
        );
      case PropertySearchType.country:
        return (
          'byCountry',
          {
            'country': trimmed,
          },
        );
    }
  }

  void onSearchSubmitted(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return;
    }
    searchQuery.value = trimmed;
    Get.toNamed(
      AppRoutes.searchResults,
      arguments: SearchResultsArguments(
        query: trimmed,
        searchType: selectedSearchType.value,
      ),
    );
  }

  void onSearchTypeChanged(PropertySearchType type) {
    selectedSearchType.value = type;
    fetchProperties();
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
