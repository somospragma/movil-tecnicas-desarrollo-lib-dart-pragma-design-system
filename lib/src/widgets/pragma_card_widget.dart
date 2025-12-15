import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';

enum PragmaCardVariant { elevated, outlined, tonal }

enum PragmaCardSize { large, small }

/// Superficie versátil que agrupa contenido y acciones bajo una misma jerarquía.
class PragmaCardWidget extends StatelessWidget {
  const PragmaCardWidget({
    required this.body,
    super.key,
    this.title,
    this.subtitle,
    this.metadata,
    this.media,
    this.actions = const <Widget>[],
    this.onTap,
    this.padding,
    this.size = PragmaCardSize.large,
    this.variant = PragmaCardVariant.elevated,
  });

  final Widget body;
  final String? title;
  final String? subtitle;
  final Widget? metadata;
  final Widget? media;
  final List<Widget> actions;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final PragmaCardSize size;
  final PragmaCardVariant variant;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final _PragmaCardColors colors =
        _PragmaCardColors.resolve(colorScheme, variant);
    final EdgeInsetsGeometry resolvedPadding =
        padding ?? _PragmaCardMetrics.padding(size);
    final BorderRadius borderRadius =
        BorderRadius.circular(PragmaBorderRadius.xl);

    final bool hasHeader =
        title != null || subtitle != null || metadata != null;

    final List<Widget> contentChildren = <Widget>[];
    if (hasHeader) {
      contentChildren.add(
        _PragmaCardHeader(
          title: title,
          subtitle: subtitle,
          metadata: metadata,
          colors: colors,
          textTheme: theme.textTheme,
          colorScheme: colorScheme,
        ),
      );
    }
    contentChildren.add(body);
    if (actions.isNotEmpty) {
      contentChildren.add(_PragmaCardActions(actions: actions));
    }

    final Widget content = Padding(
      padding: resolvedPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: _PragmaCardMetrics.separate(contentChildren),
      ),
    );

    final List<Widget> columnChildren = <Widget>[
      if (media != null)
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(PragmaBorderRadius.xl),
          ),
          child: media,
        ),
      content,
    ];

    Widget interactiveChild = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnChildren,
    );

    if (onTap != null) {
      interactiveChild = InkWell(
        onTap: onTap,
        splashColor: colors.foreground.withValues(alpha: 0.12),
        highlightColor: colors.foreground.withValues(alpha: 0.08),
        borderRadius: borderRadius,
        child: interactiveChild,
      );
    }

    final ShapeBorder shape = RoundedRectangleBorder(
      borderRadius: borderRadius,
      side: colors.borderColor == null
          ? BorderSide.none
          : BorderSide(color: colors.borderColor!, width: 1.2),
    );

    return Material(
      color: colors.background,
      elevation: colors.elevation,
      shadowColor: colors.shadowColor,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: interactiveChild,
    );
  }
}

class _PragmaCardMetrics {
  const _PragmaCardMetrics._();

  static EdgeInsetsGeometry padding(PragmaCardSize size) {
    switch (size) {
      case PragmaCardSize.large:
        return PragmaSpacing.insetSymmetric(
          horizontal: PragmaSpacing.xl,
          vertical: PragmaSpacing.lg,
        );
      case PragmaCardSize.small:
        return PragmaSpacing.insetSymmetric(
          horizontal: PragmaSpacing.lg,
          vertical: PragmaSpacing.md,
        );
    }
  }

  static List<Widget> separate(List<Widget> children) {
    if (children.isEmpty) {
      return const <Widget>[];
    }
    final List<Widget> result = <Widget>[];
    for (final Widget child in children) {
      if (result.isNotEmpty) {
        result.add(const SizedBox(height: PragmaSpacing.md));
      }
      result.add(child);
    }
    return result;
  }
}

class _PragmaCardColors {
  const _PragmaCardColors({
    required this.background,
    required this.foreground,
    required this.shadowColor,
    this.borderColor,
    this.elevation = 0,
  });

  final Color background;
  final Color foreground;
  final Color shadowColor;
  final Color? borderColor;
  final double elevation;

  static _PragmaCardColors resolve(
    ColorScheme scheme,
    PragmaCardVariant variant,
  ) {
    switch (variant) {
      case PragmaCardVariant.elevated:
        return _PragmaCardColors(
          background: scheme.surface,
          foreground: scheme.onSurface,
          shadowColor: scheme.shadow.withValues(alpha: 0.45),
          elevation: 2,
        );
      case PragmaCardVariant.outlined:
        return _PragmaCardColors(
          background: scheme.surface,
          foreground: scheme.onSurface,
          borderColor: scheme.outlineVariant,
          shadowColor: Colors.transparent,
        );
      case PragmaCardVariant.tonal:
        return _PragmaCardColors(
          background: scheme.secondaryContainer,
          foreground: scheme.onSecondaryContainer,
          shadowColor: scheme.shadow.withValues(alpha: 0.25),
        );
    }
  }
}

class _PragmaCardHeader extends StatelessWidget {
  const _PragmaCardHeader({
    required this.colors,
    required this.textTheme,
    required this.colorScheme,
    this.title,
    this.subtitle,
    this.metadata,
  });

  final _PragmaCardColors colors;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final String? title;
  final String? subtitle;
  final Widget? metadata;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    if (title != null && title!.isNotEmpty) {
      children.add(
        Text(
          title!,
          style:
              (textTheme.titleMedium ?? const TextStyle(fontSize: 18)).copyWith(
            fontWeight: FontWeight.w600,
            color: colors.foreground,
          ),
        ),
      );
    }

    if (subtitle != null && subtitle!.isNotEmpty) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: PragmaSpacing.xxxs));
      }
      children.add(
        Text(
          subtitle!,
          style:
              (textTheme.bodyMedium ?? const TextStyle(fontSize: 14)).copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    if (metadata != null) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: PragmaSpacing.xs));
      }
      children.add(metadata!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class _PragmaCardActions extends StatelessWidget {
  const _PragmaCardActions({required this.actions});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: PragmaSpacing.sm,
        runSpacing: PragmaSpacing.xs,
        children: actions,
      ),
    );
  }
}
