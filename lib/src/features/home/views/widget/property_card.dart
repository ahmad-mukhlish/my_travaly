import 'package:flutter/material.dart';

import '../../data/models/property_model.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({super.key, required this.property});

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
                  color: theme.colorScheme.surfaceContainerHighest,
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
