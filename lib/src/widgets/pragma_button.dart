import 'package:flutter/material.dart';

import '../tokens/pragma_spacing.dart';

enum PragmaButtonHierarchy { primary, secondary, tertiary }

enum PragmaButtonTone { brand, inverse }

enum PragmaButtonSize { medium, small }

/// Botón estilizado según las guías de Pragma.
class PragmaButton extends StatelessWidget {
  const PragmaButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.leading,
    this.trailing,
    this.hierarchy = PragmaButtonHierarchy.primary,
    this.tone = PragmaButtonTone.brand,
    this.size = PragmaButtonSize.medium,
    this.expand = false,
  });

  factory PragmaButton.icon({
    required String label,
    required VoidCallback? onPressed,
    required IconData icon,
    Key? key,
    Widget? trailing,
    PragmaButtonHierarchy hierarchy = PragmaButtonHierarchy.primary,
    PragmaButtonTone tone = PragmaButtonTone.brand,
    PragmaButtonSize size = PragmaButtonSize.medium,
    bool expand = false,
  }) {
    return PragmaButton(
      key: key,
      label: label,
      onPressed: onPressed,
      hierarchy: hierarchy,
      tone: tone,
      size: size,
      expand: expand,
      leading: Icon(icon),
      trailing: trailing,
    );
  }

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final PragmaButtonHierarchy hierarchy;
  final PragmaButtonTone tone;
  final PragmaButtonSize size;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final PragmaButtonColors colors =
        PragmaButtonColors.resolve(colorScheme, hierarchy, tone);
    final EdgeInsetsGeometry padding = _PragmaButtonMetrics.padding(size);
    final double minHeight = _PragmaButtonMetrics.minHeight(size);
    final TextStyle textStyle = _PragmaButtonMetrics.textStyle(
      theme.textTheme,
      size,
    );

    final ButtonStyle style = PragmaButtonStyles.build(
      colors: colors,
      padding: padding,
      minHeight: minHeight,
      textStyle: textStyle,
    );

    Widget button = TextButton(
      onPressed: onPressed,
      style: style,
      child: _PragmaButtonChild(
        label: label,
        leading: leading,
        trailing: trailing,
        expand: expand,
        size: size,
      ),
    );

    if (expand) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}

class PragmaPrimaryButton extends PragmaButton {
  const PragmaPrimaryButton({
    required super.label,
    required super.onPressed,
    super.key,
    super.leading,
    super.trailing,
    super.tone,
    super.size,
    super.expand,
  }) : super(hierarchy: PragmaButtonHierarchy.primary);
}

class PragmaSecondaryButton extends PragmaButton {
  const PragmaSecondaryButton({
    required super.label,
    required super.onPressed,
    super.key,
    super.leading,
    super.trailing,
    super.tone,
    super.size,
    super.expand,
  }) : super(hierarchy: PragmaButtonHierarchy.secondary);
}

class PragmaTertiaryButton extends PragmaButton {
  const PragmaTertiaryButton({
    required super.label,
    required super.onPressed,
    super.key,
    super.leading,
    super.trailing,
    super.tone,
    super.size,
    super.expand,
  }) : super(hierarchy: PragmaButtonHierarchy.tertiary);
}

class _PragmaButtonChild extends StatelessWidget {
  const _PragmaButtonChild({
    required this.label,
    required this.size,
    this.leading,
    this.trailing,
    this.expand = false,
  });

  final String label;
  final PragmaButtonSize size;
  final Widget? leading;
  final Widget? trailing;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    final double iconSize = _PragmaButtonMetrics.iconSize(size);

