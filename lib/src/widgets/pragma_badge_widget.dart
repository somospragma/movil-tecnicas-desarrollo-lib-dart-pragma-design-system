import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';

/// Píldora informativa que resalta estados o categorías.
class PragmaBadgeWidget extends StatelessWidget {
  const PragmaBadgeWidget({
    required this.label,
    super.key,
    this.tone = PragmaBadgeTone.brand,
    this.brightness = PragmaBadgeBrightness.light,
    this.icon,
    this.dense = false,
    this.semanticLabel,
  });

  /// Texto que describe el estado.
  final String label;

  /// Paleta aplicada al fondo y borde del badge.
  final PragmaBadgeTone tone;

  /// Define si se renderiza sobre fondos claros u oscuros.
  final PragmaBadgeBrightness brightness;

  /// Ícono opcional para reforzar el mensaje.
  final IconData? icon;

  /// Ajusta el padding vertical cuando se requiere compacidad.
  final bool dense;

  /// Etiqueta accesible; si se omite usamos [label].
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _PragmaBadgeStyle style = _PragmaBadgeStyle.resolve(
      scheme: theme.colorScheme,
      tone: tone,
      brightness: brightness,
    );

    final TextStyle textStyle = theme.textTheme.labelMedium?.copyWith(
          fontSize: dense ? 11 : 12,
          fontWeight: FontWeight.w600,
          color: style.foreground,
        ) ??
        TextStyle(
          fontSize: dense ? 11 : 12,
          fontWeight: FontWeight.w600,
          color: style.foreground,
        );

    final List<Widget> children = <Widget>[];
    if (icon != null) {
      children.add(Icon(icon, size: dense ? 14 : 16, color: style.foreground));
      children.add(const SizedBox(width: PragmaSpacing.xxxs));
    }
    children.add(
      Flexible(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        ),
      ),
    );

    return Semantics(
      label: semanticLabel ?? label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: dense ? PragmaSpacing.xs : PragmaSpacing.sm,
          vertical: dense ? PragmaSpacing.xxxs : PragmaSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: style.background,
          border: Border.all(color: style.border),
          borderRadius: BorderRadius.circular(PragmaBorderRadius.full),
          boxShadow: style.shadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}

/// Tonalidad disponible para los badges.
enum PragmaBadgeTone { brand, success, warning, info, neutral }

/// Apariencia de superficie.
enum PragmaBadgeBrightness { light, dark }

class _PragmaBadgeStyle {
  const _PragmaBadgeStyle({
    required this.background,
    required this.border,
    required this.foreground,
    required this.shadow,
  });

  final Color background;
  final Color border;
  final Color foreground;
  final List<BoxShadow>? shadow;

  static _PragmaBadgeStyle resolve({
    required ColorScheme scheme,
    required PragmaBadgeTone tone,
    required PragmaBadgeBrightness brightness,
  }) {
    final _BadgePalette palette = _BadgePalette.fromTone(scheme, tone);
    final bool isDark = brightness == PragmaBadgeBrightness.dark;
    final Color background =
        isDark ? palette.darkBackground : palette.lightBackground;
    final Color border = isDark ? palette.darkBorder : palette.lightBorder;
    final Color foreground =
        isDark ? palette.darkForeground : palette.lightForeground;
    final List<BoxShadow>? shadow = isDark
        ? <BoxShadow>[
            BoxShadow(
              color: palette.darkBackground.withValues(alpha: 0.35),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ]
        : null;

    return _PragmaBadgeStyle(
      background: background,
      border: border,
      foreground: foreground,
      shadow: shadow,
    );
  }
}

class _BadgePalette {
  const _BadgePalette({
    required this.lightBackground,
    required this.lightForeground,
    required this.lightBorder,
    required this.darkBackground,
    required this.darkForeground,
    required this.darkBorder,
  });

  factory _BadgePalette.fromTone(ColorScheme scheme, PragmaBadgeTone tone) {
    switch (tone) {
      case PragmaBadgeTone.success:
        return _BadgePalette(
          lightBackground: scheme.secondaryContainer,
          lightForeground: scheme.onSecondaryContainer,
          lightBorder: scheme.secondary,
          darkBackground: scheme.secondary,
          darkForeground: scheme.onSecondary,
          darkBorder: scheme.secondary,
        );
      case PragmaBadgeTone.warning:
        return _BadgePalette(
          lightBackground: scheme.tertiaryContainer,
          lightForeground: scheme.onTertiaryContainer,
          lightBorder: scheme.tertiary,
          darkBackground: scheme.tertiary,
          darkForeground: scheme.onTertiary,
          darkBorder: scheme.tertiary,
        );
      case PragmaBadgeTone.info:
        return _BadgePalette(
          lightBackground: scheme.surfaceContainerHighest,
          lightForeground: scheme.primary,
          lightBorder: scheme.primary,
          darkBackground: scheme.primary,
          darkForeground: Colors.white,
          darkBorder: scheme.primary,
        );
      case PragmaBadgeTone.neutral:
        return _BadgePalette(
          lightBackground: scheme.surfaceContainerHighest,
          lightForeground: scheme.onSurfaceVariant,
          lightBorder: scheme.outlineVariant,
          darkBackground: scheme.onSurfaceVariant,
          darkForeground: scheme.surface,
          darkBorder: scheme.onSurfaceVariant,
        );
      case PragmaBadgeTone.brand:
        return _BadgePalette(
          lightBackground: scheme.primaryContainer,
          lightForeground: scheme.onPrimaryContainer,
          lightBorder: scheme.primary,
          darkBackground: scheme.primary,
          darkForeground: scheme.onPrimary,
          darkBorder: scheme.primary,
        );
    }
  }

  final Color lightBackground;
  final Color lightForeground;
  final Color lightBorder;
  final Color darkBackground;
  final Color darkForeground;
  final Color darkBorder;
}
