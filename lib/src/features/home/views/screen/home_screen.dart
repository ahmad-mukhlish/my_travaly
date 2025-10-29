import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../widget/home_search_bar.dart';
import '../widget/hotel_list_view.dart';
import '../widget/user_view.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHomeLayout(context),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.selectedTabIndex.value,
        onTap: controller.changeTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            label: 'Hotels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeLayout(BuildContext context) {
    return Obx(() {
      final index = controller.selectedTabIndex.value;
      if (index == 1) {
        return _buildAccountTab(context);
      }
      return _buildHotelsTab(context);
    });
  }

  Widget _buildHotelsTab(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            HomeSearchBar(controller: controller),
            const SizedBox(height: 16),
            Expanded(
              child: HotelListView(controller: controller, theme: theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTab(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Obx(() => UserView(user: controller.user)),
            const SizedBox(height: 24),
            Obx(() {
              final isSigningOut = controller.isSigningOut.value;
              return ElevatedButton.icon(
                onPressed: isSigningOut ? null : controller.signOut,
                icon: isSigningOut
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout),
                label: Text(isSigningOut ? 'Signing out...' : 'Sign out'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
