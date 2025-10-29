import 'package:get/get.dart';

import '../../home/models/property_search_type.dart';
import '../controllers/search_results_controller.dart';
import '../data/datasources/search_results_remote_data_source.dart';
import '../data/repositories/search_results_repository.dart';
import '../models/search_results_arguments.dart';

class SearchResultsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SearchResultsRemoteDataSource>()) {
      Get.lazyPut<SearchResultsRemoteDataSource>(
        () => SearchResultsRemoteDataSource(),
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
