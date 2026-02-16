import 'package:flutter/material.dart';

import '../domain/models/model_ds_sidebar_menu_item.dart';
import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';
import 'pragma_logo_widget.dart';
import 'pragma_tooltip_widget.dart';

/// Sidebar de navegacion del DS para apps Flutter/Web.
class DsSidebarMenuWidget extends StatelessWidget {
  const DsSidebarMenuWidget({
    required this.items,
    super.key,
    this.activeId,
    this.collapsed = false,
    this.onItemTap,
    this.onCollapsedToggle,
    this.title,
    this.header,
    this.footer,
    this.width = 224,
    this.collapsedWidth = 72,
    this.showCollapseToggle = false,
    this.semanticLabel = 'Sidebar menu',
    this.backgroundColor,
  })  : assert(width > 0),
        assert(collapsedWidth > 0),
        assert(items.length > 0, 'Declara al menos un item para el sidebar.');

  /// Items renderizados en la seccion principal.
  final List<ModelDsSidebarMenuItem> items;

  /// Item activo actual.
  final String? activeId;

  /// Modo visual colapsado o expandido.
  final bool collapsed;

  /// Callback al presionar un item habilitado.
  final ValueChanged<String>? onItemTap;

  /// Callback para alternar `collapsed` cuando se usa el toggle interno.
  final ValueChanged<bool>? onCollapsedToggle;

  /// Titulo textual opcional para el bloque superior.
  final String? title;

  /// Slot opcional para contenido custom en la cabecera.
  final Widget? header;

  /// Slot opcional para contenido custom en el pie.
  final Widget? footer;

  /// Ancho cuando esta expandido.
  final double width;

  /// Ancho cuando esta colapsado.
  final double collapsedWidth;

  /// Muestra el control de colapsar/expandir.
  final bool showCollapseToggle;

  /// Etiqueta de accesibilidad del contenedor completo.
  final String semanticLabel;

  /// Override opcional del color de fondo.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final double resolvedWidth = collapsed ? collapsedWidth : width;

    return Semantics(
      container: true,
      label: semanticLabel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: resolvedWidth,
        decoration: BoxDecoration(
          color: backgroundColor ?? scheme.primary,
          borderRadius: BorderRadius.zero,
          border: Border.all(
            color: scheme.primaryContainer.withValues(alpha: 0.55),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(PragmaSpacing.sm),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget itemsList = ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: !constraints.hasBoundedHeight,
                physics: constraints.hasBoundedHeight
                    ? null
                    : const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: PragmaSpacing.xs),
                itemBuilder: (BuildContext context, int index) {
                  final ModelDsSidebarMenuItem item = items[index];
                  return _SidebarMenuTile(
                    item: item,
                    collapsed: collapsed,
                    active: activeId == item.id,
                    onTap: item.enabled ? () => onItemTap?.call(item.id) : null,
                  );
                },
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _SidebarHeader(
                    collapsed: collapsed,
                    title: title,
                    header: header,
                    onCollapsedToggle:
                        showCollapseToggle ? onCollapsedToggle : null,
                  ),
                  const SizedBox(height: PragmaSpacing.md),
                  if (constraints.hasBoundedHeight)
                    Expanded(child: itemsList)
                  else
                    itemsList,
                  if (footer != null) ...<Widget>[
                    const SizedBox(height: PragmaSpacing.md),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: scheme.onPrimary.withValues(alpha: 0.24),
                    ),
                    const SizedBox(height: PragmaSpacing.sm),
                    footer!,
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader({
    required this.collapsed,
    this.title,
    this.header,
    this.onCollapsedToggle,
  });

  final bool collapsed;
  final String? title;
  final Widget? header;
  final ValueChanged<bool>? onCollapsedToggle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    const Widget brandIsotype = _SidebarBrandIsotype();

    final Widget defaultHeader;
    if (collapsed) {
      defaultHeader = title == null
          ? brandIsotype
          : PragmaTooltipWidget(
              message: title!,
              placement: PragmaTooltipPlacement.right,
              child: brandIsotype,
            );
    } else {
      defaultHeader = Row(
        children: <Widget>[
          brandIsotype,
          const SizedBox(width: PragmaSpacing.xs),
          Container(
            width: 1,
            height: 18,
            color: scheme.onPrimary.withValues(alpha: 0.45),
          ),
          const SizedBox(width: PragmaSpacing.xs),
          Expanded(
            child: title == null
                ? const SizedBox.shrink()
                : Text(
                    title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ],
      );
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: header ?? defaultHeader,
        ),
        if (onCollapsedToggle != null)
          IconButton(
            tooltip: collapsed ? 'Expandir menu' : 'Colapsar menu',
            onPressed: () => onCollapsedToggle!.call(!collapsed),
            visualDensity: VisualDensity.compact,
            icon: Icon(
              collapsed ? Icons.chevron_right : Icons.chevron_left,
              color: scheme.onPrimary,
              size: 20,
            ),
          ),
      ],
    );
  }
}

class _SidebarBrandIsotype extends StatelessWidget {
  const _SidebarBrandIsotype();

