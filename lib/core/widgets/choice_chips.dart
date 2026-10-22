import 'package:flutter/material.dart';

import '../theme/palette.dart';

/// Pill chips: the selected one is a saffron gradient.
class ChoiceChips<T> extends StatelessWidget {
  const ChoiceChips({
    super.key,
    required this.values,
    required this.selected,
    required this.label,
    required this.onSelected,
    this.enabled = true,
  });

  final List<T> values;
  final T selected;
  final String Function(T) label;
  final ValueChanged<T> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Row(
        children: [
          for (final v in values)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: enabled ? () => onSelected(v) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      gradient: v == selected
                          ? LinearGradient(colors: p.chipSelected)
                          : null,
                      color: v == selected ? null : p.chip,
                      border: Border.all(
                        color: v == selected
                            ? Colors.transparent
                            : p.chipBorder,
                      ),
                      boxShadow: v == selected
                          ? [
                              BoxShadow(
                                color: p.primary.withValues(alpha: 0.28),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    // Shrinks the label rather than clip it at large font sizes.
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          label(v),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: v == selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: v == selected ? p.onChipSelected : p.text,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
