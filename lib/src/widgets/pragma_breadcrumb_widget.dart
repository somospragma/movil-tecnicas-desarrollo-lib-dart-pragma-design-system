import 'package:flutter/material.dart';

import '../tokens/pragma_spacing.dart';

/// Breadcrumb navigation aligned with Pragma's guidelines.
///
/// ```dart
/// PragmaBreadcrumbWidget(
///   items: const <PragmaBreadcrumbItem>[
///     PragmaBreadcrumbItem(label: 'Home'),
///     PragmaBreadcrumbItem(label: 'Library'),
///     PragmaBreadcrumbItem(label: 'Components', isCurrent: true),
///   ],
///   type: PragmaBreadcrumbType.standard,
/// )
/// ```
class PragmaBreadcrumbWidget extends StatelessWidget {
  const PragmaBreadcrumbWidget({
    required this.items,
    super.key,
    this.disabled = false,
    this.type = PragmaBreadcrumbType.standard,
    this.separator = '/',
  });

  /// Items that compose the breadcrumb trail.
  final List<PragmaBreadcrumbItem> items;

  /// Disables the navigation and applies muted styles.
  final bool disabled;

  /// Visual variant for the breadcrumb (solid or underline).
  final PragmaBreadcrumbType type;

  /// Text separator placed between items. Defaults to `/`.
  final String separator;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final TextStyle baseStyle = theme.textTheme.bodyMedium ?? const TextStyle();

    final TextStyle interactiveStyle = baseStyle.copyWith(
      color: disabled ? theme.disabledColor : scheme.primary,
      decoration: type == PragmaBreadcrumbType.underline && !disabled
          ? TextDecoration.underline
          : TextDecoration.none,
      decorationColor: scheme.primary,
      decorationThickness: 2,
    );

    final TextStyle currentStyle = baseStyle.copyWith(
      color: disabled ? theme.disabledColor : scheme.onSurface,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none,
    );

    final TextStyle separatorStyle = baseStyle.copyWith(
      color: disabled ? theme.disabledColor : scheme.onSurfaceVariant,
    );

    final int currentIndex = _resolveCurrentIndex();

    final List<Widget> segments = <Widget>[];
    for (int index = 0; index < items.length; index++) {
      final PragmaBreadcrumbItem item = items[index];
      final bool isCurrent = index == currentIndex;
      final Widget crumb = _BreadcrumbItemView(
        item: item,
        style: isCurrent ? currentStyle : interactiveStyle,
        isCurrent: isCurrent,
        disabled: disabled,
      );

      segments.add(
        _BreadcrumbSegment(
          crumb: crumb,
          separator: Text(separator, style: separatorStyle),
          hasSeparator: index < items.length - 1,
        ),
      );
    }

    return Semantics(
      label: 'Breadcrumb navigation',
      child: Wrap(
        spacing: PragmaSpacing.xs,
        runSpacing: PragmaSpacing.xxs,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: segments,
      ),
    );
  }

  int _resolveCurrentIndex() {
    final int explicitIndex =
        items.indexWhere((PragmaBreadcrumbItem item) => item.isCurrent);
    if (explicitIndex != -1) {
      return explicitIndex;
    }
    return items.length - 1;
  }
}

/// Visual variants supported by [PragmaBreadcrumbWidget].
enum PragmaBreadcrumbType { standard, underline }

/// Data structure that represents a breadcrumb entry.
class PragmaBreadcrumbItem {
  const PragmaBreadcrumbItem({
    required this.label,
    this.onTap,
    this.isCurrent = false,
    this.tooltip,
    this.semanticLabel,
  });

  /// Visible label shown inside the breadcrumb.
  final String label;

  /// Optional tap callback used for navigation.
  final VoidCallback? onTap;

  /// Marks the item as the current location in the hierarchy.
  final bool isCurrent;

  /// Tooltip message displayed on long press / hover.
  final String? tooltip;

  /// Custom semantics label (falls back to [label]).
  final String? semanticLabel;
}

class _BreadcrumbItemView extends StatelessWidget {
  const _BreadcrumbItemView({
    required this.item,
    required this.style,
    required this.isCurrent,
    required this.disabled,
  });

  final PragmaBreadcrumbItem item;
  final TextStyle style;
  final bool isCurrent;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final bool canTap = !disabled && !isCurrent && item.onTap != null;
    Widget label = Text(
      item.label,
      style: style,
      overflow: TextOverflow.ellipsis,
    );

    label = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PragmaSpacing.xxs,
        vertical: PragmaSpacing.xxxs,
      ),
      child: label,
    );

    if ((item.tooltip ?? '').isNotEmpty) {
      label = Tooltip(message: item.tooltip, child: label);
    }

    if (canTap) {
      label = Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(8),
          child: label,
        ),
      );
    }

    return Semantics(
      button: canTap,
      enabled: canTap,
      selected: isCurrent,
      label: item.semanticLabel ?? item.label,
      child: label,
    );
  }
}

class _BreadcrumbSegment extends StatelessWidget {
  const _BreadcrumbSegment({
    required this.crumb,
    required this.separator,
    required this.hasSeparator,
  });

  final Widget crumb;
  final Widget separator;
  final bool hasSeparator;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        crumb,
        if (hasSeparator) ...<Widget>[
          const SizedBox(width: PragmaSpacing.xxs),
          separator,
        ],
      ],
    );
  }
}
