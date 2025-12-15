import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';

/// Entry that describes an option inside `PragmaDropdownWidget`.
class PragmaDropdownOption<T> {
  const PragmaDropdownOption({
    required this.label,
    required this.value,
    this.icon,
    this.enabled = true,
  });

  final String label;
  final T value;
  final IconData? icon;
  final bool enabled;
}

/// Dropdown built with Material 3 primitives but tuned with Pragma tokens.
class PragmaDropdownWidget<T> extends StatelessWidget {
  const PragmaDropdownWidget({
    required this.label,
    required this.options,
    required this.onChanged,
    super.key,
    this.value,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.dense = false,
    this.leading,
    this.trailing,
    this.focusNode,
    this.menuMaxHeight,
  });

  final String label;
  final List<PragmaDropdownOption<T>> options;
  final ValueChanged<T?>? onChanged;
  final T? value;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool dense;
  final Widget? leading;
  final Widget? trailing;
  final FocusNode? focusNode;
  final double? menuMaxHeight;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final _PragmaDropdownColors colors = _PragmaDropdownColors.resolve(
      colorScheme: colorScheme,
      enabled: enabled,
      hasError: errorText != null,
    );

    InputDecoration decoration = InputDecoration(
      labelText: label,
      helperText: errorText == null ? helperText : null,
      errorText: errorText,
      hintText: placeholder,
      prefixIcon: leading,
      suffixIcon: trailing,
      filled: true,
      fillColor: colors.fillColor,
      contentPadding: _PragmaDropdownMetrics.contentPadding(dense),
    ).applyDefaults(theme.inputDecorationTheme);

    decoration = decoration.copyWith(
      enabled: enabled,
      enabledBorder: _PragmaDropdownMetrics.inputBorder(colors.enabledBorder),
      focusedBorder: _PragmaDropdownMetrics.inputBorder(colors.focusedBorder),
      disabledBorder: _PragmaDropdownMetrics.inputBorder(
        colors.disabledBorder,
      ),
      errorBorder: _PragmaDropdownMetrics.inputBorder(colorScheme.error),
      focusedErrorBorder: _PragmaDropdownMetrics.inputBorder(colorScheme.error),
    );

    final TextStyle dropdownTextStyle =
        (textTheme.bodyLarge ?? const TextStyle(fontSize: 16)).copyWith(
      color: enabled ? colorScheme.primary : colorScheme.onSurfaceVariant,
    );

    final Key dropdownKey = ValueKey<T?>(value);

    final DropdownButtonFormField<T> field = DropdownButtonFormField<T>(
      key: dropdownKey,
      initialValue: value,
      focusNode: focusNode,
      onChanged: enabled ? onChanged : null,
      items: _buildItems(context, value),
      icon: _DropdownCaretIcon(colorScheme: colorScheme, enabled: enabled),
      iconSize: 32,
      isDense: dense,
      isExpanded: true,
      decoration: decoration,
      style: dropdownTextStyle,
      menuMaxHeight: menuMaxHeight,
      dropdownColor: colors.dropdownColor,
      borderRadius: BorderRadius.circular(PragmaBorderRadius.l),
      hint: placeholder == null
          ? null
          : Text(
              placeholder!,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
    );

    if (!enabled) {
      return field;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: field,
    );
  }

  List<DropdownMenuItem<T>> _buildItems(
    BuildContext context,
    T? selectedValue,
  ) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final TextStyle baseStyle =
        textTheme.bodyLarge ?? const TextStyle(fontSize: 16);

    return options
        .map(
          (PragmaDropdownOption<T> option) => DropdownMenuItem<T>(
            value: option.value,
            enabled: option.enabled,
            child: _DropdownOptionTile<T>(
              option: option,
              isSelected: selectedValue == option.value,
              textStyle: baseStyle,
              colorScheme: colorScheme,
            ),
          ),
        )
        .toList();
  }
}

class _PragmaDropdownMetrics {
  const _PragmaDropdownMetrics._();

  static EdgeInsetsGeometry contentPadding(bool dense) {
    if (dense) {
      return PragmaSpacing.insetSymmetric(
        horizontal: PragmaSpacing.md,
        vertical: PragmaSpacing.sm,
      );
    }
    return PragmaSpacing.insetSymmetric(
      horizontal: PragmaSpacing.lg,
      vertical: PragmaSpacing.md,
    );
  }

  static OutlineInputBorder inputBorder(Color color, {double width = 2}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(PragmaBorderRadius.l),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _PragmaDropdownColors {
  const _PragmaDropdownColors({
    required this.fillColor,
    required this.dropdownColor,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.disabledBorder,
  });

  final Color fillColor;
  final Color dropdownColor;
  final Color enabledBorder;
  final Color focusedBorder;
  final Color disabledBorder;

  static _PragmaDropdownColors resolve({
    required ColorScheme colorScheme,
    required bool enabled,
    required bool hasError,
  }) {
    final Color baseFill = colorScheme.surface;
    final Color disabledFill = colorScheme.surfaceContainerHigh;
    final Color borderColor =
        hasError ? colorScheme.error : colorScheme.primary;
    return _PragmaDropdownColors(
      fillColor: enabled ? baseFill : disabledFill,
      dropdownColor: colorScheme.surface,
      enabledBorder: borderColor,
      focusedBorder: borderColor,
      disabledBorder: colorScheme.surfaceContainerHigh,
    );
  }
}

class _DropdownCaretIcon extends StatelessWidget {
  const _DropdownCaretIcon({
    required this.colorScheme,
    required this.enabled,
  });

  final ColorScheme colorScheme;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        enabled ? colorScheme.primary : colorScheme.surfaceContainerHighest;
    final Color iconColor =
        enabled ? colorScheme.surface : colorScheme.onSurfaceVariant;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: iconColor,
        size: 18,
      ),
    );
  }
}

class _DropdownOptionTile<T> extends StatefulWidget {
  const _DropdownOptionTile({
    required this.option,
    required this.isSelected,
    required this.textStyle,
    required this.colorScheme,
  });

  final PragmaDropdownOption<T> option;
  final bool isSelected;
  final TextStyle textStyle;
  final ColorScheme colorScheme;

  @override
  State<_DropdownOptionTile<T>> createState() => _DropdownOptionTileState<T>();
}

class _DropdownOptionTileState<T> extends State<_DropdownOptionTile<T>> {
  bool _hovering = false;

  void _setHovering(bool value) {
    if (!mounted) {
      return;
    }
    setState(() => _hovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.option.enabled;
    final ColorScheme scheme = widget.colorScheme;

    final Color foreground = enabled
        ? (widget.isSelected ? scheme.surface : scheme.primary)
        : scheme.onSurfaceVariant;
    final Color background = !enabled
        ? Colors.transparent
        : widget.isSelected
            ? scheme.primary
            : _hovering
                ? scheme.primary.withValues(alpha: 0.12)
                : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => _setHovering(true),
      onExit: (_) => _setHovering(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(PragmaBorderRadius.m),
          boxShadow: widget.isSelected
              ? <BoxShadow>[
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: PragmaSpacing.md,
          vertical: PragmaSpacing.sm,
        ),
        child: Row(
          children: <Widget>[
            if (widget.option.icon != null)
              Padding(
                padding: const EdgeInsets.only(right: PragmaSpacing.sm),
                child: Icon(
                  widget.option.icon,
                  size: 18,
                  color: foreground,
                ),
              ),
            Expanded(
              child: Text(
                widget.option.label,
                style: widget.textStyle.copyWith(
                  color: foreground,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
