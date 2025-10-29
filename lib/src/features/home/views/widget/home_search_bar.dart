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
        Row(
            children: [
              Expanded(
                child: SearchBar(
                  elevation: WidgetStateProperty.all(0),
                  controller: controller.searchController,
                  hintText: "Search Hotel",
                  leading: const Icon(Icons.search),
                  trailing: [
                    IconButton(
                      onPressed: () => controller.onSearchSubmitted(
                        controller.searchController.text,
                      ),
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                  onChanged: (value) => controller.onSearchChanged(value),
                  onSubmitted: controller.onSearchSubmitted,
                  textInputAction: TextInputAction.search,
                ),
              ),
            ],

        ),
      ],
    );
  }
}
