import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';

/// Checkbox themado con el glow morado y estados indeterminados opcionales.
class PragmaCheckboxWidget extends StatefulWidget {
  const PragmaCheckboxWidget({
    required this.value,
    required this.label,
    super.key,
    this.description,
    this.onChanged,
    this.enabled = true,
    this.dense = false,
    this.tristate = false,
    this.semanticLabel,
    this.semanticHint,
  });

  final bool? value;
  final String label;
  final String? description;
  final ValueChanged<bool?>? onChanged;
  final bool enabled;
  final bool dense;
  final bool tristate;
  final String? semanticLabel;
  final String? semanticHint;

  @override
  State<PragmaCheckboxWidget> createState() => _PragmaCheckboxWidgetState();
}

class _PragmaCheckboxWidgetState extends State<PragmaCheckboxWidget> {
  bool _isHovered = false;
  bool _isPressed = false;

  bool get _selected => widget.value == true;
  bool get _indeterminate => widget.value == null;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final _PragmaCheckboxColors colors = _PragmaCheckboxColors.resolve(
      scheme: theme.colorScheme,
      enabled: widget.enabled,
      selected: _selected,
      indeterminate: _indeterminate,
      hovered: _isHovered,
      pressed: _isPressed,
    );

    final double verticalPadding =
        widget.dense ? PragmaSpacing.xs : PragmaSpacing.sm;

    final Widget square = _CheckboxSquare(
      colors: colors,
      selected: _selected,
      indeterminate: _indeterminate,
    );

    final List<Widget> textColumn = <Widget>[
      Text(
        widget.label,
        style: textTheme.titleSmall?.copyWith(
              color: colors.labelColor,
              fontWeight: FontWeight.w600,
            ) ??
            TextStyle(
              color: colors.labelColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
      ),
    ];

    if (widget.description != null && widget.description!.isNotEmpty) {
      textColumn.addAll(<Widget>[
        const SizedBox(height: PragmaSpacing.xxxs),
        Text(
          widget.description!,
          style: textTheme.bodySmall?.copyWith(
                color: colors.descriptionColor,
              ) ??
              TextStyle(color: colors.descriptionColor, fontSize: 12),
        ),
      ]);
    }

    Widget content = Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        crossAxisAlignment: widget.description == null
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: <Widget>[
          square,
          const SizedBox(width: PragmaSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: textColumn,
            ),
          ),
        ],
      ),
    );

    final bool canToggle = widget.enabled && widget.onChanged != null;

    content = MouseRegion(
      onEnter: canToggle ? (_) => setState(() => _isHovered = true) : null,
      onExit: canToggle ? (_) => setState(() => _isHovered = false) : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: canToggle ? (_) => setState(() => _isPressed = true) : null,
        onTapCancel:
            canToggle ? () => setState(() => _isPressed = false) : null,
        onTapUp: canToggle
            ? (_) {
                setState(() => _isPressed = false);
                widget.onChanged?.call(_nextValue());
              }
            : null,
        child: content,
      ),
    );

    return Semantics(
      label: widget.semanticLabel ?? widget.label,
      hint: widget.semanticHint ?? widget.description,
      enabled: widget.enabled,
      checked: _selected,
      inMutuallyExclusiveGroup: false,
      mixed: _indeterminate ? true : null,
      container: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: widget.enabled ? 1 : 0.6,
        child: content,
      ),
    );
  }

  bool? _nextValue() {
    final bool? current = widget.value;
    if (current == true) {
      return widget.tristate ? null : false;
    }
    if (current == false) {
      return true;
    }
    return false;
  }
}

class _CheckboxSquare extends StatelessWidget {
  const _CheckboxSquare({
    required this.colors,
    required this.selected,
    required this.indeterminate,
  });

  final _PragmaCheckboxColors colors;
  final bool selected;
  final bool indeterminate;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(PragmaBorderRadius.m),
        border: Border.all(color: colors.borderColor, width: 2),
        color: colors.fillColor,
        boxShadow: colors.glow,
      ),
      alignment: Alignment.center,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: selected || indeterminate ? 1 : 0,
        child: _buildIcon(),
      ),
    );
  }

  Widget _buildIcon() {
    if (indeterminate) {
      return Container(
        width: 10,
        height: 2,
        decoration: BoxDecoration(
          color: colors.iconColor,
          borderRadius: BorderRadius.circular(2),
        ),
      );
    }
    if (selected) {
      return Icon(Icons.check, size: 16, color: colors.iconColor);
    }
    return const SizedBox.shrink();
  }
}

class _PragmaCheckboxColors {
  const _PragmaCheckboxColors({
    required this.fillColor,
    required this.borderColor,
    required this.iconColor,
    required this.glow,
    required this.labelColor,
    required this.descriptionColor,
  });

  final Color fillColor;
  final Color borderColor;
  final Color iconColor;
  final List<BoxShadow>? glow;
  final Color labelColor;
  final Color descriptionColor;

  static _PragmaCheckboxColors resolve({
    required ColorScheme scheme,
    required bool enabled,
    required bool selected,
    required bool indeterminate,
    required bool hovered,
    required bool pressed,
  }) {
    if (!enabled) {
      return _PragmaCheckboxColors(
        fillColor: scheme.surface,
        borderColor: scheme.outlineVariant,
        iconColor: scheme.onSurfaceVariant.withValues(alpha: 0.6),
        glow: null,
        labelColor: scheme.onSurfaceVariant.withValues(alpha: 0.6),
        descriptionColor: scheme.onSurfaceVariant.withValues(alpha: 0.6),
      );
    }

    final bool active = selected || indeterminate;
    Color border = active ? scheme.primary : scheme.outlineVariant;
    Color fill = active ? scheme.primary : scheme.surface;
    Color icon = active ? Colors.white : scheme.onSurface;
    List<BoxShadow>? glow;

    if (hovered) {
      border = scheme.primary;
      if (!active) {
        fill = scheme.primary.withValues(alpha: 0.08);
      }
      glow = <BoxShadow>[
        BoxShadow(
          color: scheme.primary.withValues(alpha: 0.35),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ];
    }

    if (pressed) {
      border = scheme.secondary;
      if (active) {
        fill = scheme.secondary;
      }
      glow = <BoxShadow>[
        BoxShadow(
          color: scheme.secondary.withValues(alpha: 0.4),
          blurRadius: 16,
          spreadRadius: 1,
        ),
      ];
    }

    return _PragmaCheckboxColors(
      fillColor: fill,
      borderColor: border,
      iconColor: icon,
      glow: glow,
      labelColor: scheme.onSurface,
      descriptionColor: scheme.onSurfaceVariant,
    );
  }
}
