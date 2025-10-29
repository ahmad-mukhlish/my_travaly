import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../widget/home_search_bar.dart';
import '../widget/property_card.dart';
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
              child: Obx(() {
                final error = controller.errorMessage.value;
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (error.isNotEmpty) {
                  return Center(
                    child: Text(
                      error,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                final properties = controller.properties;
                if (properties.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => controller.fetchProperties(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Center(
                            child: Text(
                              'No properties found. Try a different search.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => controller.fetchProperties(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: properties.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final property = properties[index];
                      return PropertyCard(property: property);
                    },
                  ),
                );
              }),
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

class _buildHomeBar extends StatelessWidget {
  const _buildHomeBar({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
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
}
