import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';
import 'pragma_button.dart';

/// Tonos soportados por [PragmaTooltipWidget].
enum PragmaTooltipTone { light, dark }

/// Posiciones relativas para anclar el tooltip al widget objetivo.
enum PragmaTooltipPlacement { top, bottom, left, right }

/// Acción opcional que se renderiza dentro del tooltip.
class PragmaTooltipAction {
  const PragmaTooltipAction({required this.label, this.onPressed});

  /// Etiqueta del botón interno.
  final String label;

  /// Callback cuando el usuario presiona la acción.
  final VoidCallback? onPressed;
}

/// Tooltip morado con arrow, título opcional, ícono y botón interno.
class PragmaTooltipWidget extends StatefulWidget {
  const PragmaTooltipWidget({
    required this.child,
    required this.message,
    super.key,
    this.title,
    this.icon,
    this.iconColor,
    this.action,
    this.tone = PragmaTooltipTone.dark,
    this.placement = PragmaTooltipPlacement.top,
    this.showDelay = const Duration(milliseconds: 180),
    this.hideDelay = const Duration(milliseconds: 120),
    this.autoHideDuration = const Duration(seconds: 4),
    this.maxWidth = 320,
    this.semanticsLabel,
  });

  /// Widget objetivo que dispara el tooltip.
  final Widget child;

  /// Texto principal del tooltip.
  final String message;

  /// Título opcional que aparece encima del texto principal.
  final String? title;

  /// Ícono opcional alineado al inicio.
  final IconData? icon;

  /// Color personalizado para el ícono.
  final Color? iconColor;

  /// Acción opcional que se muestra como botón terciario.
  final PragmaTooltipAction? action;

  /// Define si se usa superficie `light` o `dark`.
  final PragmaTooltipTone tone;

  /// Controla la posición de la burbuja respecto al objetivo.
  final PragmaTooltipPlacement placement;

  /// Tiempo que se espera antes de mostrar el tooltip al hacer hover.
  final Duration showDelay;

  /// Tiempo que se espera antes de ocultarlo al salir del hover.
  final Duration hideDelay;

  /// Duración máxima visible cuando se abre desde touch. Usa `null` para
  /// deshabilitar el auto-hide en ese escenario.
  final Duration? autoHideDuration;

  /// Ancho máximo de la burbuja.
  final double maxWidth;

  /// Etiqueta personalizada para `Semantics.tooltip`.
  final String? semanticsLabel;

  @override
  State<PragmaTooltipWidget> createState() => _PragmaTooltipWidgetState();
}

class _PragmaTooltipWidgetState extends State<PragmaTooltipWidget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  Timer? _showTimer;
  Timer? _hideTimer;
  Timer? _autoHideTimer;
  bool _hoveringChild = false;
  bool _hoveringOverlay = false;
  bool _manualTriggerActive = false;

  @override
  void dispose() {
    _removeTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget target = widget.child;
    final String? semanticsLabel =
        widget.semanticsLabel ?? _composeSemanticsLabel();
    if (semanticsLabel != null && semanticsLabel.trim().isNotEmpty) {
      target = Semantics(tooltip: semanticsLabel, child: target);
    }

    return MouseRegion(
      onEnter: (_) => _handleChildHover(true),
      onExit: (_) => _handleChildHover(false),
      child: Listener(
        onPointerDown: _handlePointerDown,
        child: CompositedTransformTarget(
          link: _layerLink,
          child: target,
        ),
      ),
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (event.kind == PointerDeviceKind.touch ||
        event.kind == PointerDeviceKind.stylus ||
        event.kind == PointerDeviceKind.invertedStylus) {
      if (_overlayEntry != null && _manualTriggerActive) {
        _manualTriggerActive = false;
        _removeTooltip();
        return;
      }
      _manualTriggerActive = true;
      _showTooltip(immediate: true, fromTap: true);
    }
  }

  void _handleChildHover(bool hovering) {
    _hoveringChild = hovering;
    if (hovering) {
      _manualTriggerActive = false;
      _scheduleShow();
    } else {
      _scheduleHide();
    }
  }

  void _handleOverlayHover(bool hovering) {
    _hoveringOverlay = hovering;
    if (!hovering) {
      _scheduleHide();
    } else {
      _hideTimer?.cancel();
    }
  }

  void _scheduleShow() {
    _hideTimer?.cancel();
    if (_overlayEntry != null) {
      return;
    }
    _showTimer?.cancel();
    _showTimer = Timer(widget.showDelay, () => _showTooltip());
  }

  void _scheduleHide() {
    if (_manualTriggerActive) {
      return;
    }
    if (_overlayEntry == null) {
      return;
    }
    if (_hoveringChild || _hoveringOverlay) {
      return;
    }
    _hideTimer?.cancel();
    _hideTimer = Timer(widget.hideDelay, _removeTooltip);
  }

  void _showTooltip({bool immediate = false, bool fromTap = false}) {
    _showTimer?.cancel();
    if (_overlayEntry != null) {
      _startAutoHideTimer(fromTap: fromTap);
      return;
    }
    final OverlayState overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return _PragmaTooltipOverlay(
          layerLink: _layerLink,
          placement: widget.placement,
          tone: widget.tone,
          title: widget.title,
          message: widget.message,
          icon: widget.icon,
          iconColor: widget.iconColor,
          action: widget.action,
          maxWidth: widget.maxWidth,
          onHoverChanged: _handleOverlayHover,
        );
      },
    );
    overlay.insert(_overlayEntry!);
    _startAutoHideTimer(fromTap: fromTap);
    if (immediate) {
      return;
    }
  }

  void _startAutoHideTimer({required bool fromTap}) {
    _autoHideTimer?.cancel();
    if (!fromTap) {
      return;
    }
    final Duration? duration = widget.autoHideDuration;
    if (duration == null) {
      return;
    }
    _autoHideTimer = Timer(duration, () {
      _manualTriggerActive = false;
      _removeTooltip();
    });
  }

  void _removeTooltip() {
    _showTimer?.cancel();
    _showTimer = null;
    _hideTimer?.cancel();
    _hideTimer = null;
    _autoHideTimer?.cancel();
    _autoHideTimer = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _hoveringOverlay = false;
  }

  String? _composeSemanticsLabel() {
    final List<String> parts = <String>[];
    if ((widget.title ?? '').trim().isNotEmpty) {
      parts.add(widget.title!.trim());
    }
    if (widget.message.trim().isNotEmpty) {
      parts.add(widget.message.trim());
    }
    if (widget.action != null) {
      parts.add(widget.action!.label);
    }
    if (parts.isEmpty) {
      return null;
    }
    return parts.join('. ');
  }
}

