import 'package:flutter/material.dart';

import '../tokens/pragma_color_tokens.dart';
import '../tokens/pragma_spacing.dart';

/// Tamaños soportados por [PragmaStepperWidget].
enum PragmaStepperSize { big, small }

/// Estados gráficos para cada paso del `Stepper`.
enum PragmaStepperStatus {
  currentWhite,
  currentPurple,
  disabled,
  success,
  fail,
}

/// Modelo inmutable que describe un paso dentro del stepper.
@immutable
class PragmaStepperStep {
  const PragmaStepperStep({
    required this.title,
    this.description,
    this.indicatorLabel,
    this.status = PragmaStepperStatus.currentWhite,
  });

  /// Título principal mostrado debajo del indicador.
  final String title;

  /// Texto secundario opcional, útil para detallar el estado de la etapa.
  final String? description;

  /// Texto custom para el indicador. Por defecto se usa el índice del paso.
  final String? indicatorLabel;

  /// Estado visual del paso.
  final PragmaStepperStatus status;
}

/// Stepper horizontal alineado al sistema de diseño de Pragma.
///
/// Replica los indicadores morados con glow para etapas actuales y muestra
/// variantes de éxito, error y deshabilitado siguiendo la guía anexada.
class PragmaStepperWidget extends StatelessWidget {
  const PragmaStepperWidget({
    required this.steps,
    super.key,
    this.size = PragmaStepperSize.big,
    this.gap = PragmaSpacing.md,
  }) : assert(steps.length >= 2, 'Se requieren al menos dos pasos.');

  /// Pasos que se renderizan de izquierda a derecha.
  final List<PragmaStepperStep> steps;

  /// Tamaño visual de los indicadores.
  final PragmaStepperSize size;

  /// Espacio vertical entre el indicador y los textos.
  final double gap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _StepperMetrics metrics = _StepperMetrics(size: size, gap: gap);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int index = 0; index < steps.length; index++)
          Expanded(
            child: _StepperItem(
              step: steps[index],
              index: index,
              metrics: metrics,
              isFirst: index == 0,
              isLast: index == steps.length - 1,
              theme: theme,
            ),
          ),
      ],
    );
  }
}

class _StepperItem extends StatelessWidget {
  const _StepperItem({
    required this.step,
    required this.index,
    required this.metrics,
    required this.isFirst,
    required this.isLast,
    required this.theme,
  });

  final PragmaStepperStep step;
  final int index;
  final _StepperMetrics metrics;
  final bool isFirst;
  final bool isLast;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final _PragmaStepperStyle style = _resolveStyle(step.status, theme);
    final String label = step.indicatorLabel ?? '${index + 1}';
    final TextStyle titleStyle = metrics
        .titleStyle(theme)
        .copyWith(color: style.textColor ?? theme.colorScheme.onSurface);
    final TextStyle? descriptionStyle = step.description == null
        ? null
        : metrics.bodyStyle(theme).copyWith(
              color:
                  style.descriptionColor ?? theme.colorScheme.onSurfaceVariant,
            );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: metrics.itemPadding),
      child: Column(
        children: <Widget>[
          _IndicatorRow(
            metrics: metrics,
            style: style,
            label: label,
            isFirst: isFirst,
            isLast: isLast,
          ),
          SizedBox(height: metrics.gap),
          Text(step.title, style: titleStyle, textAlign: TextAlign.center),
          if (step.description != null) ...<Widget>[
            SizedBox(height: metrics.descriptionGap),
            Text(
              step.description!,
              style: descriptionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _IndicatorRow extends StatelessWidget {
  const _IndicatorRow({
    required this.metrics,
    required this.style,
    required this.label,
    required this.isFirst,
    required this.isLast,
  });

  final _StepperMetrics metrics;
  final _PragmaStepperStyle style;
  final String label;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: metrics.indicatorSize,
      child: Row(
        children: <Widget>[
          if (!isFirst)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: _Connector(
                  metrics: metrics,
                  style: style,
                  isLeading: true,
                ),
              ),
            ),
          Container(
            width: metrics.indicatorSize,
            height: metrics.indicatorSize,
            decoration: BoxDecoration(
              color: style.fillColor,
              gradient: style.fillGradient,
              border: Border.all(
                color: style.borderColor,
                width: style.borderWidth,
              ),
              borderRadius: BorderRadius.circular(metrics.indicatorSize / 2),
              boxShadow: style.shadows,
            ),
            child: Center(
              child: style.icon == null
                  ? Text(
                      label,
                      style: metrics.indicatorTextStyle.copyWith(
                        color: style.labelColor,
                      ),
                    )
                  : Icon(
                      style.icon,
                      color: style.iconColor,
                      size: metrics.iconSize,
                    ),
            ),
          ),
          if (!isLast)
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _Connector(
                  metrics: metrics,
                  style: style,
                  isLeading: false,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector({
    required this.metrics,
    required this.style,
    required this.isLeading,
  });

  final _StepperMetrics metrics;
  final _PragmaStepperStyle style;
  final bool isLeading;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: isLeading ? metrics.connectorGap : 0,
        left: isLeading ? 0 : metrics.connectorGap,
      ),
      height: metrics.connectorThickness,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(metrics.connectorThickness),
        gradient: style.connectorGradient,
        color: style.connectorGradient == null ? style.connectorColor : null,
      ),
    );
  }
}

class _StepperMetrics {
  _StepperMetrics({required this.size, required this.gap});

  final PragmaStepperSize size;
  final double gap;

  double get indicatorSize => size == PragmaStepperSize.big ? 72 : 48;
  double get connectorThickness => size == PragmaStepperSize.big ? 4 : 3;
  double get connectorGap =>
      size == PragmaStepperSize.big ? PragmaSpacing.xs : PragmaSpacing.xxxs;
  double get descriptionGap =>
      size == PragmaStepperSize.big ? PragmaSpacing.xxxs : PragmaSpacing.xxxs;
  double get itemPadding =>
      size == PragmaStepperSize.big ? PragmaSpacing.xs : PragmaSpacing.xxxs;
  double get iconSize => size == PragmaStepperSize.big ? 30 : 20;

  TextStyle get indicatorTextStyle => TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: size == PragmaStepperSize.big ? 30 : 18,
        fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
      );

  TextStyle titleStyle(ThemeData theme) {
    return size == PragmaStepperSize.big
        ? theme.textTheme.titleMedium ?? const TextStyle()
        : theme.textTheme.labelLarge ?? const TextStyle();
  }

  TextStyle bodyStyle(ThemeData theme) {
    return size == PragmaStepperSize.big
        ? theme.textTheme.bodyMedium ?? const TextStyle()
        : theme.textTheme.bodySmall ?? const TextStyle();
  }
}

