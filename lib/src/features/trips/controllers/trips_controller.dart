import 'package:get/get.dart';

import '../../login/controllers/login_controller.dart';
import '../../login/model/login_model.dart';
import '../model/trip_model.dart';

class TripsController extends GetxController {
  TripsController();

  final LoginController loginController = Get.find<LoginController>();

  final List<TripPlan> upcomingPlans = const [
    TripPlan(
      title: 'Island Adventure',
      location: 'Phuket, Thailand',
      dateRange: 'Jan 22 - Jan 27',
      status: 'Confirmed',
      highlights: [
        'Stay at beachside resort',
        'Phi Phi Islands speedboat tour',
        'Thai cooking class',
      ],
    ),
    TripPlan(
      title: 'Cultural Escape',
      location: 'Florence, Italy',
      dateRange: 'Mar 05 - Mar 12',
      status: 'Draft',
      highlights: [
        'Visit Uffizi Gallery',
        'Private pasta workshop',
        'Day trip to Cinque Terre',
      ],
    ),
  ];

  LoginUser? get user => loginController.user.value;
}
