import 'package:flutter/material.dart';

import '../tokens/pragma_spacing.dart';

enum PragmaIconButtonVariant { solid, tonal, ghost }

/// Legacy icon button. Prefer using [PragmaIconButtonWidget].
@Deprecated('Use PragmaIconButtonWidget instead. Will be removed in 0.2.0.')
class PragmaIconButton extends StatelessWidget {
  @Deprecated('Use PragmaIconButtonWidget instead. Will be removed in 0.2.0.')
  const PragmaIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
    this.variant = PragmaIconButtonVariant.solid,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final PragmaIconButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final _PragmaIconPalette palette = _paletteForVariant(colorScheme);

    return Material(
      color: palette.background,
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        color: palette.foreground,
        iconSize: 22,
        padding: PragmaSpacing.insetAll(PragmaSpacing.sm),
        icon: Icon(icon),
        splashRadius: 24,
      ),
    );
  }

  _PragmaIconPalette _paletteForVariant(ColorScheme scheme) {
    switch (variant) {
      case PragmaIconButtonVariant.tonal:
        return _PragmaIconPalette(
          background: scheme.secondaryContainer,
          foreground: scheme.onSecondaryContainer,
        );
      case PragmaIconButtonVariant.ghost:
        return _PragmaIconPalette(
          background: Colors.transparent,
          foreground: scheme.onSurfaceVariant,
        );
      case PragmaIconButtonVariant.solid:
        return _PragmaIconPalette(
          background: scheme.primary,
          foreground: scheme.onPrimary,
        );
    }
  }
}

class _PragmaIconPalette {
  const _PragmaIconPalette({
    required this.background,
    required this.foreground,
  });
  final Color background;
  final Color foreground;
}
