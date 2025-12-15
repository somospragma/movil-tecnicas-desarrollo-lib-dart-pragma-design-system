import 'package:flutter/material.dart';

import '../tokens/pragma_spacing.dart';

/// Visual styles supported by [PragmaIconButtonWidget].
enum PragmaIconButtonStyle {
  filledLight,
  outlinedLight,
  filledDark,
  outlinedDark,
}

/// Available touch targets for [PragmaIconButtonWidget].
enum PragmaIconButtonSize {
  regular,
  compact,
}

/// Icon button aligned with the Pragma spec, including filled/outlined
/// variants for light or dark surfaces plus hover/pressed states.
class PragmaIconButtonWidget extends StatelessWidget {
  const PragmaIconButtonWidget({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
    this.style = PragmaIconButtonStyle.filledLight,
    this.size = PragmaIconButtonSize.regular,
    this.enableFeedback = true,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final PragmaIconButtonStyle style;
  final PragmaIconButtonSize size;
  final bool enableFeedback;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final _PragmaIconButtonPalette palette =
        _PragmaIconButtonPalette.resolve(colorScheme, style);
    final _PragmaIconButtonMetrics metrics =
        _PragmaIconButtonMetrics.resolve(size);

    final ButtonStyle buttonStyle = ButtonStyle(
      fixedSize: WidgetStatePropertyAll<Size>(
        Size.square(metrics.dimension),
      ),
      padding:
          const WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(CircleBorder()),
      overlayColor: WidgetStatePropertyAll<Color?>(
        palette.overlayColor ?? Colors.transparent,
      ),
      backgroundColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return palette.disabledBackground;
        }
        if (states.contains(WidgetState.pressed)) {
          return palette.pressedBackground;
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return palette.hoverBackground;
        }
        return palette.background;
      }),
      foregroundColor:
          WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return palette.disabledForeground;
        }
        return palette.foreground;
      }),
      side: WidgetStateProperty.resolveWith<BorderSide?>(
          (Set<WidgetState> states) {
        final Color? color = states.contains(WidgetState.disabled)
            ? palette.disabledBorderColor
            : palette.borderColor;
        if (color == null) {
          return null;
        }
        return BorderSide(color: color, width: palette.borderWidth);
      }),
    );

    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      enableFeedback: enableFeedback,
      splashRadius: metrics.splashRadius,
      icon: Icon(icon, size: metrics.iconSize),
      style: buttonStyle,
    );
  }
}

class _PragmaIconButtonMetrics {
  const _PragmaIconButtonMetrics({
    required this.dimension,
    required this.iconSize,
    required this.splashRadius,
  });

  final double dimension;
  final double iconSize;
  final double splashRadius;

  static _PragmaIconButtonMetrics resolve(PragmaIconButtonSize size) {
    switch (size) {
      case PragmaIconButtonSize.regular:
        return const _PragmaIconButtonMetrics(
          dimension: PragmaSpacing.xxl,
          iconSize: 24,
          splashRadius: 28,
        );
      case PragmaIconButtonSize.compact:
        return const _PragmaIconButtonMetrics(
          dimension: PragmaSpacing.xl,
          iconSize: 20,
          splashRadius: 24,
        );
    }
  }
}

class _PragmaIconButtonPalette {
  const _PragmaIconButtonPalette({
    required this.background,
    required this.hoverBackground,
    required this.pressedBackground,
    required this.foreground,
    required this.disabledBackground,
    required this.disabledForeground,
    this.borderColor,
    this.disabledBorderColor,
    this.overlayColor,
    this.borderWidth = 1.5,
  });

  final Color background;
  final Color hoverBackground;
  final Color pressedBackground;
  final Color foreground;
  final Color disabledBackground;
  final Color disabledForeground;
  final Color? borderColor;
  final Color? disabledBorderColor;
  final Color? overlayColor;
  final double borderWidth;

  static _PragmaIconButtonPalette resolve(
    ColorScheme scheme,
    PragmaIconButtonStyle style,
  ) {
    switch (style) {
      case PragmaIconButtonStyle.filledLight:
        return _filledPalette(
          scheme: scheme,
          background: scheme.primary,
          foreground: scheme.onPrimary,
        );
      case PragmaIconButtonStyle.outlinedLight:
        return _outlinedPalette(
          scheme: scheme,
          background: scheme.surface,
          foreground: scheme.primary,
          border: scheme.outline,
          disabledBorder: scheme.outlineVariant,
        );
      case PragmaIconButtonStyle.filledDark:
        return _filledPalette(
          scheme: scheme,
          background: scheme.onPrimary,
          foreground: scheme.primary,
        );
      case PragmaIconButtonStyle.outlinedDark:
        return _outlinedPalette(
          scheme: scheme,
          background: Colors.transparent,
          foreground: scheme.onPrimary,
          border: scheme.onPrimary,
          disabledBorder: scheme.onSurfaceVariant.withValues(alpha: 0.4),
        );
    }
  }

  static _PragmaIconButtonPalette _filledPalette({
    required ColorScheme scheme,
    required Color background,
    required Color foreground,
  }) {
    return _PragmaIconButtonPalette(
      background: background,
      hoverBackground: _layer(background, foreground, 0.12),
      pressedBackground: _layer(background, foreground, 0.24),
      foreground: foreground,
      disabledBackground: scheme.onSurface.withValues(alpha: 0.12),
      disabledForeground: scheme.onSurface.withValues(alpha: 0.38),
      overlayColor: foreground.withValues(alpha: 0.08),
      borderWidth: 0,
    );
  }

  static _PragmaIconButtonPalette _outlinedPalette({
    required ColorScheme scheme,
    required Color background,
    required Color foreground,
    required Color border,
    required Color disabledBorder,
  }) {
    return _PragmaIconButtonPalette(
      background: background,
      hoverBackground: _layer(background, foreground, 0.12),
      pressedBackground: _layer(background, foreground, 0.2),
      foreground: foreground,
      disabledBackground: scheme.onSurface.withValues(alpha: 0.04),
      disabledForeground: scheme.onSurface.withValues(alpha: 0.38),
      borderColor: border,
      disabledBorderColor: disabledBorder,
      overlayColor: foreground.withValues(alpha: 0.08),
    );
  }
}

Color _layer(Color base, Color overlay, double opacity) {
  return Color.alphaBlend(overlay.withValues(alpha: opacity), base);
}
