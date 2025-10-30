import 'package:get/get.dart';
import 'package:my_travaly/src/features/home/data/models/property_model.dart';
import 'package:my_travaly/src/features/home/data/repositories/home_repository.dart';
import 'package:my_travaly/src/features/home/model/auto_complete_category.dart';
import 'package:my_travaly/src/features/home/model/auto_complete_search_type.dart';
import 'package:my_travaly/src/features/home/model/entity_type.dart';
import 'package:my_travaly/src/features/home/model/home_auto_complete_entry.dart';
import 'package:my_travaly/src/features/home/model/property_search_type.dart';
import 'package:my_travaly/src/features/home/model/search_popular_property_params.dart';
import 'package:my_travaly/src/features/login/controllers/login_controller.dart';
import 'package:my_travaly/src/features/login/model/login_model.dart';
import 'package:my_travaly/src/features/search_results/models/search_results_arguments.dart';
import 'package:my_travaly/src/routes/app_routes.dart';

class HomeController extends GetxController {
  HomeController({required HomeRepository repository}) : _repository = repository;

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

    final rawQuery = query ?? searchQuery.value;
    final effectiveQuery = rawQuery.trim();
    searchQuery.value = effectiveQuery;

    final EntityType nextEntityType = entityType ?? selectedEntityType.value;
    if (selectedEntityType.value != nextEntityType) selectedEntityType.value = nextEntityType;

    final PropertySearchType effectiveSearchType = searchTypeOverride ?? selectedSearchType.value;
    if (searchTypeOverride != null && selectedSearchType.value != searchTypeOverride) selectedSearchType.value = searchTypeOverride;

    String searchTypeKey;
    Map<String, dynamic> searchInfo;
    if (searchInfoOverride != null && searchTypeKeyOverride != null) {
      searchTypeKey = searchTypeKeyOverride;
      searchInfo = searchInfoOverride;
    } else {
      final SearchPopularStayParams params = _repository.buildSearchPopularStayParams(effectiveSearchType, effectiveQuery);
      searchTypeKey = params.searchTypeKey;
      searchInfo = params.searchInfo;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final fetched = await _repository.getPopularStays(
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
