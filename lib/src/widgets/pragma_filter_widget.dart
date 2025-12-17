import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';
import 'pragma_button.dart';
import 'pragma_tag_widget.dart';

/// Elemento de filtrado con contador de resultados, overlay con opciones
/// y resumen de selecciones activas.
class PragmaFilterWidget extends StatefulWidget {
  const PragmaFilterWidget({
    required this.label,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    super.key,
    this.enabled = true,
    this.tone = PragmaFilterTone.dark,
    this.showSummaryTags = true,
    this.summaryLabel,
    this.showCounter = true,
    this.filterButtonLabel = 'Filtrar',
    this.clearButtonLabel = 'Limpiar',
    this.emptyPlaceholder = 'Sin opciones disponibles',
    this.helperText,
  }) : assert(options.length > 0, 'Declara al menos una opción.');

  /// Título del filtro.
  final String label;

  /// Opciones disponibles dentro del overlay.
  final List<PragmaFilterOption> options;

  /// Valores actualmente seleccionados.
  final Set<String> selectedValues;

  /// Callback que retorna el nuevo set cada vez que se aplica el filtro.
  final ValueChanged<Set<String>> onChanged;

  /// Controla si el filtro responde a interacciones.
  final bool enabled;

  /// Superficie (light/dark) para sincronizarlo con el contexto.
  final PragmaFilterTone tone;

  /// Muestra tags con los filtros activos.
  final bool showSummaryTags;

  /// Título opcional para el bloque de tags.
  final String? summaryLabel;

  /// Muestra u oculta el contador `(n)` junto al label.
  final bool showCounter;

  /// Texto del botón primario dentro del overlay.
  final String filterButtonLabel;

  /// Texto del botón "limpiar" dentro del overlay.
  final String clearButtonLabel;

  /// Texto mostrado cuando no hay opciones.
  final String emptyPlaceholder;

  /// Mensaje auxiliar que aparece en la parte superior del overlay.
  final String? helperText;

  @override
  State<PragmaFilterWidget> createState() => _PragmaFilterWidgetState();
}