  @override
  Widget build(BuildContext context) {
    final ThemeData baseTheme = Theme.of(context);
    return SizedBox(
      width: 28,
      height: 28,
      child: Theme(
        data: baseTheme.copyWith(brightness: Brightness.dark),
        child: const PragmaLogoWidget(
          width: 28,
          variant: PragmaLogoVariant.isotypeCircle,
          margin: EdgeInsets.zero,
          alignment: Alignment.center,
          semanticLabel: 'Pragma imagotipo',
        ),
      ),
    );
  }
}

class _SidebarMenuTile extends StatelessWidget {
  const _SidebarMenuTile({
    required this.item,
    required this.collapsed,
    required this.active,
    required this.onTap,
  });

  final ModelDsSidebarMenuItem item;
  final bool collapsed;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool enabled = onTap != null;

    final Color foreground = enabled
        ? (active ? scheme.onPrimary : scheme.onPrimary.withValues(alpha: 0.88))
        : scheme.onPrimary.withValues(alpha: 0.45);

    final Color baseBackground = active
        ? scheme.primaryContainer.withValues(alpha: 0.35)
        : Colors.transparent;

    final BorderRadius borderRadius = PragmaBorderRadius.circularToken(
      PragmaBorderRadiusTokens.m,
    );

    Widget tile = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactMode = collapsed || constraints.maxWidth < 112;

        return Semantics(
          button: true,
          selected: active,
          enabled: enabled,
          label: item.semanticLabel ?? item.label,
          onTap: onTap,
          child: ExcludeSemantics(
            child: TextButton(
              onPressed: onTap,
              style: ButtonStyle(
                alignment:
                    compactMode ? Alignment.center : Alignment.centerLeft,
                padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                    horizontal:
                        compactMode ? PragmaSpacing.xs : PragmaSpacing.sm,
                    vertical: PragmaSpacing.xs,
                  ),
                ),
                shape: WidgetStatePropertyAll<OutlinedBorder>(
                  RoundedRectangleBorder(borderRadius: borderRadius),
                ),
                minimumSize: const WidgetStatePropertyAll<Size>(Size.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return scheme.primaryContainer.withValues(alpha: 0.4);
                    }
                    if (states.contains(WidgetState.hovered) ||
                        states.contains(WidgetState.focused)) {
                      return scheme.primaryContainer.withValues(alpha: 0.28);
                    }
                    return baseBackground;
                  },
                ),
                foregroundColor: WidgetStatePropertyAll<Color>(foreground),
                overlayColor: WidgetStatePropertyAll<Color>(
                  scheme.onPrimary.withValues(alpha: 0.06),
                ),
                side: WidgetStateProperty.resolveWith<BorderSide?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.focused)) {
                      return BorderSide(
                        color: scheme.onPrimary.withValues(alpha: 0.85),
                        width: 1.6,
                      );
                    }
                    if (active) {
                      return BorderSide(
                        color: scheme.onPrimary.withValues(alpha: 0.2),
                        width: 1.2,
                      );
                    }
                    return const BorderSide(
                      color: Colors.transparent,
                      width: 1.2,
                    );
                  },
                ),
              ),
              child: Row(
                mainAxisAlignment: compactMode
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    _SidebarIconResolver.resolve(item.iconToken),
                    size: 20,
                  ),
                  if (!compactMode) ...<Widget>[
                    const SizedBox(width: PragmaSpacing.xs),
                    Expanded(
                      child: Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight:
                              active ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );

    if (collapsed) {
      tile = PragmaTooltipWidget(
        message: item.label,
        placement: PragmaTooltipPlacement.right,
        child: tile,
      );
    }

    return tile;
  }
}

class _SidebarIconResolver {
  const _SidebarIconResolver._();

  static IconData resolve(DsSidebarIconToken token) {
    switch (token) {
      case DsSidebarIconToken.dashboard:
        return Icons.space_dashboard_outlined;
      case DsSidebarIconToken.projects:
        return Icons.folder_open_outlined;
      case DsSidebarIconToken.reports:
        return Icons.analytics_outlined;
      case DsSidebarIconToken.settings:
        return Icons.settings_outlined;
      case DsSidebarIconToken.back:
        return Icons.arrow_back;
      case DsSidebarIconToken.home:
        return Icons.home_outlined;
      case DsSidebarIconToken.analytics:
        return Icons.insights_outlined;
      case DsSidebarIconToken.lock:
        return Icons.lock_outline;
    }
  }
}
