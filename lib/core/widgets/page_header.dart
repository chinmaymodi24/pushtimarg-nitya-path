import 'package:flutter/material.dart';

import '../theme/palette.dart';

/// Back chevron, centred title and optional actions, as in the designs.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.onBack,
    this.actions = const [],
    this.titleStyle,
  });

  final String title;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    // Both sides equally wide so the title stays centred.
    final side = actions.length * 44.0 < 96 ? 96.0 : actions.length * 44.0;
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          SizedBox(
            width: side,
            child: Align(
              alignment: Alignment.centerLeft,
              child: onBack == null
                  ? null
                  : IconButton(
                      onPressed: onBack,
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 22,
                        color: p.heading,
                      ),
                    ),
            ),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                style:
                    titleStyle ??
                    TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: p.heading,
                    ),
              ),
            ),
          ),
          SizedBox(
            width: side,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ),
        ],
      ),
    );
  }
}