class _PragmaStepperStyle {
  const _PragmaStepperStyle({
    required this.borderColor,
    required this.borderWidth,
    required this.labelColor,
    this.fillColor,
    this.fillGradient,
    this.textColor,
    this.descriptionColor,
    this.connectorColor,
    this.connectorGradient,
    this.shadows = const <BoxShadow>[],
    this.icon,
    this.iconColor,
  });

  final Color? fillColor;
  final Gradient? fillGradient;
  final Color borderColor;
  final double borderWidth;
  final Color labelColor;
  final Color? textColor;
  final Color? descriptionColor;
  final Color? connectorColor;
  final Gradient? connectorGradient;
  final List<BoxShadow> shadows;
  final IconData? icon;
  final Color? iconColor;
}

_PragmaStepperStyle _resolveStyle(
  PragmaStepperStatus status,
  ThemeData theme,
) {
  final ColorScheme scheme = theme.colorScheme;
  switch (status) {
    case PragmaStepperStatus.currentWhite:
      final Color primary = scheme.primary;
      return _PragmaStepperStyle(
        fillColor: scheme.surface,
        borderColor: primary,
        borderWidth: 2,
        labelColor: primary,
        textColor: scheme.onSurface,
        descriptionColor: scheme.onSurfaceVariant,
        connectorColor: primary.withValues(alpha: 0.35),
        shadows: <BoxShadow>[
          BoxShadow(
            color: primary.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      );
    case PragmaStepperStatus.currentPurple:
      final Gradient gradient = LinearGradient(
        colors: <Color>[
          scheme.primary,
          Color.lerp(scheme.primary, scheme.secondary, 0.45)!,
        ],
      );
      return _PragmaStepperStyle(
        fillGradient: gradient,
        borderColor: Colors.transparent,
        borderWidth: 0,
        labelColor: scheme.onPrimary,
        textColor: scheme.onSurface,
        descriptionColor: scheme.onSurfaceVariant,
        connectorGradient: gradient,
        shadows: <BoxShadow>[
          BoxShadow(
            color: scheme.secondary.withValues(alpha: 0.5),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      );
    case PragmaStepperStatus.disabled:
      final Color neutral = scheme.onSurfaceVariant.withValues(alpha: 0.4);
      return _PragmaStepperStyle(
        fillColor: scheme.surface,
        borderColor: neutral,
        borderWidth: 1.5,
        labelColor: neutral,
        textColor: neutral,
        descriptionColor: neutral,
        connectorColor: neutral.withValues(alpha: 0.6),
      );
    case PragmaStepperStatus.success:
      const Color success = PragmaColorTokens.success500;
      return _PragmaStepperStyle(
        fillColor: success,
        borderColor: success,
        borderWidth: 0,
        labelColor: scheme.onPrimary,
        textColor: scheme.onSurface,
        descriptionColor: scheme.onSurfaceVariant,
        connectorColor: success.withValues(alpha: 0.8),
        icon: Icons.check,
        iconColor: Colors.white,
        shadows: <BoxShadow>[
          BoxShadow(
            color: success.withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      );
    case PragmaStepperStatus.fail:
      const Color error = PragmaColorTokens.error500;
      return _PragmaStepperStyle(
        fillColor: error,
        borderColor: error,
        borderWidth: 0,
        labelColor: Colors.white,
        textColor: scheme.onSurface,
        descriptionColor: scheme.onSurfaceVariant,
        connectorColor: error.withValues(alpha: 0.8),
        icon: Icons.close,
        iconColor: Colors.white,
        shadows: <BoxShadow>[
          BoxShadow(
            color: error.withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      );
  }
}
