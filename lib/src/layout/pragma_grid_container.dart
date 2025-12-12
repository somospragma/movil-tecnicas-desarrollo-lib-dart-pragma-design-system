import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'pragma_grid.dart';

/// Widget utilitario que dibuja la grilla responsive por encima del child
/// para facilitar la maquetación.
class PragmaGridContainer extends StatelessWidget {
  const PragmaGridContainer({
    required this.child,
    this.columnColor = const Color(0x33824DFF),
    this.gutterColor = const Color(0x33FF9800),
    this.marginColor = const Color(0x33F44336),
    this.infoBackgroundColor,
    super.key,
  });

  final Widget child;
  final Color columnColor;
  final Color gutterColor;
  final Color marginColor;
  final Color? infoBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double fallbackWidth = MediaQuery.sizeOf(context).width;
        final double width =
            constraints.hasBoundedWidth ? constraints.maxWidth : fallbackWidth;
        if (width <= 0) {
          return child;
        }
        final PragmaGridConfig grid = getGridConfigFromWidth(width);
        final double contentWidth = math.min(grid.containerWidth, width);
        final double effectiveMargin = math.min(grid.margin, contentWidth / 2);

        final Widget constrainedChild = Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: contentWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: math.max(0, effectiveMargin),
              ),
              child: child,
            ),
          ),
        );

        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            constrainedChild,
            IgnorePointer(
              child: CustomPaint(
                painter: _PragmaGridPainter(
                  grid: grid,
                  availableWidth: width,
                  columnColor: columnColor,
                  gutterColor: gutterColor,
                  marginColor: marginColor,
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: _GridInfoBadge(
                grid: grid,
                width: width,
                backgroundColor: infoBackgroundColor ??
                    Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.1),
                textColor: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PragmaGridPainter extends CustomPainter {
  const _PragmaGridPainter({
    required this.grid,
    required this.availableWidth,
    required this.columnColor,
    required this.gutterColor,
    required this.marginColor,
  });

  final PragmaGridConfig grid;
  final double availableWidth;
  final Color columnColor;
  final Color gutterColor;
  final Color marginColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double containerWidth = math.min(grid.containerWidth, width);
    final double freeSpace = math.max(0, width - containerWidth);
    final double offsetX = freeSpace / 2;
    final double marginWidth = math.min(grid.margin, containerWidth / 2);

    final Paint marginPaint = Paint()..color = marginColor;
    final Paint columnPaint = Paint()..color = columnColor;
    final Paint gutterPaint = Paint()..color = gutterColor;

    // Márgenes izquierdo y derecho
    canvas.drawRect(
      Rect.fromLTWH(offsetX, 0, marginWidth, size.height),
      marginPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        offsetX + containerWidth - marginWidth,
        0,
        marginWidth,
        size.height,
      ),
      marginPaint,
    );

    double cursor = offsetX + marginWidth;
    final double safeGutter = math.max(0, grid.gutter);
    final double safeColumnWidth = math.max(0, grid.columnWidth);

    for (int index = 0; index < grid.columns; index++) {
      // Columna
      canvas.drawRect(
        Rect.fromLTWH(cursor, 0, safeColumnWidth, size.height),
        columnPaint,
      );
      cursor += safeColumnWidth;

      // Gutter (solo entre columnas)
      if (index < grid.columns - 1 && safeGutter > 0) {
        canvas.drawRect(
          Rect.fromLTWH(cursor, 0, safeGutter, size.height),
          gutterPaint,
        );
        cursor += safeGutter;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PragmaGridPainter oldDelegate) {
    return oldDelegate.grid != grid ||
        oldDelegate.availableWidth != availableWidth ||
        oldDelegate.columnColor != columnColor ||
        oldDelegate.gutterColor != gutterColor ||
        oldDelegate.marginColor != marginColor;
  }
}

class _GridInfoBadge extends StatelessWidget {
  const _GridInfoBadge({
    required this.grid,
    required this.width,
    required this.backgroundColor,
    required this.textColor,
  });

  final PragmaGridConfig grid;
  final double width;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = (Theme.of(context).textTheme.labelSmall ??
            const TextStyle(fontSize: 12))
        .copyWith(color: textColor);

    final String viewportLabel = grid.viewport.name;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withValues(alpha: 0.8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Wrap(
          spacing: 12,
          runSpacing: 4,
          children: <Widget>[
            _InfoChip(
              label: 'width',
              value: '${width.toStringAsFixed(0)}px',
              style: baseStyle,
            ),
            _InfoChip(
              label: 'viewport',
              value: viewportLabel,
              style: baseStyle,
            ),
            _InfoChip(
              label: 'columns',
              value: grid.columns.toString(),
              style: baseStyle,
            ),
            _InfoChip(
              label: 'margin',
              value: '${grid.margin.toStringAsFixed(0)}dp',
              style: baseStyle,
            ),
            _InfoChip(
              label: 'gutter',
              value: '${grid.gutter.toStringAsFixed(0)}dp',
              style: baseStyle,
            ),
            _InfoChip(
              label: 'column',
              value: '${grid.columnWidth.toStringAsFixed(0)}dp',
              style: baseStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
    required this.style,
  });

  final String label;
  final String value;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: style,
        children: <TextSpan>[
          TextSpan(
            text: '$label: ',
            style: style.copyWith(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
