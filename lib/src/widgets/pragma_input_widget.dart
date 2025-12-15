import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../domain/models/model_field_state.dart';
import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';

/// Visual variants supported by [PragmaInputWidget].
enum PragmaInputVariant { filled, tonal, outlined }

/// Density presets for [PragmaInputWidget].
enum PragmaInputSize { regular, dense }

/// Controller that exposes helper methods to mutate the field state.
class PragmaInputController extends ValueNotifier<ModelFieldState> {
  PragmaInputController([ModelFieldState? state])
      : super(state ?? ModelFieldState.empty);

  /// Updates the current value and optionally marks the field as dirty.
  void setValue(String value, {bool markDirty = true}) {
    update(
      (ModelFieldState state) => state.copyWith(
        value: value,
        isDirty: markDirty || state.isDirty,
      ),
    );
  }

  /// Replaces the active suggestions list.
  void setSuggestions(List<String> suggestions) {
    update((ModelFieldState state) => state.copyWith(suggestions: suggestions));
  }

  /// Sets or clears the current error message.
  void setError(String? errorText) {
    update((ModelFieldState state) => state.copyWith(errorText: errorText));
  }

  /// Updates the validation flags.
  void setValidation({bool? isValid, bool? isDirty}) {
    update(
      (ModelFieldState state) => state.copyWith(
        isValid: isValid ?? state.isValid,
        isDirty: isDirty ?? state.isDirty,
      ),
    );
  }

  /// Resets the notifier to the provided state (or empty state).
  void reset([ModelFieldState? state]) {
    value = state ?? ModelFieldState.empty;
  }

  /// Applies a custom reducer to the current state.
  void update(ModelFieldState Function(ModelFieldState state) reducer) {
    value = reducer(value);
  }
}

/// Text field that follows the Pragma visual language with autocomplete
/// suggestions, validation feedback, and optional password toggle.
class PragmaInputWidget extends StatefulWidget {
  const PragmaInputWidget({
    required this.label,
    required this.controller,
    super.key,
    this.placeholder,
    this.helperText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.variant = PragmaInputVariant.filled,
    this.size = PragmaInputSize.regular,
    this.obscureText = false,
    this.enablePasswordToggle = false,
    this.enableSuggestions = true,
    this.leading,
    this.trailing,
    this.focusNode,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.textInputAction,
    this.autofillHints,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onSuggestionSelected,
    this.suggestionsMaxHeight = 240,
  });

  /// Label displayed inside the input decoration.
  final String label;

  /// Notifier that holds the current field state.
  final PragmaInputController controller;

  /// Optional placeholder text shown when the field is empty.
  final String? placeholder;

  /// Helper copy displayed when there is no error.
  final String? helperText;

  /// Whether the field is interactive.
  final bool enabled;

  /// Whether the field only allows read operations.
  final bool readOnly;

  /// Autofocuses the field on build.
  final bool autofocus;

  /// Visual variant that sets fill and border tokens.
  final PragmaInputVariant variant;

  /// Density preset for the padding.
  final PragmaInputSize size;

  /// Whether the text is obscured (password fields).
  final bool obscureText;

  /// Displays a trailing toggle icon that flips [obscureText].
  final bool enablePasswordToggle;

  /// Enables the autocomplete overlay based on controller suggestions.
  final bool enableSuggestions;

  /// Optional prefix widget.
  final Widget? leading;

  /// Optional trailing widget rendered after the text.
  final Widget? trailing;

  /// External focus node (one is created automatically otherwise).
  final FocusNode? focusNode;

  /// Text configuration hooks.
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final int maxLines;
  final int? minLines;
  final int? maxLength;

  /// Field callbacks.
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSuggestionSelected;

  /// Max height for the suggestions overlay panel.
  final double suggestionsMaxHeight;

  @override
  State<PragmaInputWidget> createState() => _PragmaInputWidgetState();
}

