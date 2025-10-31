import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/lifecycle.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_travaly/src/enums/entity_type.dart';
import 'package:my_travaly/src/features/home/controllers/home_controller.dart';
import 'package:my_travaly/src/features/home/controllers/home_search_bar_controller.dart';
import 'package:my_travaly/src/features/home/data/models/property_model.dart';
import 'package:my_travaly/src/features/home/presentation/views/screen/home_screen.dart';
import 'package:my_travaly/src/features/home/presentation/views/widget/home_search_bar.dart';
import 'package:my_travaly/src/features/home/presentation/views/widget/hotel_list_view.dart';
import 'package:my_travaly/src/features/login/presentation/models/login_model.dart';

class MockHomeController extends Mock implements HomeController {}

class MockHomeSearchBarController extends Mock
    implements HomeSearchBarController {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(EntityType.any);
  });

  late MockHomeController homeController;
  late MockHomeSearchBarController searchBarController;
  late RxInt selectedTabIndex;
  late Rx<EntityType> selectedEntityType;
  late RxBool isSigningOut;
  late RxBool isLoading;
  late RxString errorMessage;
  late RxList<Property> properties;
  late SearchController searchController;
  late RxString autoCompleteError;
  late RxBool autoCompleteLoading;
  LoginUser? currentUser;

  setUp(() {
    Get.reset();
    Get.testMode = true;

    homeController = MockHomeController();
    searchBarController = MockHomeSearchBarController();
    selectedTabIndex = 0.obs;
    selectedEntityType = EntityType.any.obs;
    isSigningOut = false.obs;
    isLoading = false.obs;
    errorMessage = ''.obs;
    properties = <Property>[].obs;
    searchController = SearchController();
    autoCompleteError = ''.obs;
    autoCompleteLoading = false.obs;
    currentUser = null;

    when(() => homeController.selectedTabIndex)
        .thenReturn(selectedTabIndex);
    when(() => homeController.selectedEntityType)
        .thenReturn(selectedEntityType);
    when(() => homeController.isSigningOut).thenReturn(isSigningOut);
    when(() => homeController.isLoading).thenReturn(isLoading);
    when(() => homeController.errorMessage).thenReturn(errorMessage);
    when(() => homeController.properties).thenReturn(properties);
    when(() => homeController.user).thenAnswer((_) => currentUser);

    when(() => homeController.changeTab(any())).thenAnswer((invocation) {
      selectedTabIndex.value = invocation.positionalArguments.first as int;
    });
    when(() => homeController.onEntityTypeSelected(any()))
        .thenAnswer((invocation) {
      selectedEntityType.value =
          invocation.positionalArguments.first as EntityType;
    });
    when(() => homeController.onStart)
        .thenReturn(InternalFinalCallback<void>());
    when(() => homeController.onDelete)
        .thenReturn(InternalFinalCallback<void>());
    when(() => homeController.fetchPopularStay())
        .thenAnswer((_) async {});
    when(() => homeController.fetchPopularStay(
        entityType: any(named: 'entityType'))).thenAnswer((_) async {});
    when(() => homeController.signOut()).thenAnswer((_) {});

    when(() => searchBarController.searchController)
        .thenReturn(searchController);
    when(() => searchBarController.searchAutoComplete(any()))
        .thenAnswer((_) async => const []);
    when(() => searchBarController.autoCompleteError)
        .thenReturn(autoCompleteError);
    when(() => searchBarController.isAutoCompleteLoading)
        .thenReturn(autoCompleteLoading);

    addTearDown(() {
      searchController.dispose();
      Get.reset();
    });
  });

  Future<void> pumpHomeScreen(WidgetTester tester) async {
    Get.put<HomeController>(homeController);
    Get.put<HomeSearchBarController>(searchBarController);

    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomeScreen(),
      ),
    );
    await tester.pump();
  }

  testWidgets(
    'renders hotels tab content by default',
    (tester) async {
      await pumpHomeScreen(tester);

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Hotels'), findsWidgets);
      expect(find.byType(HomeSearchBar), findsOneWidget);
      expect(find.byType(HotelListView), findsOneWidget);

      final chips = tester.widgetList<ChoiceChip>(find.byType(ChoiceChip));
      expect(chips.length, EntityType.values.length);
      expect(find.text('All'), findsOneWidget);
    },
  );

  testWidgets(
    'selecting an entity type chip updates the selection',
    (tester) async {
      await pumpHomeScreen(tester);

      await tester.tap(find.text('Resorts'));
      await tester.pump();

      verify(() => homeController.onEntityTypeSelected(EntityType.resort))
          .called(1);
      expect(selectedEntityType.value, EntityType.resort);
    },
  );

  testWidgets(
    'switching to account tab shows user details and triggers sign-out',
    (tester) async {
      currentUser = const LoginUser(
        id: '1',
        displayName: 'Test User',
        email: 'test@example.com',
        visitorToken: 'token',
      );

      await pumpHomeScreen(tester);

      await tester.tap(find.text('Account'));
      await tester.pump();

      expect(selectedTabIndex.value, 1);
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('Sign out'), findsOneWidget);

      await tester.tap(find.text('Sign out'));
      verify(() => homeController.signOut()).called(1);
    },
  );
}
