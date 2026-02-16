import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';

/// Header del DS con label a la izquierda y acciones libres a la derecha.
class DsHeaderWidget extends StatelessWidget {
  const DsHeaderWidget({
    required this.title,
    super.key,
    this.actions = const <Widget>[],
    this.leading,
    this.height = 72,
    this.compactHeight = 64,
    this.semanticLabel,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.compactBreakpoint = 720,
  })  : assert(height > 0),
        assert(compactHeight > 0),
        assert(compactBreakpoint > 0);

  /// Texto principal renderizado en el extremo izquierdo.
  final String title;

  /// Lista flexible de acciones para el extremo derecho.
  final List<Widget> actions;

  /// Slot opcional para branding o contenido previo al título.
  final Widget? leading;

  /// Altura por defecto para desktop/tablet amplio.
  final double height;

  /// Altura usada cuando el ancho disponible es compacto.
  final double compactHeight;

  /// Semántica del contenedor raíz.
  final String? semanticLabel;

  /// Override de color de fondo.
  final Color? backgroundColor;

  /// Override del color del borde.
  final Color? borderColor;

  /// Padding del header. Si se omite, usa tokens adaptativos.
  final EdgeInsetsGeometry? padding;

  /// Breakpoint para activar modo compacto.
  final double compactBreakpoint;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isCompact = constraints.hasBoundedWidth &&
            constraints.maxWidth < compactBreakpoint;

        final double resolvedHeight = isCompact ? compactHeight : height;
        final EdgeInsetsGeometry resolvedPadding = padding ??
            EdgeInsets.symmetric(
              horizontal: isCompact ? PragmaSpacing.sm : PragmaSpacing.md,
              vertical: PragmaSpacing.xs,
            );

        final TextStyle? titleStyle = (isCompact
                ? theme.textTheme.titleMedium
                : theme.textTheme.headlineSmall)
            ?.copyWith(fontWeight: FontWeight.w700);

        final Widget actionsStrip = actions.isEmpty
            ? const SizedBox.shrink()
            : IconTheme.merge(
                data: IconThemeData(size: isCompact ? 20 : 22),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _withSpacing(
                      actions,
                      spacing: isCompact ? PragmaSpacing.xs : PragmaSpacing.sm,
                    ),
                  ),
                ),
              );

        final Widget leftArea = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (leading != null) ...<Widget>[
              leading!,
              SizedBox(width: isCompact ? PragmaSpacing.xs : PragmaSpacing.sm),
            ],
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: titleStyle,
              ),
            ),
          ],
        );

        return Semantics(
          container: true,
          label: semanticLabel ?? title,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor ?? scheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: borderColor ?? scheme.outlineVariant,
                ),
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: resolvedHeight),
              child: Padding(
                padding: resolvedPadding,
                child: Row(
                  children: <Widget>[
                    Expanded(flex: 5, child: leftArea),
                    SizedBox(
                      width: isCompact ? PragmaSpacing.xs : PragmaSpacing.sm,
                    ),
                    Flexible(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.hasBoundedWidth
                                ? math.max(
                                    0,
                                    constraints.maxWidth *
                                        (isCompact ? 0.58 : 0.52),
                                  )
                                : double.infinity,
                          ),
                          child: actionsStrip,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static List<Widget> _withSpacing(
    List<Widget> children, {
    required double spacing,
  }) {
    if (children.length <= 1) {
      return children;
    }

    final List<Widget> result = <Widget>[];
    for (int index = 0; index < children.length; index++) {
      result.add(children[index]);
      if (index < children.length - 1) {
        result.add(SizedBox(width: spacing));
      }
    }
    return result;
  }
}

/// Wrapper visual para acciones de header cuando se requiere consistencia DS.
class DsHeaderActionSurface extends StatelessWidget {
  const DsHeaderActionSurface({
    required this.child,
    super.key,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius:
            PragmaBorderRadius.circularToken(PragmaBorderRadiusTokens.m),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: PragmaSpacing.xs,
              vertical: PragmaSpacing.xxxs,
            ),
        child: child,
      ),
    );
  }
}