class _PragmaInputWidgetState extends State<PragmaInputWidget> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  late TextEditingController _textController;
  FocusNode? _internalFocusNode;
  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;
  OverlayEntry? _overlayEntry;
  bool _obscureText = false;
  List<String> _filteredSuggestions = <String>[];
  Size _fieldSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.controller.value.value,
    );
    _obscureText = widget.obscureText;
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
    }
    _focusNode.addListener(_handleFocusChanged);
    widget.controller.addListener(_handleControllerChanged);
    _filteredSuggestions = widget.controller.value.suggestions;
    _updateFilteredSuggestions();
  }

  @override
  void didUpdateWidget(covariant PragmaInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
      _textController
        ..text = widget.controller.value.value
        ..selection = TextSelection.collapsed(
          offset: widget.controller.value.value.length,
        );
      _filteredSuggestions = widget.controller.value.suggestions;
      _refreshOverlay(forceRebuild: true);
    }

    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
      if (oldWidget.focusNode == null && widget.focusNode != null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      } else if (widget.focusNode == null && _internalFocusNode == null) {
        _internalFocusNode = FocusNode();
      }
      _focusNode.addListener(_handleFocusChanged);
    }

    if (!widget.enablePasswordToggle) {
      _obscureText = widget.obscureText;
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    widget.controller.removeListener(_handleControllerChanged);
    _focusNode.removeListener(_handleFocusChanged);
    _internalFocusNode?.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    _refreshOverlay();
  }

  void _handleControllerChanged() {
    if (!mounted) {
      return;
    }
    final ModelFieldState state = widget.controller.value;
    if (_textController.text != state.value) {
      _textController
        ..text = state.value
        ..selection = TextSelection.collapsed(offset: state.value.length);
    }
    _updateFilteredSuggestions(scheduleOverlayUpdate: true);
    setState(() {});
  }

  void _handleTextChanged(String value) {
    widget.controller.setValue(value);
    widget.onChanged?.call(value);
    _updateFilteredSuggestions(scheduleOverlayUpdate: true);
  }

  void _handleFieldSizeUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final BuildContext? context = _fieldKey.currentContext;
      final RenderBox? box = context?.findRenderObject() as RenderBox?;
      final Size? size = box?.size;
      if (size == null || size == _fieldSize) {
        return;
      }
      setState(() => _fieldSize = size);
      _overlayEntry?.markNeedsBuild();
    });
  }

  void _updateFilteredSuggestions({bool scheduleOverlayUpdate = false}) {
    final List<String> base = widget.controller.value.suggestions;
    final String query = _textController.text.trim().toLowerCase();
    final List<String> filtered = query.isEmpty
        ? base
        : base
            .where(
              (String suggestion) => suggestion.toLowerCase().contains(query),
            )
            .toList(growable: false);
    if (!listEquals(filtered, _filteredSuggestions)) {
      _filteredSuggestions = filtered;
      if (mounted) {
        setState(() {});
      }
    }
    if (scheduleOverlayUpdate) {
      _refreshOverlay();
    }
  }

  void _refreshOverlay({bool forceRebuild = false}) {
    if (!widget.enableSuggestions) {
      _removeOverlay();
      return;
    }
    final bool shouldShow =
        _focusNode.hasFocus && _filteredSuggestions.isNotEmpty;
    if (!shouldShow) {
      _removeOverlay();
      return;
    }
    if (_overlayEntry == null) {
      _overlayEntry = _buildOverlay();
      final OverlayState overlay = Overlay.of(
        context,
        debugRequiredFor: widget,
      );
      overlay.insert(_overlayEntry!);
      return;
    }
    if (forceRebuild) {
      _overlayEntry!.markNeedsBuild();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _buildOverlay() {
    return OverlayEntry(
      builder: (BuildContext context) {
        final ThemeData theme = Theme.of(context);
        final ColorScheme colorScheme = theme.colorScheme;
        final Size screenSize = MediaQuery.sizeOf(context);
        final double width =
            _fieldSize.width == 0 ? screenSize.width * 0.6 : _fieldSize.width;
        final double height = _fieldSize.height == 0 ? 64 : _fieldSize.height;

        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeOverlay,
                behavior: HitTestBehavior.translucent,
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, height + 6),
              child: Material(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: widget.suggestionsMaxHeight,
                    minWidth: width,
                  ),
                  child: _SuggestionPanel(
                    suggestions: _filteredSuggestions,
                    colorScheme: colorScheme,
                    onSelected: _handleSuggestionSelected,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleSuggestionSelected(String value) {
    widget.controller.setValue(value);
    widget.onSuggestionSelected?.call(value);
    widget.onChanged?.call(value);
    _textController
      ..text = value
      ..selection = TextSelection.collapsed(offset: value.length);
    _updateFilteredSuggestions(scheduleOverlayUpdate: true);
    _removeOverlay();
  }

  void _toggleObscure() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final ModelFieldState state = widget.controller.value;
    final bool hasError = state.hasError;
    final bool showSuccess =
        !hasError && state.isDirty && state.isValid && !widget.readOnly;

    final _PragmaInputColors colors = _PragmaInputColors.resolve(
      colorScheme: colorScheme,
      variant: widget.variant,
      enabled: widget.enabled,
      hasError: hasError,
      showSuccess: showSuccess,
    );

    _handleFieldSizeUpdate();

    final InputDecoration decoration = InputDecoration(
      labelText: widget.label,
      helperText: hasError ? null : widget.helperText,
      errorText: state.errorText,
      hintText: widget.placeholder,
      prefixIcon: widget.leading,
      suffixIcon: _buildSuffixIcon(colorScheme),
      suffixIconConstraints: const BoxConstraints(),
      filled: true,
      fillColor: colors.fillColor,
      contentPadding: _PragmaInputMetrics.contentPadding(widget.size),
    ).applyDefaults(theme.inputDecorationTheme).copyWith(
          enabled: widget.enabled,
          enabledBorder: _PragmaInputMetrics.inputBorder(colors.enabledBorder),
          focusedBorder: _PragmaInputMetrics.inputBorder(colors.focusedBorder),
          disabledBorder:
              _PragmaInputMetrics.inputBorder(colors.disabledBorder),
          errorBorder: _PragmaInputMetrics.inputBorder(colorScheme.error),
          focusedErrorBorder:
              _PragmaInputMetrics.inputBorder(colorScheme.error),
        );

    final bool obscureText =
        widget.enablePasswordToggle ? _obscureText : widget.obscureText;

    return CompositedTransformTarget(
      link: _layerLink,
      child: KeyedSubtree(
        key: _fieldKey,
        child: TextField(
          controller: _textController,
          focusNode: _focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          obscureText: obscureText,
          style: textTheme.bodyLarge,
          decoration: decoration,
          onChanged: _handleTextChanged,
          onSubmitted: widget.onSubmitted,
          onEditingComplete: widget.onEditingComplete,
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon(ColorScheme scheme) {
    final List<Widget> children = <Widget>[];
    if (widget.trailing != null) {
      children.add(widget.trailing!);
    }
    if (widget.enablePasswordToggle) {
      children.add(
        IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          tooltip: _obscureText ? 'Mostrar texto' : 'Ocultar texto',
          color: scheme.onSurfaceVariant,
          onPressed: widget.enabled ? _toggleObscure : null,
        ),
      );
    }
    if (children.isEmpty) {
      return null;
    }
    if (children.length == 1) {
      return children.first;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children
          .map(
            (Widget child) => Padding(
              padding: const EdgeInsets.only(right: PragmaSpacing.xs),
              child: child,
            ),
          )
          .toList(growable: false),
    );
  }
}

class _PragmaInputMetrics {
  const _PragmaInputMetrics._();

  static EdgeInsets contentPadding(PragmaInputSize size) {
    switch (size) {
      case PragmaInputSize.dense:
        return PragmaSpacing.insetSymmetric(
          horizontal: PragmaSpacing.md,
          vertical: PragmaSpacing.sm,
        );
      case PragmaInputSize.regular:
        return PragmaSpacing.insetSymmetric(
          horizontal: PragmaSpacing.lg,
          vertical: PragmaSpacing.md,
        );
    }
  }

  static OutlineInputBorder inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(PragmaBorderRadius.l),
      borderSide: BorderSide(color: color, width: 2),
    );
  }
}

class _PragmaInputColors {
  const _PragmaInputColors({
    required this.fillColor,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.disabledBorder,
  });

  final Color fillColor;
  final Color enabledBorder;
  final Color focusedBorder;
  final Color disabledBorder;

  static _PragmaInputColors resolve({
    required ColorScheme colorScheme,
    required PragmaInputVariant variant,
    required bool enabled,
    required bool hasError,
    required bool showSuccess,
  }) {
    final Color baseFill;
    switch (variant) {
      case PragmaInputVariant.filled:
        baseFill = colorScheme.surface;
        break;
      case PragmaInputVariant.tonal:
        baseFill = colorScheme.secondaryContainer;
        break;
      case PragmaInputVariant.outlined:
        baseFill = colorScheme.surface;
        break;
    }

    final Color resolvedBorder = hasError
        ? colorScheme.error
        : showSuccess
            ? colorScheme.secondary
            : colorScheme.primary;

    final Color enabledBorder = variant == PragmaInputVariant.outlined
        ? colorScheme.outline
        : resolvedBorder;

    return _PragmaInputColors(
      fillColor: enabled ? baseFill : colorScheme.surfaceContainerHighest,
      enabledBorder: enabled ? enabledBorder : colorScheme.surfaceContainerHigh,
      focusedBorder: resolvedBorder,
      disabledBorder: colorScheme.surfaceContainerHigh,
    );
  }
}

class _SuggestionPanel extends StatelessWidget {
  const _SuggestionPanel({
    required this.suggestions,
    required this.colorScheme,
    required this.onSelected,
  });

  final List<String> suggestions;
  final ColorScheme colorScheme;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(PragmaBorderRadius.l),
        border: Border.all(color: colorScheme.primary, width: 2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PragmaBorderRadius.l - 2),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: PragmaSpacing.xs),
          shrinkWrap: true,
          itemCount: suggestions.length,
          separatorBuilder: (_, __) => const SizedBox(height: PragmaSpacing.xs),
          itemBuilder: (BuildContext context, int index) {
            final String suggestion = suggestions[index];
            return ListTile(
              dense: true,
              title: Text(suggestion),
              onTap: () => onSelected(suggestion),
            );
          },
        ),
      ),
    );
  }
}
