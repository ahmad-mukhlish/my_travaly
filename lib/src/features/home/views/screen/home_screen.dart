import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../data/models/property_model.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Obx(
            () => controller.isSigningOut.value
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    onPressed: controller.signOut,
                    icon: const Icon(Icons.logout),
                    tooltip: 'Sign out',
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final user = controller.user;
                final initials = user?.displayName.isNotEmpty == true
                    ? user!.displayName
                        .trim()
                        .split(' ')
                        .map((word) => word[0])
                        .take(2)
                        .join()
                    : '?';
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: theme.colorScheme.primary,
                    backgroundImage: user?.photoUrl != null
                        ? NetworkImage(user!.photoUrl!)
                        : null,
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
                    'Welcome back, ${user?.displayName ?? 'traveler'}',
                    style: theme.textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    user?.email ?? 'Sign in to explore curated stays.',
                  ),
                );
              }),
              const SizedBox(height: 16),
              _SearchBar(controller: controller),
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
                        return _PropertyCard(property: property);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find your next stay',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final placeholder =
              _placeholderFor(controller.selectedSearchType.value);
          return Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.searchTextController,
                  onChanged: (value) => controller.searchQuery.value = value,
                  onSubmitted: controller.onSearchSubmitted,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () => controller.onSearchSubmitted(
                        controller.searchTextController.text,
                      ),
                      icon: const Icon(Icons.arrow_forward),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<PropertySearchType>(
                value: controller.selectedSearchType.value,
                onChanged: (type) {
                  if (type != null) {
                    controller.onSearchTypeChanged(type);
                  }
                },
                items: PropertySearchType.values
                    .map(
                      (type) => DropdownMenuItem<PropertySearchType>(
                        value: type,
                        child: Text(_labelFor(type)),
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        }),
      ],
    );
  }

  static String _labelFor(PropertySearchType type) {
    switch (type) {
      case PropertySearchType.hotelName:
        return 'Hotel';
      case PropertySearchType.city:
        return 'City';
      case PropertySearchType.state:
        return 'State';
      case PropertySearchType.country:
        return 'Country';
    }
  }

  static String _placeholderFor(PropertySearchType type) {
    switch (type) {
      case PropertySearchType.hotelName:
        return 'Search by hotel name';
      case PropertySearchType.city:
        return 'Search by city';
      case PropertySearchType.state:
        return 'Search by state';
      case PropertySearchType.country:
        return 'Search by country';
    }
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (property.propertyImage.isNotEmpty)
            SizedBox(
              height: 160,
              width: double.infinity,
              child: Image.network(
                property.propertyImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: theme.colorScheme.surfaceVariant,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined, size: 48),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.propertyName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${property.city}, ${property.state.isNotEmpty ? '${property.state}, ' : ''}${property.country}',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: theme.colorScheme.secondary,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      property.rating > 0
                          ? property.rating.toStringAsFixed(1)
                          : 'NR',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${property.totalReviews} reviews)',
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      property.priceDisplayAmount.isNotEmpty
                          ? property.priceDisplayAmount
                          : '--',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  property.propertyType.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                    letterSpacing: 0.6,
                  ),
                ),
                if (property.street.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    property.street,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
