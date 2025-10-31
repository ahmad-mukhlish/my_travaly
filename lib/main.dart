import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_travaly/firebase_options.dart';
import 'package:my_travaly/src/services/auth/auth_storage_service.dart';
import 'package:my_travaly/src/services/network/api_service.dart';

import 'src/features/login/bindings/login_binding.dart';
import 'src/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Get.putAsync<AuthStorageService>(
    () => AuthStorageService().init(),
    permanent: true,
  );

  await Get.putAsync<ApiService>(
    () => ApiService().init(),
    permanent: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My Travaly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialBinding: LoginBinding(),
      initialRoute: AuthStorageService.to.initialPage,
      getPages: AppPages.routes,
    );
  }
}
