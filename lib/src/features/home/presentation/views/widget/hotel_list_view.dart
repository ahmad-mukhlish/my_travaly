import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_travaly/src/features/home/controllers/home_controller.dart';
import 'property_card.dart';

class HotelListView extends StatelessWidget {
  const HotelListView({
    super.key,
    required this.controller,
    required this.theme,
  });

  final HomeController controller;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
          onRefresh: () => controller.fetchPopularStay(),
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
        onRefresh: () => controller.fetchPopularStay(),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: properties.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final property = properties[index];
            return PropertyCard(property: property, controller: controller);
          },
        ),
      );
    });
  }
}
