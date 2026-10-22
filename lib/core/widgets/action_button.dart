import 'package:flutter/material.dart';

import '../theme/palette.dart';

/// Rounded full-width button. [whatsapp] uses WhatsApp green so people
/// recognise it; otherwise the saffron gradient.
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.whatsapp = false,
    this.height = 48,
  });

  static const whatsappGreen = Color(0xFF1FA855);

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool whatsapp;
  final double height;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final fg = whatsapp ? Colors.white : p.onChipSelected;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(height / 2),
        onTap: onTap,
        child: Ink(
          height: height,
          decoration: BoxDecoration(
            color: whatsapp ? whatsappGreen : null,
            gradient: whatsapp ? null : LinearGradient(colors: p.chipSelected),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 19, color: fg),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
