import 'package:get/get.dart';
import '../../login/controllers/login_controller.dart';
import '../../login/model/login_model.dart';
import '../data/models/property_model.dart';
import '../data/repositories/home_repository.dart';
import '../model/entity_type.dart';
import '../model/property_search_type.dart';
import '../../search_results/models/search_results_arguments.dart';
import 'package:my_travaly/src/routes/app_routes.dart';
import '../model/auto_complete_entry.dart';
import '../model/auto_complete_search_type.dart';

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
      errorMessage.value = 'Visitor token missing. Please sign out and sign in again.';
      properties.clear();
      return;
    }

    final searchInput = (query ?? searchQuery.value).trim();
    final effectiveQuery = searchInput.isEmpty ? '' : searchInput;

    searchQuery.value = effectiveQuery;
    final EntityType nextEntityType = entityType ?? selectedEntityType.value;
    if (selectedEntityType.value != nextEntityType) {
      selectedEntityType.value = nextEntityType;
    }

    final PropertySearchType effectiveSearchType =
        searchTypeOverride ?? selectedSearchType.value;
    if (searchTypeOverride != null &&
        selectedSearchType.value != searchTypeOverride) {
      selectedSearchType.value = searchTypeOverride;
    }

    String searchTypeKey;
    Map<String, dynamic> searchInfo;
    if (searchInfoOverride != null && searchTypeKeyOverride != null) {
      searchTypeKey = searchTypeKeyOverride;
      searchInfo = searchInfoOverride.map((key, value) {
        if (value is String) {
          return MapEntry(key, value.trim());
        }
        return MapEntry(key, value);
      });
    } else {
      final tuple = _buildSearchParams(effectiveSearchType, effectiveQuery);
      searchTypeKey = tuple.$1;
      searchInfo = tuple.$2;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final fetched = await _repository.getProperties(
        visitorToken: visitorToken,
        searchType: searchTypeKey,
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
      return (AutoCompleteSearchType.random.key, const {});
    }

    switch (type) {
      case PropertySearchType.hotelName:
        return (
          AutoCompleteSearchType.random.key,
          {
            'keyword': trimmedQuery,
            'propertyName': trimmedQuery,
          },
        );
      case PropertySearchType.city:
        return (
          AutoCompleteSearchType.city.key,
          {
            'city': trimmedQuery,
          },
        );
      case PropertySearchType.state:
        return (
          AutoCompleteSearchType.state.key,
          {
            'state': trimmedQuery,
          },
        );
      case PropertySearchType.country:
        return (
          AutoCompleteSearchType.country.key,
          {
            'country': trimmedQuery,
          },
        );
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
    // Get.toNamed(
    //   AppRoutes.searchResults,
    //   arguments: SearchResultsArguments(
    //     query: trimmed,
    //     searchType: selectedSearchType.value,
    //   ),
    // );
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
    final suggestion = item.suggestion;
    searchQuery.value = suggestion.valueToDisplay;

    switch (item.category) {
      case AutoCompleteCategory.property:
        final searchArray = suggestion.searchArray;
        final propertyCodes = searchArray?.query ?? const <String>[];
        if (propertyCodes.isEmpty) {
          Get.snackbar(
            'Unavailable',
            'Property details not available for this suggestion.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        final propertyCode = propertyCodes.first;
        final searchType = searchArray?.type ?? 'hotelIdSearch';
        if (selectedSearchType.value != PropertySearchType.hotelName) {
          selectedSearchType.value = PropertySearchType.hotelName;
        }
        Get.toNamed(
          AppRoutes.searchResults,
          arguments: SearchResultsArguments(
            query: propertyCode,
            searchType: selectedSearchType.value,
            customSearchType: searchType,
          ),
        );
        break;
      case AutoCompleteCategory.city:
        final info = <String, dynamic>{
          'city': suggestion.address?.city ?? suggestion.valueToDisplay,
          'state': suggestion.address?.state ?? '',
          'country': suggestion.address?.country ?? '',
        };
        await fetchPopularStay(
          query: suggestion.address?.city ?? suggestion.valueToDisplay,
          searchTypeOverride: PropertySearchType.city,
          searchTypeKeyOverride: AutoCompleteSearchType.city.key,
          searchInfoOverride: info,
        );
        break;
      case AutoCompleteCategory.state:
        final info = <String, dynamic>{
          'state': suggestion.address?.state ?? suggestion.valueToDisplay,
          'country': suggestion.address?.country ?? '',
        };
        await fetchPopularStay(
          query: suggestion.address?.state ?? suggestion.valueToDisplay,
          searchTypeOverride: PropertySearchType.state,
          searchTypeKeyOverride: AutoCompleteSearchType.state.key,
          searchInfoOverride: info,
        );
        break;
      case AutoCompleteCategory.country:
        final info = <String, dynamic>{
          'country': suggestion.address?.country ?? suggestion.valueToDisplay,
        };
        await fetchPopularStay(
          query: suggestion.address?.country ?? suggestion.valueToDisplay,
          searchTypeOverride: PropertySearchType.country,
          searchTypeKeyOverride: AutoCompleteSearchType.country.key,
          searchInfoOverride: info,
        );
        break;
      case AutoCompleteCategory.street:
      case AutoCompleteCategory.other:
        await fetchPopularStay(
          query: suggestion.valueToDisplay,
          searchTypeOverride: PropertySearchType.hotelName,
          searchTypeKeyOverride: AutoCompleteSearchType.random.key,
          searchInfoOverride: {
            'keyword': suggestion.valueToDisplay,
          },
        );
        break;
    }
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
