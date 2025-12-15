import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';
import 'pragma_dropdown_option.dart';

/// Multi-select dropdown that mirrors the Pragma visual language with
/// checkboxes, optional icons, and trailing removal gestures.
class PragmaDropdownListWidget<T> extends StatefulWidget {
  PragmaDropdownListWidget({
    required this.label,
    required this.options,
    required this.onSelectionChanged,
    super.key,
    List<T>? initialSelectedValues,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.showCheckbox = true,
    this.showOptionIcons = true,
    this.showRemoveAction = true,
    this.optionBuilder,
    this.summaryBuilder,
    this.onItemRemoved,
    this.focusNode,
    this.menuMaxHeight,
  }) : initialSelectedValues =
            List<T>.unmodifiable(initialSelectedValues ?? <T>[]);

  /// Label displayed inside the field decoration.
  final String label;

  /// Available options to render inside the dropdown.
  final List<PragmaDropdownOption<T>> options;

  /// Callback with the updated selection every time an option toggles.
  final ValueChanged<List<T>> onSelectionChanged;

  /// Initial set of selected values. If the parent rebuilds with a different
  /// list, the widget syncs the internal selection automatically.
  final List<T> initialSelectedValues;

  /// Placeholder text used when no element is selected.
  final String? placeholder;

  /// Helper/error copy displayed under the field.
  final String? helperText;
  final String? errorText;

  /// Whether the field is interactive.
  final bool enabled;

  /// Shows a checkbox to the left of each option.
  final bool showCheckbox;

  /// Whether option icons (if provided) should appear.
  final bool showOptionIcons;

  /// Shows a trailing remove (X) action per option when
  /// [onItemRemoved] is provided.
  final bool showRemoveAction;

  /// Optional builder to customize the label/content of each option.
  final Widget Function(
    BuildContext context,
    PragmaDropdownOption<T> option,
    bool isSelected,
  )? optionBuilder;

  /// Builder that can override the summary rendered inside the field once
  /// multiple items are selected.
  final Widget Function(
    BuildContext context,
    List<PragmaDropdownOption<T>> selectedOptions,
  )? summaryBuilder;

  /// Invoked when the trailing remove icon is tapped.
  final ValueChanged<T>? onItemRemoved;

  /// Optional focus node that clients can manage externally.
  final FocusNode? focusNode;

  /// Max height for the dropdown list overlay.
  final double? menuMaxHeight;

  @override
  State<PragmaDropdownListWidget<T>> createState() =>
      _PragmaDropdownListWidgetState<T>();
}

