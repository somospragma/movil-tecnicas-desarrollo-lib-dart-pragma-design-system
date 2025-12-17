import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';

/// Variantes admitidas por [PragmaLoadingWidget].
enum PragmaLoadingVariant { circular, linear }

/// Indicador de carga con relleno neón alineado al sistema de diseño.
class PragmaLoadingWidget extends StatelessWidget {
  const PragmaLoadingWidget({
    required this.value,
    super.key,
    this.variant = PragmaLoadingVariant.circular,
    this.caption,
    this.showPercentageLabel = true,
    this.size = 120,
    this.strokeWidth = 12,
    this.linearHeight = 14,
    this.linearWidth,
    this.animationDuration = const Duration(milliseconds: 600),
    this.animationCurve = Curves.easeOutCubic,
  });

  /// Valor entre 0 y 1 que representa el avance del indicador.
  final double value;

  /// Selecciona entre el indicador circular o la barra de progreso.
  final PragmaLoadingVariant variant;

  /// Texto descriptivo mostrado debajo del componente (opcional).
  final String? caption;

  /// Controla si se muestra el porcentaje dentro del componente.
  final bool showPercentageLabel;

  /// Tamaño (alto/ancho) del indicador circular.
  final double size;

  /// Grosor del trazo circular.
  final double strokeWidth;

  /// Altura de la barra cuando la variante es [PragmaLoadingVariant.linear].
  final double linearHeight;

  /// Ancho opcional para la barra de progreso. Si es `null`, usa el espacio disponible.
  final double? linearWidth;

  /// Duración de la animación entre valores consecutivos.
  final Duration animationDuration;

  /// Curva aplicada a la interpolación.
  final Curve animationCurve;

  double get _clampedValue {
    if (value.isNaN || value.isInfinite) {
      return 0;
    }
    return value.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color captionColor =
        Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.22);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _clampedValue),
      duration: animationDuration,
      curve: animationCurve,
      builder: (BuildContext context, double progress, _) {
        Widget indicator;
        if (variant == PragmaLoadingVariant.circular) {
          indicator = SizedBox(
            height: size,
            width: size,
            child: _CircularNeonIndicator(
              progress: progress,
              strokeWidth: strokeWidth,
              showPercentage: showPercentageLabel,
            ),
          );
        } else {
          indicator = _LinearNeonIndicator(
            progress: progress,
            height: linearHeight,
            showPercentage: showPercentageLabel,
          );
          if (linearWidth != null) {
            indicator = SizedBox(width: linearWidth, child: indicator);
          }
        }

        if (caption == null) {
          return indicator;
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            indicator,
            const SizedBox(height: PragmaSpacing.xs),
            Text(
              caption!,
              style: textTheme.labelLarge?.copyWith(color: captionColor),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}

class _CircularNeonIndicator extends StatelessWidget {
  const _CircularNeonIndicator({
    required this.progress,
    required this.strokeWidth,
    required this.showPercentage,
  });

  final double progress;
  final double strokeWidth;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final SweepGradient gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: -math.pi / 2 + math.pi * 2,
      colors: _neonColors(scheme),
      stops: const <double>[0, 0.55, 1],
    );

    return CustomPaint(
      painter: _CircularNeonPainter(
        progress: progress,
        strokeWidth: strokeWidth,
        trackColor: scheme.onSurfaceVariant.withValues(alpha: 0.18),
        gradient: gradient,
      ),
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: showPercentage ? 1 : 0,
          child: Text(
            _percentageLabel(progress),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularNeonPainter extends CustomPainter {
  const _CircularNeonPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.gradient,
  });

  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final SweepGradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    const double startAngle = -math.pi / 2;
    final double sweepAngle = math.pi * 2 * progress;

    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, math.pi * 2, false, trackPaint);

    final Paint glowPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.outer, 12);
    canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);

    final Paint corePaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth - 2
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweepAngle, false, corePaint);
  }

  @override
  bool shouldRepaint(_CircularNeonPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackColor != trackColor;
  }
}

class _LinearNeonIndicator extends StatelessWidget {
  const _LinearNeonIndicator({
    required this.progress,
    required this.height,
    required this.showPercentage,
  });

  final double progress;
  final double height;
  final bool showPercentage;

  static const double _fallbackWidth = 280;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final List<Color> gradientColors = _neonColors(scheme);
    final Color trackColor = scheme.onSurfaceVariant
        .withValues(alpha: theme.brightness == Brightness.dark ? 0.32 : 0.16);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width =
            constraints.maxWidth.isFinite && constraints.maxWidth > 0
                ? constraints.maxWidth
                : _fallbackWidth;
        final double fillWidth = width * progress;

        final Widget track = Container(
          height: height,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(PragmaBorderRadius.l),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: fillWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.circular(PragmaBorderRadius.l),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: gradientColors.last.withValues(alpha: 0.55),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                  BoxShadow(
                    color: gradientColors.first.withValues(alpha: 0.42),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _coreHighlightColors(scheme),
                ),
                borderRadius: BorderRadius.circular(PragmaBorderRadius.l),
              ),
            ),
          ),
        );

        if (!showPercentage) {
          return SizedBox(width: width, child: track);
        }

        const double labelWidth = 56;
        final double safeLeft =
            (fillWidth - labelWidth / 2).clamp(0.0, width - labelWidth);

        final Widget label = Container(
          width: labelWidth,
          padding: const EdgeInsets.symmetric(
            horizontal: PragmaSpacing.xs,
            vertical: PragmaSpacing.xxxs,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(PragmaBorderRadius.m),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: theme.colorScheme.scrim.withValues(alpha: 0.92),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            _percentageLabel(progress),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        );

        return SizedBox(
          width: width,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              track,
              Positioned(
                left: safeLeft,
                top: -(height + 8),
                child: label,
              ),
            ],
          ),
        );
      },
    );
  }
}

List<Color> _neonColors(ColorScheme scheme) {
  final Color mid = Color.lerp(scheme.primary, scheme.secondary, 0.35)!;
  return <Color>[
    scheme.primary.withValues(alpha: 0.95),
    mid.withValues(alpha: 0.9),
    scheme.secondary.withValues(alpha: 0.95),
  ];
}

List<Color> _coreHighlightColors(ColorScheme scheme) {
  final Color darker = Color.lerp(scheme.primary, scheme.secondary, 0.15)!;
  return <Color>[
    darker.withValues(alpha: 0.55),
    Colors.transparent,
  ];
}

String _percentageLabel(double value) {
  final int percent = (value * 100).round();
  return '$percent%';
}
