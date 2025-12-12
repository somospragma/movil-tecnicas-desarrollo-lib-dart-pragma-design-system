import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_opacity.dart';
import '../tokens/pragma_spacing.dart';

/// Tamaños disponibles para el encabezado del `PragmaAccordionWidget`.
///
/// - [PragmaAccordionSize.regular] replica el tamaño "default" descrito
///   en Storybook.
/// - [PragmaAccordionSize.block] utiliza mayor padding y peso visual para
///   encabezados de página o bloques destacados.
enum PragmaAccordionSize { regular, block }

/// Panel expandible alineado al Design System de Pragma.
///
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:pragma_design_system/pragma_design_system.dart';
///
/// void main() {
///   runApp(
///     MaterialApp(
///       theme: PragmaTheme.light(),
///       home: Scaffold(
///         body: Padding(
///           padding: const EdgeInsets.all(24),
///           child: PragmaAccordionWidget(
///             text: 'Preguntas frecuentes',
///             icon: Icons.help_outline,
///             child: const Text(
///               'Puedes anidar cualquier widget como contenido del cuerpo.',
///             ),
///           ),
///         ),
///       ),
///     ),
///   );
/// }
/// ```
///
/// El widget administra su propio estado interno, pero respeta el valor inicial
/// de [open]. Si el padre necesita reiniciar el estado basta con recrear
/// la instancia cambiando la [key] o modificando [open].
class PragmaAccordionWidget extends StatefulWidget {
  const PragmaAccordionWidget({
    required this.text,
    required this.child,
    super.key,
    this.icon,
    this.disable = false,
    this.open = false,
    this.size = PragmaAccordionSize.regular,
    this.onToggle,
    this.animationDuration = const Duration(milliseconds: 220),
  });

  /// Texto principal mostrado en el encabezado del acordeón.
  final String text;

  /// Contenido mostrado cuando el acordeón está abierto.
  final Widget child;

  /// Icono auxiliar alineado a la derecha del encabezado.
  final IconData? icon;

  /// Desactiva la interacción y aplica estilos deshabilitados.
  final bool disable;

  /// Controla el estado inicial (y posteriores actualizaciones) del panel.
  final bool open;

  /// Ajusta padding y jerarquía visual del encabezado.
  final PragmaAccordionSize size;

  /// Callback opcional que se dispara tras cada cambio de estado.
  final ValueChanged<bool>? onToggle;

  /// Duración de las animaciones de apertura/cierre.
  final Duration animationDuration;

  @override
  State<PragmaAccordionWidget> createState() => _PragmaAccordionWidgetState();
}

class _PragmaAccordionWidgetState extends State<PragmaAccordionWidget>
    with TickerProviderStateMixin {
  late bool _isOpen;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.open;
  }

  @override
  void didUpdateWidget(covariant PragmaAccordionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.open != widget.open) {
      _isOpen = widget.open;
    }
  }

  void _toggle() {
    if (widget.disable) {
      return;
    }
    setState(() => _isOpen = !_isOpen);
    widget.onToggle?.call(_isOpen);
  }

  void _handleHover(bool value) {
    if (_isHovered == value) {
      return;
    }
    setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final BorderRadius borderRadius =
        PragmaBorderRadius.circularToken(PragmaBorderRadiusTokens.l);

    final EdgeInsets headerPadding = EdgeInsets.symmetric(
      horizontal: PragmaSpacing.lg,
      vertical: widget.size == PragmaAccordionSize.block
          ? PragmaSpacing.lg
          : PragmaSpacing.md,
    );

    const EdgeInsets bodyPadding = EdgeInsets.fromLTRB(
      PragmaSpacing.lg,
      0,
      PragmaSpacing.lg,
      PragmaSpacing.lg,
    );

    final Color baseBackground = scheme.surface;
    final Color hoverBackground = Color.alphaBlend(
      scheme.primary.withValues(alpha: PragmaOpacity.opacity8),
      baseBackground,
    );
    final Color openBackground = scheme.surfaceContainerHighest;
    final Color disabledBackground = scheme.surfaceContainerHighest
        .withValues(alpha: PragmaOpacity.opacity30);

    final Color containerColor = widget.disable
        ? disabledBackground
        : _isOpen
            ? openBackground
            : (_isHovered ? hoverBackground : baseBackground);

    final Color borderColor = widget.disable
        ? scheme.outlineVariant.withValues(alpha: PragmaOpacity.opacity60)
        : scheme.outlineVariant;

    final TextStyle? baseHeaderStyle = widget.size == PragmaAccordionSize.block
        ? textTheme.titleMedium
        : textTheme.titleSmall ?? textTheme.bodyLarge;

    final TextStyle? headerStyle = baseHeaderStyle?.copyWith(
      fontWeight: FontWeight.w600,
      color: widget.disable
          ? theme.disabledColor
          : baseHeaderStyle.color ?? scheme.onSurface,
    );

    final Color iconColor = widget.disable
        ? theme.disabledColor
        : (_isOpen ? scheme.primary : scheme.onSurfaceVariant);

    return Semantics(
      button: true,
      label: widget.text,
      enabled: !widget.disable,
      expanded: _isOpen,
      onTap: widget.disable ? null : _toggle,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: borderRadius,
          border: Border.all(color: borderColor),
          boxShadow: _isOpen
              ? <BoxShadow>[
                  BoxShadow(
                    color:
                        scheme.shadow.withValues(alpha: PragmaOpacity.opacity8),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : const <BoxShadow>[],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.disable ? null : _toggle,
                  onHover: widget.disable ? null : _handleHover,
                  borderRadius: borderRadius,
                  child: Padding(
                    padding: headerPadding,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: headerStyle,
                          ),
                        ),
                        if (widget.icon != null) ...<Widget>[
                          const SizedBox(width: PragmaSpacing.sm),
                          Icon(
                            widget.icon,
                            color: iconColor,
                            size: 20,
                          ),
                        ],
                        const SizedBox(width: PragmaSpacing.xs),
                        AnimatedRotation(
                          duration: widget.animationDuration,
                          curve: Curves.easeInOut,
                          turns: _isOpen ? 0.5 : 0,
                          child: Icon(
                            Icons.expand_more,
                            color: iconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _PragmaAccordionBody(
                isOpen: _isOpen,
                padding: bodyPadding,
                duration: widget.animationDuration,
                disabled: widget.disable,
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PragmaAccordionBody extends StatelessWidget {
  const _PragmaAccordionBody({
    required this.isOpen,
    required this.padding,
    required this.duration,
    required this.disabled,
    required this.child,
  });

  final bool isOpen;
  final EdgeInsets padding;
  final Duration duration;
  final bool disabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final TextStyle? bodyStyle = theme.textTheme.bodyMedium?.copyWith(
      color: disabled
          ? theme.disabledColor
          : theme.textTheme.bodyMedium?.color ?? scheme.onSurfaceVariant,
    );

    return ClipRect(
      child: AnimatedSize(
        duration: duration,
        alignment: Alignment.topCenter,
        curve: Curves.easeInOut,
        child: isOpen
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: scheme.outlineVariant
                        .withValues(alpha: PragmaOpacity.opacity60),
                  ),
                  Padding(
                    padding: padding,
                    child: DefaultTextStyle.merge(
                      style: bodyStyle,
                      child: child,
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