class _PragmaTooltipOverlay extends StatelessWidget {
  const _PragmaTooltipOverlay({
    required this.layerLink,
    required this.placement,
    required this.tone,
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.action,
    required this.maxWidth,
    required this.onHoverChanged,
  });

  final LayerLink layerLink;
  final PragmaTooltipPlacement placement;
  final PragmaTooltipTone tone;
  final String? title;
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final PragmaTooltipAction? action;
  final double maxWidth;
  final ValueChanged<bool> onHoverChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _TooltipSurfaceStyle style =
        _TooltipSurfaceStyle.resolve(theme.colorScheme, tone);
    final _TooltipAnchors anchors = _TooltipAnchors.resolve(placement);

    return IgnorePointer(
      ignoring: false,
      child: CompositedTransformFollower(
        link: layerLink,
        targetAnchor: anchors.targetAnchor,
        followerAnchor: anchors.followerAnchor,
        offset: anchors.offset,
        showWhenUnlinked: false,
        child: MouseRegion(
          onEnter: (_) => onHoverChanged(true),
          onExit: (_) => onHoverChanged(false),
          child: _TooltipBubble(
            placement: placement,
            style: style,
            title: title,
            message: message,
            icon: icon,
            iconColor: iconColor,
            action: action,
            maxWidth: maxWidth,
            tone: tone,
          ),
        ),
      ),
    );
  }
}

class _TooltipBubble extends StatelessWidget {
  const _TooltipBubble({
    required this.placement,
    required this.style,
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.action,
    required this.maxWidth,
    required this.tone,
  });

  final PragmaTooltipPlacement placement;
  final _TooltipSurfaceStyle style;
  final String? title;
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final PragmaTooltipAction? action;
  final double maxWidth;
  final PragmaTooltipTone tone;

  @override
  Widget build(BuildContext context) {
    final Widget surface = _TooltipSurface(
      style: style,
      title: title,
      message: message,
      icon: icon,
      iconColor: iconColor,
      action: action,
      maxWidth: maxWidth,
      tone: tone,
    );
    final Widget arrow = _TooltipArrow(
      placement: placement,
      color: style.background,
      gradient: style.gradient,
      borderColor: style.borderColor,
    );

    const double gap = 4;
    switch (placement) {
      case PragmaTooltipPlacement.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            surface,
            const SizedBox(height: gap),
            arrow,
          ],
        );
      case PragmaTooltipPlacement.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            arrow,
            const SizedBox(height: gap),
            surface,
          ],
        );
      case PragmaTooltipPlacement.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            surface,
            const SizedBox(width: gap),
            arrow,
          ],
        );
      case PragmaTooltipPlacement.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            arrow,
            const SizedBox(width: gap),
            surface,
          ],
        );
    }
  }
}

class _TooltipSurface extends StatelessWidget {
  const _TooltipSurface({
    required this.style,
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.action,
    required this.maxWidth,
    required this.tone,
  });

  final _TooltipSurfaceStyle style;
  final String? title;
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final PragmaTooltipAction? action;
  final double maxWidth;
  final PragmaTooltipTone tone;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String? trimmedTitle = title?.trim().isEmpty ?? true ? null : title;