class _PragmaFilterWidgetState extends State<PragmaFilterWidget>
    with WidgetsBindingObserver {
  final GlobalKey _anchorKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late Set<String> _pendingSelection = Set<String>.from(widget.selectedValues);
  void _refreshOverlay() => _overlayEntry?.markNeedsBuild();

  Map<String, PragmaFilterOption> get _optionMap {
    return <String, PragmaFilterOption>{
      for (final PragmaFilterOption option in widget.options)
        option.value: option,
    };
  }

  bool get _hasSelection => widget.selectedValues.isNotEmpty;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(PragmaFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!setEquals(widget.selectedValues, oldWidget.selectedValues) &&
        _overlayEntry == null) {
      _pendingSelection = Set<String>.from(widget.selectedValues);
    }
    if (!listEquals(widget.options, oldWidget.options) &&
        _overlayEntry != null) {
      _removeOverlay();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeOverlay();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (_overlayEntry != null) {
      _removeOverlay();
    }
  }

  void _toggleOverlay() {
    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    if (!widget.enabled) {
      return;
    }
    final RenderBox? box =
        _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      return;
    }
    final Offset origin = box.localToGlobal(Offset.zero);
    final Size size = box.size;
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double panelWidth = math.max(size.width, 320);
    final double maxHeight = math.min(mediaQuery.size.height * 0.5, 420);
    const double horizontalPadding = 16;
    final double left = math.max(
      mediaQuery.padding.left + horizontalPadding,
      math.min(
        origin.dx,
        mediaQuery.size.width - panelWidth - horizontalPadding,
      ),
    );
    final double top = math.min(
      origin.dy + size.height + 8,
      mediaQuery.size.height - maxHeight - horizontalPadding,
    );

    _pendingSelection = Set<String>.from(widget.selectedValues);
    final ThemeData theme = Theme.of(context);

    _overlayEntry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _removeOverlay,
              ),
            ),
            Positioned(
              left: left,
              top: top,
              width: panelWidth,
              child: Material(
                type: MaterialType.transparency,
                child: Theme(
                  data: theme,
                  child: _FilterPanel(
                    tone: widget.tone,
                    helperText: widget.helperText,
                    options: widget.options,
                    pendingSelection: _pendingSelection,
                    maxHeight: maxHeight,
                    emptyPlaceholder: widget.emptyPlaceholder,
                    filterButtonLabel: widget.filterButtonLabel,
                    clearButtonLabel: widget.clearButtonLabel,
                    enabled: widget.enabled,
                    onOptionToggled: (String value, bool selected) {
                      setState(() {
                        if (selected) {
                          _pendingSelection.add(value);
                        } else {
                          _pendingSelection.remove(value);
                        }
                      });
                      _refreshOverlay();
                    },
                    onApply: _handleApply,
                    onClear: _handleClear,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context, debugRequiredFor: widget).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleApply() {
    widget.onChanged(Set<String>.from(_pendingSelection));
    _removeOverlay();
  }

  void _handleClear() {
    widget.onChanged(<String>{});
    _removeOverlay();
  }

  void _handleRemoveTag(String value) {
    final Set<String> next = Set<String>.from(widget.selectedValues)
      ..remove(value);
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _FilterSurfaceStyle style = _FilterSurfaceStyle.resolve(
      scheme: theme.colorScheme,
      tone: widget.tone,
      enabled: widget.enabled,
    );
    final String label = widget.showCounter && _hasSelection
        ? '${widget.label} (${widget.selectedValues.length})'
        : widget.label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MouseRegion(
          cursor: widget.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            key: _anchorKey,
            onTap: widget.enabled ? _toggleOverlay : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: PragmaSpacing.lg,
                vertical: PragmaSpacing.xs,
              ),
              constraints: const BoxConstraints(minHeight: 48),
              decoration: BoxDecoration(
                color: style.background,
                gradient: style.gradient,
                borderRadius: BorderRadius.circular(PragmaBorderRadius.full),
                border: Border.all(color: style.borderColor, width: 1.5),
                boxShadow: style.shadow,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      label,
                      style: theme.textTheme.labelLarge?.copyWith(
                            color: style.foreground,
                            fontWeight: FontWeight.w600,
                          ) ??
                          TextStyle(
                            color: style.foreground,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(width: PragmaSpacing.xs),
                  Icon(
                    Icons.expand_more,
                    color: style.foreground,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.showSummaryTags && _hasSelection) ...<Widget>[
          const SizedBox(height: PragmaSpacing.xs),
          if (widget.summaryLabel != null)
            Padding(
              padding: const EdgeInsets.only(bottom: PragmaSpacing.xxs),
              child: Text(
                widget.summaryLabel!,
                style: theme.textTheme.labelLarge,
              ),
            ),
          Wrap(
            spacing: PragmaSpacing.xs,
            runSpacing: PragmaSpacing.xs,
            children: widget.selectedValues.map((String value) {
              final PragmaFilterOption? option = _optionMap[value];
              return PragmaTagWidget(
                label: option?.label ?? value,
                enabled: widget.enabled,
                onRemove: widget.enabled ? () => _handleRemoveTag(value) : null,
              );
            }).toList(growable: false),
          ),
        ],
      ],
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    required this.tone,
    required this.options,
    required this.pendingSelection,
    required this.maxHeight,
    required this.emptyPlaceholder,
    required this.filterButtonLabel,
    required this.clearButtonLabel,
    required this.enabled,
    required this.onOptionToggled,
    required this.onApply,
    required this.onClear,
    this.helperText,
  });

  final PragmaFilterTone tone;
  final List<PragmaFilterOption> options;
  final Set<String> pendingSelection;
  final double maxHeight;
  final String emptyPlaceholder;
  final String filterButtonLabel;
  final String clearButtonLabel;
  final bool enabled;
  final String? helperText;
  final void Function(String value, bool selected) onOptionToggled;
  final VoidCallback onApply;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _FilterPanelStyle style =
        _FilterPanelStyle.resolve(theme.colorScheme, tone);

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: style.background,
        gradient: style.gradient,
        borderRadius: BorderRadius.circular(PragmaBorderRadius.l),
        border: Border.all(color: style.borderColor, width: 1.5),
        boxShadow: style.shadow,
      ),
      padding: const EdgeInsets.all(PragmaSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (helperText != null) ...<Widget>[
            Text(
              helperText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: style.helperColor,
              ),
            ),
            const SizedBox(height: PragmaSpacing.sm),
          ],
          Expanded(
            child: options.isEmpty
                ? Center(
                    child: Text(
                      emptyPlaceholder,
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final PragmaFilterOption option = options[index];
                      final bool selected =
                          pendingSelection.contains(option.value);
                      return CheckboxListTile(
                        value: selected,
                        title: Text(option.label),
                        subtitle: option.description != null
                            ? Text(option.description!)
                            : null,
                        secondary: option.meta != null
                            ? Text(
                                option.meta!,
                                style: theme.textTheme.labelSmall,
                              )
                            : null,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: option.enabled && enabled
                            ? (bool? value) =>
                                onOptionToggled(option.value, value ?? false)
                            : null,
                      );
                    },
                  ),
          ),
          const SizedBox(height: PragmaSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: PragmaButton(
                  label: clearButtonLabel,
                  hierarchy: PragmaButtonHierarchy.tertiary,
                  onPressed: enabled ? onClear : null,
                ),
              ),
              const SizedBox(width: PragmaSpacing.sm),
              Expanded(
                child: PragmaPrimaryButton(
                  label: filterButtonLabel,
                  onPressed: enabled ? onApply : null,
                  size: PragmaButtonSize.small,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Representa cada opción del filtro.
@immutable
class PragmaFilterOption {
  const PragmaFilterOption({
    required this.value,
    required this.label,
    this.description,
    this.meta,
    this.enabled = true,
  });

  final String value;
  final String label;
  final String? description;
  final String? meta;
  final bool enabled;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is PragmaFilterOption &&
        other.value == value &&
        other.label == label &&
        other.description == description &&
        other.meta == meta &&
        other.enabled == enabled;
  }

  @override
  int get hashCode => Object.hash(value, label, description, meta, enabled);
}

/// Superficie disponible para el filtro.
enum PragmaFilterTone { light, dark }

class _FilterSurfaceStyle {
  const _FilterSurfaceStyle({
    required this.background,
    required this.borderColor,
    required this.foreground,
    this.gradient,
    this.shadow = const <BoxShadow>[],
  });

  final Color background;
  final Gradient? gradient;
  final Color borderColor;
  final Color foreground;
  final List<BoxShadow> shadow;

  static _FilterSurfaceStyle resolve({
    required ColorScheme scheme,
    required PragmaFilterTone tone,
    required bool enabled,
  }) {
    if (tone == PragmaFilterTone.light) {
      final Color fg = enabled ? scheme.onSurface : scheme.onSurfaceVariant;
      return _FilterSurfaceStyle(
        background: scheme.surface,
        borderColor: enabled
            ? scheme.primary.withValues(alpha: 0.6)
            : scheme.outlineVariant,
        foreground: fg,
        shadow: enabled
            ? <BoxShadow>[
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.18),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
            : const <BoxShadow>[],
      );
    }

    return _FilterSurfaceStyle(
      background: scheme.primary,
      gradient: LinearGradient(
        colors: <Color>[
          scheme.primary,
          Color.lerp(scheme.primary, scheme.secondary, 0.35)!,
        ],
      ),
      borderColor: scheme.onPrimary.withValues(alpha: 0.45),
      foreground: scheme.onPrimary,
      shadow: enabled
          ? <BoxShadow>[
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ]
          : const <BoxShadow>[],
    );
  }
}

class _FilterPanelStyle {
  const _FilterPanelStyle({
    required this.background,
    required this.borderColor,
    required this.shadow,
    required this.helperColor,
    this.gradient,
  });

  final Color background;
  final Gradient? gradient;
  final Color borderColor;
  final List<BoxShadow> shadow;
  final Color helperColor;

  static _FilterPanelStyle resolve(ColorScheme scheme, PragmaFilterTone tone) {
    if (tone == PragmaFilterTone.light) {
      return _FilterPanelStyle(
        background: scheme.surface,
        borderColor: scheme.outlineVariant,
        shadow: <BoxShadow>[
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.2),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
        helperColor: scheme.onSurfaceVariant,
      );
    }

    return _FilterPanelStyle(
      background: scheme.primary,
      gradient: LinearGradient(
        colors: <Color>[
          Color.lerp(scheme.primary, scheme.secondary, 0.15)!,
          Color.lerp(scheme.secondary, scheme.primary, 0.35)!,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderColor: scheme.onPrimary.withValues(alpha: 0.3),
      shadow: <BoxShadow>[
        BoxShadow(
          color: scheme.primary.withValues(alpha: 0.35),
          blurRadius: 28,
          spreadRadius: 2,
        ),
      ],
      helperColor: scheme.onPrimary.withValues(alpha: 0.9),
    );
  }
}