    if (leading != null) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(right: PragmaSpacing.xs),
          child: IconTheme.merge(
            data: IconThemeData(size: iconSize),
            child: leading!,
          ),
        ),
      );
    }

    children.add(
      Flexible(
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    if (trailing != null) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(left: PragmaSpacing.xs),
          child: IconTheme.merge(
            data: IconThemeData(size: iconSize),
            child: trailing!,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

/// Utilidades de estilos para integrar con los temas de Flutter.
class PragmaButtonStyles {
  const PragmaButtonStyles._();

  static ButtonStyle build({
    required PragmaButtonColors colors,
    required EdgeInsetsGeometry padding,
    required double minHeight,
    required TextStyle textStyle,
  }) {
    final RoundedRectangleBorder shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
    final MaterialTapTargetSize tapTargetSize = minHeight < PragmaSpacing.xxl
        ? MaterialTapTargetSize.shrinkWrap
        : MaterialTapTargetSize.padded;

    TextStyle resolveTextStyle(Set<WidgetState> states) {
      final bool disabled = states.contains(WidgetState.disabled);
      return textStyle.copyWith(
        color: disabled ? colors.disabledForeground : colors.enabledForeground,
      );
    }

    return ButtonStyle(
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(padding),
      minimumSize: WidgetStatePropertyAll<Size>(Size(0, minHeight)),
      shape: WidgetStatePropertyAll<OutlinedBorder>(shape),
      textStyle: WidgetStateProperty.resolveWith<TextStyle>(resolveTextStyle),
      backgroundColor:
          WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.disabledBackground;
        }
        return colors.enabledBackground;
      }),
      foregroundColor:
          WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.disabledForeground;
        }
        return colors.enabledForeground;
      }),
      overlayColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.transparent;
        }
        if (states.contains(WidgetState.pressed)) {
          return colors.pressedOverlay;
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return colors.hoverOverlay;
        }
        return null;
      }),
      side: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        final Color? borderColor = states.contains(WidgetState.disabled)
            ? colors.disabledBorderColor ?? colors.borderColor
            : colors.borderColor;
        if (borderColor == null) {
          return null;
        }
        return BorderSide(color: borderColor, width: 1.5);
      }),
      tapTargetSize: tapTargetSize,
    );
  }
}

class _PragmaButtonMetrics {
  const _PragmaButtonMetrics._();

  static EdgeInsetsGeometry padding(PragmaButtonSize size) {
    switch (size) {
      case PragmaButtonSize.medium:
        return PragmaSpacing.insetSymmetric(
          horizontal: PragmaSpacing.lg,
          vertical: PragmaSpacing.sm,
        );
      case PragmaButtonSize.small:
        return PragmaSpacing.insetSymmetric(
          horizontal: PragmaSpacing.md,
          vertical: PragmaSpacing.xs,
        );
    }
  }

  static double minHeight(PragmaButtonSize size) {
    switch (size) {
      case PragmaButtonSize.medium:
        return PragmaSpacing.xxl; // 48px
      case PragmaButtonSize.small:
        return PragmaSpacing.xl; // 40px
    }
  }

  static double iconSize(PragmaButtonSize size) {
    switch (size) {
      case PragmaButtonSize.medium:
        return 20;
      case PragmaButtonSize.small:
        return 18;
    }
  }

  static TextStyle textStyle(TextTheme textTheme, PragmaButtonSize size) {
    final TextStyle base = size == PragmaButtonSize.medium
        ? textTheme.labelLarge ?? const TextStyle(fontSize: 16)
        : textTheme.labelMedium ?? const TextStyle(fontSize: 14);
    return base.copyWith(fontWeight: FontWeight.w600);
  }
}

class PragmaButtonColors {
  const PragmaButtonColors({
    required this.enabledBackground,
    required this.enabledForeground,
    required this.disabledBackground,
    required this.disabledForeground,
    required this.hoverOverlay,
    required this.pressedOverlay,
    this.borderColor,
    this.disabledBorderColor,
  });

  final Color enabledBackground;
  final Color enabledForeground;
  final Color disabledBackground;
  final Color disabledForeground;
  final Color hoverOverlay;
  final Color pressedOverlay;
  final Color? borderColor;
  final Color? disabledBorderColor;

