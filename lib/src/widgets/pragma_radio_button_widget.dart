import 'package:flutter/material.dart';

import '../tokens/pragma_spacing.dart';

/// Radio button alineado al spec de Pragma con glow morado,
/// estados hover/pressed y soporte para descripciones.
class PragmaRadioButtonWidget<T> extends StatefulWidget {
  const PragmaRadioButtonWidget({
    required this.value,
    required this.groupValue,
    required this.label,
    super.key,
    this.description,
    this.onChanged,
    this.enabled = true,
    this.dense = false,
    this.semanticLabel,
    this.semanticHint,
  });

  /// Valor representado por este radio.
  final T value;

  /// Valor seleccionado actualmente en el grupo.
  final T? groupValue;

  /// Etiqueta principal mostrada a la derecha del control.
  final String label;

  /// Copy auxiliar opcional bajo el label.
  final String? description;

  /// Se emite cuando el usuario selecciona el radio.
  final ValueChanged<T?>? onChanged;

  /// Controla el estado disabled.
  final bool enabled;

  /// Reduce la altura de padding vertical cuando es `true`.
  final bool dense;

  /// Etiquetas personalizadas para accesibilidad.
  final String? semanticLabel;
  final String? semanticHint;

  @override
  State<PragmaRadioButtonWidget<T>> createState() =>
      _PragmaRadioButtonWidgetState<T>();
}

class _PragmaRadioButtonWidgetState<T>
    extends State<PragmaRadioButtonWidget<T>> {
  bool _isHovered = false;
  bool _isPressed = false;

  bool get _selected => widget.groupValue == widget.value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final _PragmaRadioColors colors = _PragmaRadioColors.resolve(
      scheme: theme.colorScheme,
      enabled: widget.enabled,
      selected: _selected,
      hovered: _isHovered,
      pressed: _isPressed,
    );

    final double verticalPadding =
        widget.dense ? PragmaSpacing.xs : PragmaSpacing.sm;
    final Widget radio = _RadioCircle(colors: colors, selected: _selected);

    final List<Widget> columnChildren = <Widget>[
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
      columnChildren.addAll(<Widget>[
        const SizedBox(height: PragmaSpacing.xxxs),
        Text(
          widget.description!,
          style:
              textTheme.bodySmall?.copyWith(color: colors.descriptionColor) ??
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
          radio,
          const SizedBox(width: PragmaSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren,
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
                widget.onChanged?.call(widget.value);
              }
            : null,
        child: content,
      ),
    );

    return Semantics(
      checked: _selected,
      enabled: widget.enabled,
      inMutuallyExclusiveGroup: true,
      label: widget.semanticLabel ?? widget.label,
      hint: widget.semanticHint ?? widget.description,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: widget.enabled ? 1 : 0.6,
        child: content,
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  const _RadioCircle({required this.colors, required this.selected});

  final _PragmaRadioColors colors;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.strokeColor, width: 2),
        color: colors.backgroundColor,
        boxShadow: colors.glow,
      ),
      alignment: Alignment.center,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: selected ? 12 : 0,
        height: selected ? 12 : 0,
        decoration: BoxDecoration(
          color: selected ? colors.innerFill : Colors.transparent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _PragmaRadioColors {
  const _PragmaRadioColors({
    required this.backgroundColor,
    required this.strokeColor,
    required this.innerFill,
    required this.glow,
    required this.labelColor,
    required this.descriptionColor,
  });

  final Color backgroundColor;
  final Color strokeColor;
  final Color innerFill;
  final List<BoxShadow>? glow;
  final Color labelColor;
  final Color descriptionColor;

  static _PragmaRadioColors resolve({
    required ColorScheme scheme,
    required bool enabled,
    required bool selected,
    required bool hovered,
    required bool pressed,
  }) {
    if (!enabled) {
      return _PragmaRadioColors(
        backgroundColor: scheme.surface,
        strokeColor: scheme.outlineVariant,
        innerFill: scheme.outlineVariant,
        glow: null,
        labelColor: scheme.onSurfaceVariant.withValues(alpha: 0.6),
        descriptionColor: scheme.onSurfaceVariant.withValues(alpha: 0.6),
      );
    }

    final Color baseStroke = scheme.primary;
    final Color baseFill = scheme.primary;
    Color stroke = baseStroke;
    Color fill = baseFill;
    List<BoxShadow>? glow;

    if (hovered) {
      stroke = baseStroke;
      fill = baseFill;
      glow = <BoxShadow>[
        BoxShadow(
          color: baseStroke.withValues(alpha: 0.4),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ];
    }
    if (pressed) {
      stroke = scheme.secondary;
      fill = scheme.secondary;
      glow = <BoxShadow>[
        BoxShadow(
          color: stroke.withValues(alpha: 0.55),
          blurRadius: 14,
          spreadRadius: 1,
        ),
      ];
    }

    return _PragmaRadioColors(
      backgroundColor: scheme.surface,
      strokeColor: selected ? stroke : scheme.outlineVariant,
      innerFill: fill,
      glow: selected ? glow : null,
      labelColor: scheme.onSurface,
      descriptionColor: scheme.onSurfaceVariant,
    );
  }
}
