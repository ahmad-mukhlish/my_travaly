import 'package:get/get.dart';
import 'package:my_travaly/src/features/home/data/models/property_model.dart';
import 'package:my_travaly/src/features/home/data/repositories/home_repository.dart';
import 'package:my_travaly/src/features/home/controllers/home_search_bar_controller.dart';
import 'package:my_travaly/src/enums/enums.dart';
import 'package:my_travaly/src/features/home/presentation/models/home_auto_complete_entry.dart';
import 'package:my_travaly/src/features/login/controllers/login_controller.dart';
import 'package:my_travaly/src/features/login/presentation/models/login_model.dart';
import 'package:my_travaly/src/features/search_results/presentation/models/search_results_arguments.dart';
import 'package:my_travaly/src/features/search_results/presentation/models/search_results_filter.dart';
import 'package:my_travaly/src/routes/app_routes.dart';

class HomeController extends GetxController {
  HomeController({required HomeRepository repository})
    : _repository = repository;

  final HomeRepository _repository;
  final HomeSearchBarController _searchBarController =
      Get.find<HomeSearchBarController>();

  final RxBool isSigningOut = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<Property> properties = <Property>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<PropertySearchType> selectedSearchType = PropertySearchType.city.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedTabIndex = 0.obs;
  final Rx<EntityType> selectedEntityType = EntityType.any.obs;

  final LoginController loginController = Get.find<LoginController>();

  LoginUser? get user => loginController.user.value;

  @override
  void onInit() {
    super.onInit();
    fetchPopularStay();
  }

