import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loginController = controller.loginController;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Obx(() => controller.isSigningOut.value ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ) : IconButton(
            onPressed: controller.signOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          )),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final user = loginController.user.value;
                final initials = user?.displayName.isNotEmpty == true
                    ? user!.displayName.trim().split(' ').map((word) => word[0]).take(2).join()
                    : '?';

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: theme.colorScheme.primary,
                    backgroundImage:
                        user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
                    child: user?.photoUrl == null
                        ? Text(
                            initials.toUpperCase(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : null,
                  ),
                  title: Text(
                    'Hello, ${user?.displayName ?? 'traveler'}',
                    style: theme.textTheme.titleLarge,
                  ),
                  subtitle: Text(user?.email ?? 'Sign in to sync your journeys'),
                );
              }),
              const SizedBox(height: 24),
              Text(
                'Upcoming trips',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: controller.upcomingTrips.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final trip = controller.upcomingTrips[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                                  child: Icon(
                                    Icons.flight_takeoff,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trip.destination,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        trip.dateRange,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              trip.description,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.map_outlined),
                label: const Text('View full itinerary'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