class _PragmaDropdownListWidgetState<T>
    extends State<PragmaDropdownListWidget<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  Size _fieldSize = Size.zero;
  late Set<T> _selectedValues;
  bool _overlayRebuildScheduled = false;

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.initialSelectedValues.toSet();
  }

  @override
  void didUpdateWidget(covariant PragmaDropdownListWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!setEquals(
      oldWidget.initialSelectedValues.toSet(),
      widget.initialSelectedValues.toSet(),
    )) {
      _selectedValues = widget.initialSelectedValues.toSet();
      _scheduleOverlayRebuild();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleOverlay() {
    if (!widget.enabled) {
      return;
    }
    if (_overlayEntry == null) {
      _openOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _openOverlay() {
    final RenderBox box = context.findRenderObject()! as RenderBox;
    _fieldSize = box.size;
    _overlayEntry = _buildOverlay();
    final OverlayState overlay = Overlay.of(
      context,
      debugRequiredFor: widget,
    );
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _scheduleOverlayRebuild() {
    if (!mounted || _overlayEntry == null || _overlayRebuildScheduled) {
      return;
    }
    _overlayRebuildScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayRebuildScheduled = false;
      if (!mounted) {
        return;
      }
      _overlayEntry?.markNeedsBuild();
    });
  }

  void _toggleSelection(T value) {
    final Set<T> next = Set<T>.from(_selectedValues);
    if (!next.add(value)) {
      next.remove(value);
    }
    setState(() => _selectedValues = next);
    _scheduleOverlayRebuild();
    widget.onSelectionChanged(next.toList(growable: false));
  }

  void _handleRemove(T value) {
    if (!_selectedValues.contains(value)) {
      widget.onItemRemoved?.call(value);
      return;
    }
    final Set<T> next = Set<T>.from(_selectedValues)..remove(value);
    setState(() => _selectedValues = next);
    _scheduleOverlayRebuild();
    widget.onSelectionChanged(next.toList(growable: false));
    widget.onItemRemoved?.call(value);
  }

  OverlayEntry _buildOverlay() {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final double maxHeight = widget.menuMaxHeight ?? 320;

    return OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeOverlay,
                behavior: HitTestBehavior.translucent,
                child: const SizedBox.expand(),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, _fieldSize.height + 8),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: _fieldSize.width,
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(PragmaBorderRadius.l),
                    border: Border.all(color: colorScheme.primary, width: 2),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(PragmaBorderRadius.l - 2),
                    child: _DropdownListView<T>(
                      options: widget.options,
                      selectedValues: _selectedValues,
                      showCheckbox: widget.showCheckbox,
                      showIcons: widget.showOptionIcons,
                      showRemoveAction: widget.showRemoveAction &&
                          widget.onItemRemoved != null,
                      optionBuilder: widget.optionBuilder,
                      onToggle: _toggleSelection,
                      onRemove: _handleRemove,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final InputDecoration decoration = InputDecoration(
      labelText: widget.label,
      helperText: widget.errorText == null ? widget.helperText : null,
      errorText: widget.errorText,
      filled: true,
      fillColor: widget.enabled
          ? colorScheme.surface
          : colorScheme.surfaceContainerHigh,
      enabled: widget.enabled,
      enabledBorder:
          _PragmaDropdownListFieldMetrics.inputBorder(colorScheme.primary),
      focusedBorder:
          _PragmaDropdownListFieldMetrics.inputBorder(colorScheme.primary),
      disabledBorder: _PragmaDropdownListFieldMetrics.inputBorder(
        colorScheme.surfaceContainerHigh,
      ),
      errorBorder:
          _PragmaDropdownListFieldMetrics.inputBorder(colorScheme.error),
      focusedErrorBorder:
          _PragmaDropdownListFieldMetrics.inputBorder(colorScheme.error),
      contentPadding: _PragmaDropdownListFieldMetrics.contentPadding(false),
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: PragmaSpacing.sm),
        child: _DropdownCaretIcon(
          isExpanded: _overlayEntry != null,
          isDisabled: !widget.enabled,
        ),
      ),
    ).applyDefaults(theme.inputDecorationTheme);

    final List<PragmaDropdownOption<T>> selectedOptions = widget.options
        .where(
          (PragmaDropdownOption<T> option) =>
              _selectedValues.contains(option.value),
        )
        .toList();

    final Widget summary = widget.summaryBuilder?.call(
          context,
          selectedOptions,
        ) ??
        _DefaultSummary<T>(
          placeholder: widget.placeholder,
          selectedOptions: selectedOptions,
          textStyle:
              (textTheme.bodyLarge ?? const TextStyle(fontSize: 16)).copyWith(
            color: widget.enabled
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
          placeholderStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        );

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleOverlay,
        behavior: HitTestBehavior.opaque,
        child: InputDecorator(
          baseStyle: textTheme.bodyLarge,
          decoration: decoration,
          isFocused: _overlayEntry != null,
          isEmpty: selectedOptions.isEmpty,
          child: summary,
        ),
      ),
    );
  }
}

class _DefaultSummary<T> extends StatelessWidget {
  const _DefaultSummary({
    required this.placeholder,
    required this.selectedOptions,
    required this.textStyle,
    required this.placeholderStyle,
  });

  final String? placeholder;
  final List<PragmaDropdownOption<T>> selectedOptions;
  final TextStyle textStyle;
  final TextStyle? placeholderStyle;

