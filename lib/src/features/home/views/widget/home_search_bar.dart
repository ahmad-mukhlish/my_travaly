import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../model/property_search_type.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Obx(() {
          final placeholder = "Search hotels";
          return Row(
            children: [
              Expanded(
                child: SearchBar(
                  elevation: WidgetStateProperty.all(0),
                  controller: controller.searchController,
                  hintText: placeholder,
                  leading: const Icon(Icons.search),
                  trailing: [
                    IconButton(
                      onPressed: () => controller.onSearchSubmitted(
                        controller.searchController.text,
                      ),
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                  onChanged: (value) => controller.searchQuery.value = value,
                  onSubmitted: controller.onSearchSubmitted,
                  textInputAction: TextInputAction.search,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
