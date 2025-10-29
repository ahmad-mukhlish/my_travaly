import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../model/property_search_type.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, required this.controller});

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
              controller.selectedSearchType.value.placeholder;
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
                        child: Text(type.label),
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
}
