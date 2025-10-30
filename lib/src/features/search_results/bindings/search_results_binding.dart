import 'package:get/get.dart';
import 'package:my_travaly/src/features/home/model/property_search_type.dart';
import 'package:my_travaly/src/features/search_results/controllers/search_results_controller.dart';
import 'package:my_travaly/src/features/search_results/data/datasources/search_results_remote_data_source.dart';
import 'package:my_travaly/src/features/search_results/data/repositories/search_results_repository.dart';
import 'package:my_travaly/src/features/search_results/models/search_results_arguments.dart';
import 'package:my_travaly/src/services/network/api_service.dart';

class SearchResultsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SearchResultsRemoteDataSource>()) {
      Get.lazyPut<SearchResultsRemoteDataSource>(
        () => SearchResultsRemoteDataSource(apiService: Get.find<ApiService>()),
      );
    }

    if (!Get.isRegistered<SearchResultsRepository>()) {
      Get.lazyPut<SearchResultsRepository>(
        () => SearchResultsRepository(
          remoteDataSource: Get.find<SearchResultsRemoteDataSource>(),
        ),
      );
    }

    final dynamic rawArgs = Get.arguments;
    final SearchResultsArguments resolvedArgs =
        rawArgs is SearchResultsArguments
            ? rawArgs
            : const SearchResultsArguments(
                query: '',
                searchType: PropertySearchType.city,
              );

    if (Get.isRegistered<SearchResultsController>()) {
      Get.delete<SearchResultsController>();
    }

    Get.put<SearchResultsController>(
      SearchResultsController(
        repository: Get.find<SearchResultsRepository>(),
        arguments: resolvedArgs,
      ),
    );
  }
}
