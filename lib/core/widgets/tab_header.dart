import 'package:flutter/material.dart';

import '../theme/palette.dart';

/// Header for a bottom-nav tab: large left-aligned title, no back arrow.
class TabHeader extends StatelessWidget {
  const TabHeader({super.key, required this.title, this.action});
  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 16, 10),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: p.text,
                ),
              ),
            ),
            ?action,
          ],
        ),
      ),
    );
  }
}

/// Small rounded-square icon button used in tab headers.
class HeaderButton extends StatelessWidget {
  const HeaderButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: p.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: p.cardBorder),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: SizedBox.square(
            dimension: 40,
            child: Icon(icon, size: 21, color: p.heading),
          ),
        ),
      ),
    );
  }
}
