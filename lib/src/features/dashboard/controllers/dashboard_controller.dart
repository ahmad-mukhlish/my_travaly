import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../login/controllers/login_controller.dart';
import '../../login/model/login_model.dart';
import '../data/models/popular_stay_model.dart';
import '../data/repositories/dashboard_repository.dart';

enum PopularStaySearchType { hotelName, city, state, country }

class DashboardController extends GetxController {
  DashboardController({DashboardRepository? repository})
      : _repository = repository ?? Get.find<DashboardRepository>();

  final DashboardRepository _repository;

  final RxBool isSigningOut = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<PopularStay> popularStays = <PopularStay>[].obs;
  final RxString searchQuery = 'Jamshedpur'.obs;
  final Rx<PopularStaySearchType> selectedSearchType =
      PopularStaySearchType.city.obs;
  final RxString errorMessage = ''.obs;

  final LoginController loginController = Get.find<LoginController>();
  final TextEditingController searchTextController =
      TextEditingController(text: 'Jamshedpur');

  LoginUser? get user => loginController.user.value;

  @override
  void onInit() {
    super.onInit();
    fetchPopularStays();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  Future<void> fetchPopularStays({String? query}) async {
    final visitorToken = user?.visitorToken ?? '';
    if (visitorToken.isEmpty) {
      errorMessage.value =
          'Visitor token missing. Please sign out and sign in again.';
      popularStays.clear();
      return;
    }

    final searchInput = (query ?? searchQuery.value).trim();
    if (searchInput.isEmpty) {
      searchQuery.value = 'Jamshedpur';
      searchTextController.text = 'Jamshedpur';
    }

    final effectiveQuery = searchInput.isEmpty ? 'Jamshedpur' : searchInput;
    searchQuery.value = effectiveQuery;
    if (searchTextController.text.trim() != effectiveQuery) {
      searchTextController.text = effectiveQuery;
    }
    final (searchType, searchInfo) =
        _buildSearchParams(selectedSearchType.value, effectiveQuery);

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final stays = await _repository.getPopularStays(
        visitorToken: visitorToken,
        searchType: searchType,
        searchInfo: searchInfo,
      );
      popularStays.assignAll(stays);
    } catch (error) {
      errorMessage.value = 'Failed to load stays: $error';
      popularStays.clear();
    } finally {
      isLoading.value = false;
    }
  }

  (String, Map<String, dynamic>) _buildSearchParams(
    PopularStaySearchType type,
    String query,
  ) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return ('byRandom', const {});
    }

    switch (type) {
      case PopularStaySearchType.hotelName:
        return (
          'byRandom',
          {
            'keyword': trimmed,
            'propertyName': trimmed,
          },
        );
      case PopularStaySearchType.city:
        return (
          'byCity',
          {
            'country': '',
            'state': '',
            'city': trimmed,
          },
        );
      case PopularStaySearchType.state:
        return (
          'byState',
          {
            'country': '',
            'state': trimmed,
          },
        );
      case PopularStaySearchType.country:
        return (
          'byCountry',
          {
            'country': trimmed,
          },
        );
    }
  }

  void onSearchSubmitted(String value) {
    searchQuery.value = value;
    fetchPopularStays(query: value);
  }

  void onSearchTypeChanged(PopularStaySearchType type) {
    selectedSearchType.value = type;
    fetchPopularStays();
  }

  void signOut() async {
    isSigningOut.value = true;
    await loginController.signOut();
    isSigningOut.value = false;
  }
}
