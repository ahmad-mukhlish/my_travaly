import 'package:flutter/material.dart';

class FilterCounterSelector extends StatelessWidget {
  const FilterCounterSelector({
    super.key,
    required this.label,
    required this.value,
    required this.minValue,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int minValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayValue = value < minValue ? minValue : value;
    final canDecrement = displayValue > minValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: canDecrement ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove),
              ),
              Text(displayValue.toString(), style: theme.textTheme.titleMedium),
              IconButton(
                onPressed: () => onChanged(value + 1),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