  @override
  Widget build(BuildContext context) {
    if (selectedOptions.isEmpty) {
      return Text(
        placeholder ?? 'Selecciona opciones',
        style: placeholderStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    final String content = selectedOptions
        .map((PragmaDropdownOption<T> option) => option.label)
        .join(', ');
    return Text(
      content,
      style: textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _DropdownListView<T> extends StatelessWidget {
  const _DropdownListView({
    required this.options,
    required this.selectedValues,
    required this.showCheckbox,
    required this.showIcons,
    required this.showRemoveAction,
    required this.optionBuilder,
    required this.onToggle,
    required this.onRemove,
  });

  final List<PragmaDropdownOption<T>> options;
  final Set<T> selectedValues;
  final bool showCheckbox;
  final bool showIcons;
  final bool showRemoveAction;
  final Widget Function(
    BuildContext context,
    PragmaDropdownOption<T> option,
    bool isSelected,
  )? optionBuilder;
  final ValueChanged<T> onToggle;
  final ValueChanged<T> onRemove;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: PragmaSpacing.xs),
      itemCount: options.length,
      separatorBuilder: (_, __) => const SizedBox(height: PragmaSpacing.xs),
      itemBuilder: (BuildContext context, int index) {
        final PragmaDropdownOption<T> option = options[index];
        final bool isSelected = selectedValues.contains(option.value);
        return _DropdownListTile<T>(
          option: option,
          isSelected: isSelected,
          showCheckbox: showCheckbox,
          showIcon: showIcons && option.icon != null,
          showRemoveAction: showRemoveAction,
          optionBuilder: optionBuilder,
          onToggle: onToggle,
          onRemove: onRemove,
          colorScheme: colorScheme,
        );
      },
    );
  }
}

class _DropdownListTile<T> extends StatefulWidget {
  const _DropdownListTile({
    required this.option,
    required this.isSelected,
    required this.showCheckbox,
    required this.showIcon,
    required this.showRemoveAction,
    required this.optionBuilder,
    required this.onToggle,
    required this.onRemove,
    required this.colorScheme,
  });

  final PragmaDropdownOption<T> option;
  final bool isSelected;
  final bool showCheckbox;
  final bool showIcon;
  final bool showRemoveAction;
  final Widget Function(
    BuildContext context,
    PragmaDropdownOption<T> option,
    bool isSelected,
  )? optionBuilder;
  final ValueChanged<T> onToggle;
  final ValueChanged<T> onRemove;
  final ColorScheme colorScheme;

  @override
  State<_DropdownListTile<T>> createState() => _DropdownListTileState<T>();
}

class _DropdownListTileState<T> extends State<_DropdownListTile<T>> {
  bool _hovering = false;

  void _setHovering(bool value) {
    if (!mounted) {
      return;
    }
    setState(() => _hovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool disabled = !widget.option.enabled;
    final ColorScheme scheme = widget.colorScheme;
    final Color foreground = disabled
        ? scheme.onSurfaceVariant
        : widget.isSelected
            ? scheme.surface
            : scheme.primary;
    final Color background = disabled
        ? Colors.transparent
        : widget.isSelected
            ? scheme.primary
            : _hovering
                ? scheme.primary.withValues(alpha: 0.12)
                : Colors.transparent;

    final Widget label = widget.optionBuilder?.call(
          context,
          widget.option,
          widget.isSelected,
        ) ??
        Text(
          widget.option.label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: foreground,
                    height: 1.2,
                  ) ??
              TextStyle(color: foreground),
        );

    return MouseRegion(
      onEnter: (_) => _setHovering(true),
      onExit: (_) => _setHovering(false),
      child: GestureDetector(
        onTap: disabled ? null : () => widget.onToggle(widget.option.value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: PragmaSpacing.sm)
              .copyWith(top: PragmaSpacing.xxxs, bottom: PragmaSpacing.xxxs),
          padding: const EdgeInsets.symmetric(
            horizontal: PragmaSpacing.md,
            vertical: PragmaSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(PragmaBorderRadius.m),
            boxShadow: widget.isSelected
                ? <BoxShadow>[
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.showCheckbox)
                Padding(
                  padding: const EdgeInsets.only(right: PragmaSpacing.sm),
                  child: IgnorePointer(
                    ignoring: disabled,
                    child: Checkbox(
                      value: widget.isSelected,
                      onChanged: disabled
                          ? null
                          : (_) => widget.onToggle(widget.option.value),
                    ),
                  ),
                ),
              if (widget.showIcon)
                Padding(
                  padding: const EdgeInsets.only(right: PragmaSpacing.xs),
                  child: Icon(
                    widget.option.icon,
                    size: 18,
                    color: foreground,
                  ),
                ),
              Expanded(child: label),
              if (widget.showRemoveAction)
                Semantics(
                  button: true,
                  enabled: !disabled,
                  label: 'Eliminar ${widget.option.label}',
                  child: IconButton(
                    iconSize: 18,
                    tooltip: null,
                    onPressed: disabled
                        ? null
                        : () => widget.onRemove(widget.option.value),
                    icon: Icon(
                      Icons.close,
                      color: foreground,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownCaretIcon extends StatelessWidget {
  const _DropdownCaretIcon({
    required this.isExpanded,
    required this.isDisabled,
  });

  final bool isExpanded;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final double turns = isExpanded ? 0.5 : 0.0;
    final Color caretColor = isDisabled
        ? scheme.onSurfaceVariant.withValues(alpha: 0.5)
        : scheme.onSurfaceVariant;

    return AnimatedRotation(
      turns: turns,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest
              .withValues(alpha: isDisabled ? 0.4 : 0.8),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.expand_more_rounded,
          color: caretColor,
          size: 18,
        ),
      ),
    );
  }
}

class _PragmaDropdownListFieldMetrics {
  const _PragmaDropdownListFieldMetrics._();

  static EdgeInsets contentPadding(bool dense) {
    if (dense) {
      return PragmaSpacing.insetSymmetric(
        horizontal: PragmaSpacing.md,
        vertical: PragmaSpacing.sm,
      );
    }
    return PragmaSpacing.insetSymmetric(
      horizontal: PragmaSpacing.lg,
      vertical: PragmaSpacing.md,
    );
  }

  static OutlineInputBorder inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(PragmaBorderRadius.l),
      borderSide: BorderSide(color: color, width: 2),
    );
  }
}
