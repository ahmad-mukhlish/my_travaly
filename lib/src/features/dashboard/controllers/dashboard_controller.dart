import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../login/controllers/login_controller.dart';
import '../../login/model/login_model.dart';
import '../model/dashboard_model.dart';

class DashboardController extends GetxController {
  DashboardController();
  final RxBool isSigningOut = false.obs;

  final LoginController loginController = Get.find<LoginController>();

  final List<TripSummary> upcomingTrips = const [
    TripSummary(
      destination: 'Bali, Indonesia',
      dateRange: 'Dec 12 - Dec 20',
      description: 'Relax on the beach and explore Ubud cultural gems.',
    ),
    TripSummary(
      destination: 'Kyoto, Japan',
      dateRange: 'Jan 5 - Jan 13',
      description: 'Witness the winter illuminations and tea ceremonies.',
    ),
  ];

  LoginUser? get user => loginController.user.value;


  void signOut() async {
    isSigningOut.value = true;
    await loginController.signOut();
    isSigningOut.value = false;
  }
}