  Future<void> fetchPopularStay({
    String? query,
    EntityType? entityType,
    PropertySearchType? searchTypeOverride,
    Map<String, dynamic>? searchInfoOverride,
    String? searchTypeKeyOverride,
  }) async {
    final visitorToken = user?.visitorToken ?? '';
    if (visitorToken.isEmpty) {
      errorMessage.value =
          'Visitor token missing. Please sign out and sign in again.';
      properties.clear();
      return;
    }

    final EntityType nextEntityType = entityType ?? selectedEntityType.value;
    if (selectedEntityType.value != nextEntityType) {
      selectedEntityType.value = nextEntityType;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final fetched = await _repository.getPopularStays(
        visitorToken: visitorToken,
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

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onSearchSubmitted(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return;
    }
    searchQuery.value = trimmed;
    _processSearchSubmission(trimmed);
  }

  Future<void> _processSearchSubmission(String query) async {
    try {
      final suggestions = await _searchBarController.searchAutoComplete(query);
      final items = suggestions.whereType<HomeAutoCompleteItem>();
      if (items.isEmpty) throw "items is empty";

      await _navigateWithAutoCompleteItem(items.first);
    } catch (error) {
      Get.snackbar(
        'Search unavailable',
        'Could not refine your search automatically. Showing direct results instead.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _navigateWithAutoCompleteItem(HomeAutoCompleteItem item) async {
    switch (item.category) {
      case AutoCompleteCategory.property:
        final searchArray = item.searchArray;
        final propertyCodes = searchArray?.query ?? const <String>[];
        if (propertyCodes.isEmpty) {
          Get.snackbar(
            'Unavailable',
            'Property details not available for this suggestion.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        if (selectedSearchType.value != PropertySearchType.hotelName) {
          selectedSearchType.value = PropertySearchType.hotelName;
        }
        navigateToSearchResults(
          queries: propertyCodes,
          searchType: PropertySearchType.hotelName,
          customSearchType: searchArray?.type ?? 'hotelIdSearch',
          title: item.title,
        );
        break;
      case AutoCompleteCategory.city:
        final city = item.address?.city?.trim();
        if (selectedSearchType.value != PropertySearchType.city) {
          selectedSearchType.value = PropertySearchType.city;
        }
        final stateValue = item.address?.state?.trim();
        final countryValue = item.address?.country?.trim();
        final queries = <String>[
          if (city != null && city.isNotEmpty) city,
          if (stateValue != null && stateValue.isNotEmpty) stateValue,
          if (countryValue != null && countryValue.isNotEmpty) countryValue,
        ];
        if (queries.isEmpty) {
          queries.add(item.title);
        }
        navigateToSearchResults(
          queries: queries,
          searchType: PropertySearchType.city,
          title: item.title,
        );
        break;
      case AutoCompleteCategory.state:
        final state = item.address?.state?.trim();
        if (selectedSearchType.value != PropertySearchType.state) {
          selectedSearchType.value = PropertySearchType.state;
        }
        final countryValue = item.address?.country?.trim();
        final queries = <String>[
          if (state != null && state.isNotEmpty) state,
          if (countryValue != null && countryValue.isNotEmpty) countryValue,
        ];
        if (queries.isEmpty) {
          queries.add(item.title);
        }
        navigateToSearchResults(
          queries: queries,
          searchType: PropertySearchType.state,
          title: item.title,
        );
        break;
      case AutoCompleteCategory.country:
        final country = item.address?.country?.trim();
        final stateValue = item.address?.state?.trim();
        final cityValue = item.address?.city?.trim();
        if (selectedSearchType.value != PropertySearchType.country) {
          selectedSearchType.value = PropertySearchType.country;
        }
        navigateToSearchResults(
          queries: <String>[
            if (country != null && country.isNotEmpty) country,
            if (stateValue != null && stateValue.isNotEmpty) stateValue,
            if (cityValue != null && cityValue.isNotEmpty) cityValue,
          ],
          searchType: PropertySearchType.country,
          title: item.title,
        );
        break;
      case AutoCompleteCategory.street:
        final streetValue = item.address?.street?.trim();
        final cityValue = item.address?.city?.trim();
        final stateValue = item.address?.state?.trim();
        final countryValue = item.address?.country?.trim();
        if (selectedSearchType.value != PropertySearchType.street) {
          selectedSearchType.value = PropertySearchType.street;
        }
        final queries = <String>[
          if (streetValue != null && streetValue.isNotEmpty) streetValue,
          if (cityValue != null && cityValue.isNotEmpty) cityValue,
          if (stateValue != null && stateValue.isNotEmpty) stateValue,
          if (countryValue != null && countryValue.isNotEmpty) countryValue,
        ];
        if (queries.isEmpty) {
          queries.add(item.title);
        }
        navigateToSearchResults(
          queries: queries,
          searchType: PropertySearchType.street,
          title: item.title,
        );
        break;
      case AutoCompleteCategory.other:
        if (selectedSearchType.value != PropertySearchType.hotelName) {
          selectedSearchType.value = PropertySearchType.hotelName;
        }
        navigateToSearchResults(
          queries: <String>[item.title],
          searchType: PropertySearchType.hotelName,
          customSearchType: item.categoryKey,
          title: item.title,
        );
        break;
    }
  }

  void navigateToSearchResults({
    required List<String> queries,
    required PropertySearchType searchType,
    String? customSearchType,
    String? title,
  }) {
    final normalizedQueries = queries
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList(growable: false);

    if (normalizedQueries.isEmpty) {
      Get.snackbar(
        'Search unavailable',
        'No valid search terms found for this selection.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.toNamed(
      AppRoutes.searchResults,
      arguments: SearchResultsArguments(
        queries: normalizedQueries,
        searchType: searchType,
        customSearchType: customSearchType,
        title: title,
        initialFilter: SearchResultsFilter.defaults(),
      ),
    );
  }

  void handlePropertyTap(Property property) {
    if (property.propertyCode.isEmpty) {
      return;
    }

    navigateToSearchResults(
      queries: <String>[property.propertyCode],
      searchType: PropertySearchType.hotelName,
      customSearchType: 'hotelIdSearch',
      title: property.propertyName,
    );
  }

  void onSearchTypeChanged(PropertySearchType type) {
    selectedSearchType.value = type;
    fetchPopularStay();
  }

  void onEntityTypeSelected(EntityType type) {
    if (selectedEntityType.value == type) {
      return;
    }
    selectedEntityType.value = type;
    fetchPopularStay(entityType: type);
  }

  Future<void> handleAutoCompleteSelection(HomeAutoCompleteItem item) async {
    searchQuery.value = item.suggestion.valueToDisplay;
    await _navigateWithAutoCompleteItem(item);
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
