import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ChoiceChips<T> extends StatelessWidget {
  const ChoiceChips({
    super.key,
    required this.values,
    required this.selected,
    required this.label,
    required this.onSelected,
  });

  final List<T> values;
  final T selected;
  final String Function(T) label;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final pc = context.pc;
    return Row(
      children: [
        for (final v in values)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => onSelected(v),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: v == selected ? pc.chipSelected : pc.chip,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    label(v),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: v == selected
                          ? pc.onChipSelected
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