  static PragmaButtonColors resolve(
    ColorScheme scheme,
    PragmaButtonHierarchy hierarchy,
    PragmaButtonTone tone,
  ) {
    switch (hierarchy) {
      case PragmaButtonHierarchy.primary:
        return _opaquePalette(
          background: tone == PragmaButtonTone.brand
              ? scheme.primary
              : scheme.onPrimary,
          foreground: tone == PragmaButtonTone.brand
              ? scheme.onPrimary
              : scheme.primary,
          scheme: scheme,
        );
      case PragmaButtonHierarchy.secondary:
        if (tone == PragmaButtonTone.brand) {
          return _opaquePalette(
            background: scheme.secondaryContainer,
            foreground: scheme.onSecondaryContainer,
            scheme: scheme,
          );
        }
        return _outlinedPalette(
          background: scheme.surface,
          foreground: scheme.onSurface,
          border: scheme.outlineVariant,
          scheme: scheme,
        );
      case PragmaButtonHierarchy.tertiary:
        return _textPalette(
          foreground: tone == PragmaButtonTone.brand
              ? scheme.primary
              : scheme.onPrimary,
          scheme: scheme,
        );
    }
  }

  static PragmaButtonColors _opaquePalette({
    required Color background,
    required Color foreground,
    required ColorScheme scheme,
  }) {
    return PragmaButtonColors(
      enabledBackground: background,
      enabledForeground: foreground,
      disabledBackground: scheme.onSurface.withValues(alpha: 0.12),
      disabledForeground: scheme.onSurface.withValues(alpha: 0.38),
      hoverOverlay: foreground.withValues(alpha: 0.08),
      pressedOverlay: foreground.withValues(alpha: 0.12),
    );
  }

  static PragmaButtonColors _outlinedPalette({
    required Color background,
    required Color foreground,
    required Color border,
    required ColorScheme scheme,
  }) {
    return PragmaButtonColors(
      enabledBackground: background,
      enabledForeground: foreground,
      disabledBackground: scheme.onSurface.withValues(alpha: 0.04),
      disabledForeground: scheme.onSurface.withValues(alpha: 0.38),
      hoverOverlay: foreground.withValues(alpha: 0.08),
      pressedOverlay: foreground.withValues(alpha: 0.12),
      borderColor: border,
      disabledBorderColor: border.withValues(alpha: 0.4),
    );
  }

  static PragmaButtonColors _textPalette({
    required Color foreground,
    required ColorScheme scheme,
  }) {
    return PragmaButtonColors(
      enabledBackground: Colors.transparent,
      enabledForeground: foreground,
      disabledBackground: Colors.transparent,
      disabledForeground: scheme.onSurface.withValues(alpha: 0.38),
      hoverOverlay: foreground.withValues(alpha: 0.08),
      pressedOverlay: foreground.withValues(alpha: 0.12),
    );
  }
}

/// Legacy helpers used by `PragmaTheme` to theme stock Material buttons.
class PragmaButtons {
  const PragmaButtons._();

  static ButtonStyle primaryStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return PragmaButtonStyles.build(
      colors: PragmaButtonColors.resolve(
        colorScheme,
        PragmaButtonHierarchy.primary,
        PragmaButtonTone.brand,
      ),
      padding: _PragmaButtonMetrics.padding(PragmaButtonSize.medium),
      minHeight: _PragmaButtonMetrics.minHeight(PragmaButtonSize.medium),
      textStyle: _PragmaButtonMetrics.textStyle(
        textTheme,
        PragmaButtonSize.medium,
      ),
    );
  }

  static ButtonStyle outlinedStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return PragmaButtonStyles.build(
      colors: PragmaButtonColors.resolve(
        colorScheme,
        PragmaButtonHierarchy.secondary,
        PragmaButtonTone.inverse,
      ),
      padding: _PragmaButtonMetrics.padding(PragmaButtonSize.medium),
      minHeight: _PragmaButtonMetrics.minHeight(PragmaButtonSize.medium),
      textStyle: _PragmaButtonMetrics.textStyle(
        textTheme,
        PragmaButtonSize.medium,
      ),
    );
  }

  static ButtonStyle textStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return PragmaButtonStyles.build(
      colors: PragmaButtonColors.resolve(
        colorScheme,
        PragmaButtonHierarchy.tertiary,
        PragmaButtonTone.brand,
      ),
      padding: _PragmaButtonMetrics.padding(PragmaButtonSize.medium),
      minHeight: _PragmaButtonMetrics.minHeight(PragmaButtonSize.medium),
      textStyle: _PragmaButtonMetrics.textStyle(
        textTheme,
        PragmaButtonSize.medium,
      ),
    );
  }
}
