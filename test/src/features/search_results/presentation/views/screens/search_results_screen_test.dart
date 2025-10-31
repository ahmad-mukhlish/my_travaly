import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/lifecycle.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_travaly/src/enums/property_search_type.dart';
import 'package:my_travaly/src/features/search_results/controllers/search_results_controller.dart';
import 'package:my_travaly/src/features/search_results/data/models/search_result_model.dart';
import 'package:my_travaly/src/features/search_results/presentation/views/screens/search_results_screen.dart';

class MockSearchResultsController extends Mock
    implements SearchResultsController {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeBuildContext());
  });

  late MockSearchResultsController controller;
  late PagingController<int, SearchResult> pagingController;

  setUp(() {
    Get.reset();
    Get.testMode = true;

    controller = MockSearchResultsController();
    pagingController = PagingController<int, SearchResult>(
      getNextPageKey: (_) => null,
      fetchPage: (_) async => const [],
    );

    when(() => controller.searchType).thenReturn(PropertySearchType.city);
    when(() => controller.title).thenReturn('Paris');
    when(() => controller.pagingController).thenReturn(pagingController);
    when(() => controller.refreshResults()).thenAnswer((_) async {});
    when(() => controller.showFiltersDialog(any()))
        .thenAnswer((_) async {});
    when(() => controller.onStart)
        .thenReturn(InternalFinalCallback<void>(callback: () {}));
    when(() => controller.onDelete)
        .thenReturn(InternalFinalCallback<void>(callback: () {}));

    addTearDown(() {
      pagingController.dispose();
      Get.reset();
    });
  });

  Future<void> pumpSearchResultsScreen(WidgetTester tester) async {
    Get.put<SearchResultsController>(controller);
    await tester.pumpWidget(
      const GetMaterialApp(
        home: SearchResultsScreen(),
      ),
    );
    await tester.pump();
  }

  testWidgets(
    'renders header information and triggers filter dialog',
    (tester) async {
      pagingController.value = PagingState<int, SearchResult>(
        pages: const [<SearchResult>[]],
        keys: const [0],
        hasNextPage: false,
        isLoading: false,
      );

      await pumpSearchResultsScreen(tester);

      expect(find.text('Search Result Page'), findsOneWidget);
      expect(find.text('Searching by city'), findsOneWidget);
      expect(find.text('Paris'), findsOneWidget);
      expect(find.text('Filter Results'), findsOneWidget);

      await tester.tap(find.text('Filter Results'));
      await tester.pump();

      verify(() => controller.showFiltersDialog(any())).called(1);
    },
  );

  testWidgets(
    'shows no results indicator when list is empty',
    (tester) async {
      pagingController.value = PagingState<int, SearchResult>(
        pages: const [<SearchResult>[]],
        keys: const [0],
        hasNextPage: false,
        isLoading: false,
      );

      await pumpSearchResultsScreen(tester);

      expect(
        find.textContaining('No properties found for "Paris"'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'displays search result cards when items are available',
    (tester) async {
      const result = SearchResult(
        propertyCode: 'P1',
        propertyName: 'Test Hotel',
        propertyType: 'Hotel',
        propertyStar: 4,
        city: 'Paris',
        state: 'Ile-de-France',
        country: 'France',
        street: '',
        imageUrl: '',
        priceDisplayAmount: 'USD 120',
        currencySymbol: '\$',
        rating: 4.5,
        totalReviews: 120,
        propertyUrl: '',
      );

      pagingController.value = PagingState<int, SearchResult>(
        pages: const [
          <SearchResult>[result],
        ],
        keys: const [0],
        hasNextPage: false,
        isLoading: false,
      );

      await pumpSearchResultsScreen(tester);

      expect(find.text('Test Hotel'), findsOneWidget);
      expect(find.text('HOTEL'), findsOneWidget);
      expect(find.text('USD 120'), findsOneWidget);
    },
  );
}