    final List<Widget> columnChildren = <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, color: iconColor ?? style.iconColor, size: 20),
            const SizedBox(width: PragmaSpacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (trimmedTitle != null) ...<Widget>[
                  Text(
                    trimmedTitle,
                    style: textTheme.labelLarge?.copyWith(
                      color: style.titleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  message,
                  style: textTheme.bodyMedium?.copyWith(
                    color: style.textColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ];

    if (action != null) {
      columnChildren
        ..add(const SizedBox(height: PragmaSpacing.sm))
        ..add(
          Align(
            alignment: Alignment.centerLeft,
            child: PragmaTertiaryButton(
              label: action!.label,
              onPressed: action!.onPressed,
              size: PragmaButtonSize.small,
              tone: tone == PragmaTooltipTone.dark
                  ? PragmaButtonTone.inverse
                  : PragmaButtonTone.brand,
            ),
          ),
        );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(PragmaBorderRadiusTokens.l.value),
        gradient: style.gradient,
        color: style.gradient == null ? style.background : null,
        border: Border.all(color: style.borderColor),
        boxShadow: style.shadows,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PragmaSpacing.md,
            vertical: PragmaSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: columnChildren,
          ),
        ),
      ),
    );
  }
}

class _TooltipArrow extends StatelessWidget {
  const _TooltipArrow({
    required this.placement,
    required this.color,
    required this.gradient,
    required this.borderColor,
  });

  final PragmaTooltipPlacement placement;
  final Color color;
  final LinearGradient? gradient;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    double angle = 0;
    switch (placement) {
      case PragmaTooltipPlacement.top:
        angle = math.pi;
        break;
      case PragmaTooltipPlacement.bottom:
        angle = 0;
        break;
      case PragmaTooltipPlacement.left:
        angle = math.pi / 2;
        break;
      case PragmaTooltipPlacement.right:
        angle = -math.pi / 2;
        break;
    }

    return Transform.rotate(
      angle: angle,
      child: CustomPaint(
        size: const Size(18, 10),
        painter: _TooltipArrowPainter(
          color: color,
          gradient: gradient,
          borderColor: borderColor,
        ),
      ),
    );
  }
}

class _TooltipArrowPainter extends CustomPainter {
  const _TooltipArrowPainter({
    required this.color,
    required this.borderColor,
    this.gradient,
  });

  final Color color;
  final Color borderColor;
  final LinearGradient? gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();

    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    if (gradient != null) {
      paint.shader = gradient!.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    }

    canvas.drawPath(path, paint);

    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = borderColor;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _TooltipArrowPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.gradient != gradient;
  }
}

class _TooltipSurfaceStyle {
  const _TooltipSurfaceStyle({
    required this.background,
    required this.gradient,
    required this.textColor,
    required this.titleColor,
    required this.iconColor,
    required this.borderColor,
    required this.shadows,
  });

  final Color background;
  final LinearGradient? gradient;
  final Color textColor;
  final Color titleColor;
  final Color iconColor;
  final Color borderColor;
  final List<BoxShadow> shadows;

  static _TooltipSurfaceStyle resolve(
    ColorScheme scheme,
    PragmaTooltipTone tone,
  ) {
    if (tone == PragmaTooltipTone.dark) {
      final LinearGradient gradient = LinearGradient(
        colors: <Color>[
          scheme.primary,
          scheme.primary.withValues(alpha: 0.9),
        ],
      );
      return _TooltipSurfaceStyle(
        background: scheme.primary,
        gradient: gradient,
        textColor: Colors.white.withValues(alpha: 0.92),
        titleColor: Colors.white,
        iconColor: Colors.white,
        borderColor: Colors.white.withValues(alpha: 0.24),
        shadows: <BoxShadow>[
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.45),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
        ],
      );
    }

    return _TooltipSurfaceStyle(
      background: scheme.surface,
      gradient: null,
      textColor: scheme.onSurface,
      titleColor: scheme.onSurface,
      iconColor: scheme.primary,
      borderColor: scheme.outlineVariant,
      shadows: <BoxShadow>[
        BoxShadow(
          color: scheme.outlineVariant.withValues(alpha: 0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}

class _TooltipAnchors {
  const _TooltipAnchors({
    required this.targetAnchor,
    required this.followerAnchor,
    required this.offset,
  });

  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final Offset offset;

  static _TooltipAnchors resolve(PragmaTooltipPlacement placement) {
    const double gap = 8;
    switch (placement) {
      case PragmaTooltipPlacement.top:
        return const _TooltipAnchors(
          targetAnchor: Alignment.topCenter,
          followerAnchor: Alignment.bottomCenter,
          offset: Offset(0, -gap),
        );
      case PragmaTooltipPlacement.bottom:
        return const _TooltipAnchors(
          targetAnchor: Alignment.bottomCenter,
          followerAnchor: Alignment.topCenter,
          offset: Offset(0, gap),
        );
      case PragmaTooltipPlacement.left:
        return const _TooltipAnchors(
          targetAnchor: Alignment.centerLeft,
          followerAnchor: Alignment.centerRight,
          offset: Offset(-gap, 0),
        );
      case PragmaTooltipPlacement.right:
        return const _TooltipAnchors(
          targetAnchor: Alignment.centerRight,
          followerAnchor: Alignment.centerLeft,
          offset: Offset(gap, 0),
        );
    }
  }
}
