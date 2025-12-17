import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';

/// Tag interactivo que usa el glow morado de Pragma para etiquetar
/// entidades (personas, squads o tópicos) con opción de remover.
class PragmaTagWidget extends StatefulWidget {
  const PragmaTagWidget({
    required this.label,
    super.key,
    this.leading,
    this.enabled = true,
    this.onPressed,
    this.onRemove,
    this.removeTooltip,
    this.semanticsLabel,
    this.semanticsHint,
  });

  /// Texto central del tag.
  final String label;

  /// Widget que se coloca antes del texto (avatar, ícono o iniciales).
  final Widget? leading;

  /// Controla el estado disabled.
  final bool enabled;

  /// Callback primario del tag.
  final VoidCallback? onPressed;

  /// Callback del ícono de cerrado.
  final VoidCallback? onRemove;

  /// Tooltip personalizado para el botón de remover.
  final String? removeTooltip;

  /// Etiquetas de accesibilidad para describir el contenido.
  final String? semanticsLabel;
  final String? semanticsHint;

  @override
  State<PragmaTagWidget> createState() => _PragmaTagWidgetState();
}

class _PragmaTagWidgetState extends State<PragmaTagWidget> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool canHover =
        widget.enabled && (widget.onPressed != null || widget.onRemove != null);
    final bool showHover = canHover && _isHovered;
    final bool showPressed =
        widget.enabled && widget.onPressed != null && _isPressed;
    final _PragmaTagStyle style = _PragmaTagStyle.resolve(
      scheme: theme.colorScheme,
      enabled: widget.enabled,
      hovered: showHover,
      pressed: showPressed,
    );
    final BorderRadius borderRadius =
        BorderRadius.circular(PragmaBorderRadius.full);

    final Widget child = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PragmaSpacing.md,
        vertical: PragmaSpacing.xxs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.leading != null) ...<Widget>[
            _TagLeading(child: widget.leading!),
            const SizedBox(width: PragmaSpacing.xs),
          ],
          Flexible(
            child: Text(
              widget.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                    color: style.textColor,
                    fontWeight: FontWeight.w600,
                  ) ??
                  TextStyle(
                    color: style.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
            ),
          ),
          if (widget.onRemove != null) ...<Widget>[
            const SizedBox(width: PragmaSpacing.xs),
            _TagRemoveButton(
              enabled: widget.enabled,
              color: style.iconColor,
              tooltip: widget.removeTooltip ?? 'Eliminar tag',
              onPressed: widget.onRemove!,
            ),
          ],
        ],
      ),
    );

    return Semantics(
      label: widget.semanticsLabel ?? widget.label,
      hint: widget.semanticsHint,
      button: widget.onPressed != null,
      enabled: widget.enabled,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: style.backgroundColor,
          gradient: style.gradient,
          borderRadius: borderRadius,
          border: Border.all(color: style.borderColor, width: 1.5),
          boxShadow: style.glow,
        ),
        constraints: const BoxConstraints(minHeight: 40),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: widget.enabled ? widget.onPressed : null,
            borderRadius: borderRadius,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onHover: canHover
                ? (bool value) => setState(() => _isHovered = value)
                : null,
            onHighlightChanged: widget.onPressed != null && widget.enabled
                ? (bool value) => setState(() => _isPressed = value)
                : null,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _TagLeading extends StatelessWidget {
  const _TagLeading({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(PragmaBorderRadius.full),
      child: SizedBox(
        height: 28,
        width: 28,
        child: FittedBox(fit: BoxFit.cover, child: child),
      ),
    );
  }
}

class _TagRemoveButton extends StatelessWidget {
  const _TagRemoveButton({
    required this.enabled,
    required this.color,
    required this.tooltip,
    required this.onPressed,
  });

  final bool enabled;
  final Color color;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color background =
        enabled ? color.withValues(alpha: 0.2) : color.withValues(alpha: 0.1);

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: tooltip,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? onPressed : null,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.close, size: 16, color: color),
          ),
        ),
      ),
    );
  }
}

class _PragmaTagStyle {
  const _PragmaTagStyle({
    required this.backgroundColor,
    required this.gradient,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    required this.glow,
  });

  final Color? backgroundColor;
  final Gradient? gradient;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final List<BoxShadow>? glow;

  static _PragmaTagStyle resolve({
    required ColorScheme scheme,
    required bool enabled,
    required bool hovered,
    required bool pressed,
  }) {
    if (!enabled) {
      return _PragmaTagStyle(
        backgroundColor: scheme.surfaceContainerHighest,
        gradient: null,
        borderColor: scheme.outlineVariant,
        textColor: scheme.onSurfaceVariant.withValues(alpha: 0.6),
        iconColor: scheme.onSurfaceVariant.withValues(alpha: 0.6),
        glow: null,
      );
    }

    final List<Color> baseGradient = <Color>[
      scheme.primary,
      Color.lerp(scheme.primary, scheme.secondary, 0.45)!,
    ];
    List<Color> gradientColors = baseGradient;
    if (hovered) {
      gradientColors = baseGradient
          .map((Color color) => color.withValues(alpha: 0.9))
          .toList();
    }
    if (pressed) {
      gradientColors = <Color>[
        scheme.primaryContainer,
        scheme.secondary,
      ];
    }

    final List<BoxShadow>? glow = hovered || pressed
        ? <BoxShadow>[
            BoxShadow(
              color: gradientColors.last.withValues(alpha: 0.35),
              blurRadius: pressed ? 32 : 20,
              spreadRadius: 1,
            ),
          ]
        : null;

    return _PragmaTagStyle(
      backgroundColor: null,
      gradient: LinearGradient(colors: gradientColors),
      borderColor: Colors.transparent,
      textColor: Colors.white,
      iconColor: Colors.white,
      glow: glow,
    );
  }
}
