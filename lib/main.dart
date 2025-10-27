import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'src/features/login/bindings/login_binding.dart';
import 'src/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
