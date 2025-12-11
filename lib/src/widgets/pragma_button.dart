import 'package:flutter/material.dart';

import '../tokens/pragma_spacing.dart';

enum PragmaButtonVariant { primary, tonal, secondary, text }

/// Botón estilizado según las guías de Pragma.
class PragmaButton extends StatelessWidget {
  const PragmaButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.leading,
    this.trailing,
    this.variant = PragmaButtonVariant.primary,
    this.expand = false,
  });
  factory PragmaButton.icon({
    required String label,
    required VoidCallback? onPressed,
    required IconData icon,
    Key? key,
    PragmaButtonVariant variant = PragmaButtonVariant.primary,
  }) {
    return PragmaButton(
      key: key,
      label: label,
      onPressed: onPressed,
      variant: variant,
      leading: Icon(icon),
    );
  }

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final PragmaButtonVariant variant;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final _PragmaButtonChild child = _PragmaButtonChild(
      label: label,
      leading: leading,
      trailing: trailing,
      expand: expand,
    );

    switch (variant) {
      case PragmaButtonVariant.primary:
        return FilledButton(
          style: PragmaButtons.primaryStyle(colorScheme: colorScheme),
          onPressed: onPressed,
          child: child,
        );
      case PragmaButtonVariant.tonal:
        return FilledButton.tonal(
          style: PragmaButtons.tonalStyle(colorScheme: colorScheme),
          onPressed: onPressed,
          child: child,
        );
      case PragmaButtonVariant.secondary:
        return OutlinedButton(
          style: PragmaButtons.outlinedStyle(colorScheme: colorScheme),
          onPressed: onPressed,
          child: child,
        );
      case PragmaButtonVariant.text:
        return TextButton(
          style: PragmaButtons.textStyle(colorScheme: colorScheme),
          onPressed: onPressed,
          child: child,
        );
    }
  }
}

class _PragmaButtonChild extends StatelessWidget {
  const _PragmaButtonChild({
    required this.label,
    this.leading,
    this.trailing,
    this.expand = false,
  });

  final String label;
  final Widget? leading;
  final Widget? trailing;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.labelLarge;
    final List<Widget> children = <Widget>[];

    if (leading != null) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(right: PragmaSpacing.xs),
          child: IconTheme.merge(
            data: const IconThemeData(size: 20),
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
          style: textStyle,
        ),
      ),
    );

    if (trailing != null) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(left: PragmaSpacing.xs),
          child: IconTheme.merge(
            data: const IconThemeData(size: 20),
            child: trailing!,
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: PragmaSpacing.xxl),
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}

/// Utilidades de estilos para integrar con los temas de Flutter.
class PragmaButtons {
  const PragmaButtons._();

  static RoundedRectangleBorder get _shape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));

  static ButtonStyle primaryStyle({required ColorScheme colorScheme}) {
    return FilledButton.styleFrom(
      padding: PragmaSpacing.insetSymmetric(
        horizontal: PragmaSpacing.lg,
        vertical: PragmaSpacing.sm,
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      shape: _shape,
    );
  }

  static ButtonStyle tonalStyle({required ColorScheme colorScheme}) {
    return FilledButton.styleFrom(
      padding: PragmaSpacing.insetSymmetric(
        horizontal: PragmaSpacing.lg,
        vertical: PragmaSpacing.sm,
      ),
      backgroundColor: colorScheme.secondaryContainer,
      foregroundColor: colorScheme.onSecondaryContainer,
      shape: _shape,
    );
  }

  static ButtonStyle outlinedStyle({required ColorScheme colorScheme}) {
    return OutlinedButton.styleFrom(
      padding: PragmaSpacing.insetSymmetric(
        horizontal: PragmaSpacing.lg,
        vertical: PragmaSpacing.sm,
      ),
      foregroundColor: colorScheme.primary,
      side: BorderSide(color: colorScheme.outline),
      shape: _shape,
    );
  }

  static ButtonStyle textStyle({required ColorScheme colorScheme}) {
    return TextButton.styleFrom(
      padding: PragmaSpacing.insetSymmetric(
        horizontal: PragmaSpacing.xl,
        vertical: PragmaSpacing.sm,
      ),
      foregroundColor: colorScheme.primary,
      shape: _shape,
    );
  }
}
