import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';

/// Stateful text area built with Pragma's glow, tones, and helper states.
class PragmaTextAreaWidget extends StatefulWidget {
  const PragmaTextAreaWidget({
    required this.label,
    super.key,
    this.controller,
    this.placeholder,
    this.description,
    this.errorText,
    this.successText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.minLines = 4,
    this.maxLines = 6,
    this.maxLength,
    this.showCounter = true,
    this.textCapitalization = TextCapitalization.sentences,
    this.keyboardType = TextInputType.multiline,
    this.textInputAction = TextInputAction.newline,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.semanticsLabel,
    this.semanticsHint,
  }) : assert(
          maxLines == null || maxLines >= minLines,
          'maxLines debe ser >= minLines',
        );

  /// Label displayed above the field.
  final String label;

  /// External controller. When null an internal controller is created.
  final TextEditingController? controller;

  /// Placeholder rendered when the field is empty.
  final String? placeholder;

  /// Optional descriptive copy shown below the field when there is no error.
  final String? description;

  /// Error message. When provided it overrides [description].
  final String? errorText;

  /// Success/help message. Rendered when there is no error.
  final String? successText;

  /// Enables or disables the widget.
  final bool enabled;

  /// Restricts the text edition while keeping the look.
  final bool readOnly;

  /// Requests focus automatically.
  final bool autofocus;

  /// External focus node hook.
  final FocusNode? focusNode;

  /// Minimum amount of lines displayed.
  final int minLines;

  /// Maximum amount of lines allowed. When null the field grows with content.
  final int? maxLines;

  /// Character limit, also used to render the counter.
  final int? maxLength;

  /// Toggles the character counter displayed next to the helper copy.
  final bool showCounter;

  /// Text configuration hooks.
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  /// Callbacks emitted by the inner [TextField].
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;

  /// Custom semantics overrides to improve accessibility descriptions.
  final String? semanticsLabel;
  final String? semanticsHint;

  @override
  State<PragmaTextAreaWidget> createState() => _PragmaTextAreaWidgetState();
}

class _PragmaTextAreaWidgetState extends State<PragmaTextAreaWidget> {
  late TextEditingController _controller;
  late bool _ownsController;
  FocusNode? _internalFocusNode;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleControllerChanged);
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
    }
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant PragmaTextAreaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (_ownsController) {
        _controller.removeListener(_handleControllerChanged);
        if (oldWidget.controller == null) {
          _controller.dispose();
        }
      }
      _ownsController = widget.controller == null;
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_handleControllerChanged);
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
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    if (widget.focusNode == null) {
      _internalFocusNode?.dispose();
    }
    _controller.removeListener(_handleControllerChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get _hasValue => _controller.text.trim().isNotEmpty;

  int get _currentLength => _controller.text.length;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme scheme = theme.colorScheme;
    final bool hasError =
        widget.errorText != null && widget.errorText!.isNotEmpty;
    final bool hasSuccess = !hasError &&
        widget.successText != null &&
        widget.successText!.isNotEmpty;
    final bool isFocused = _focusNode.hasFocus;

    final _PragmaTextAreaColors colors = _PragmaTextAreaColors.resolve(
      scheme: scheme,
      enabled: widget.enabled,
      hasError: hasError,
      hasSuccess: hasSuccess,
      isFilled: _hasValue,
    );

    final TextStyle baseTextStyle = textTheme.bodyLarge?.copyWith(
          color: widget.enabled
              ? colors.textColor
              : colors.textColor.withValues(alpha: 0.6),
        ) ??
        TextStyle(color: colors.textColor);
    final TextStyle placeholderStyle = baseTextStyle.copyWith(
      color: colors.placeholderColor,
    );

    final Widget field = TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      style: baseTextStyle,
      cursorColor: colors.cursorColor,
      decoration: InputDecoration(
        border: InputBorder.none,
        isCollapsed: true,
        contentPadding: EdgeInsets.zero,
        counterText: '',
        hintText: widget.placeholder,
        hintStyle: placeholderStyle,
      ),
      onChanged: (String value) {
        widget.onChanged?.call(value);
        setState(() {});
      },
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
    );

    final bool showAccent =
        widget.enabled && isFocused && !hasError && !hasSuccess;

    final Widget surface = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        gradient: showAccent ? colors.accentGradient : null,
        color: showAccent ? null : Colors.transparent,
        border: showAccent
            ? null
            : Border.all(color: colors.borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(PragmaBorderRadius.xl),
        boxShadow: showAccent ? colors.glow : null,
      ),
      padding: const EdgeInsets.all(2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: BorderRadius.circular(PragmaBorderRadius.xl - 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PragmaSpacing.lg,
            vertical: PragmaSpacing.md,
          ),
          child: field,
        ),
      ),
    );

    final Widget? footer =
        _buildFooter(textTheme, colors, hasError, hasSuccess);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.label,
          style: textTheme.labelLarge?.copyWith(color: colors.labelColor) ??
              TextStyle(color: colors.labelColor, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: PragmaSpacing.xs),
        surface,
        if (footer != null) ...<Widget>[
          const SizedBox(height: PragmaSpacing.xs),
          footer,
        ],
      ],
    );

    if (widget.semanticsLabel != null || widget.semanticsHint != null) {
      content = Semantics(
        label: widget.semanticsLabel,
        hint: widget.semanticsHint,
        container: true,
        child: content,
      );
    }

    return content;
  }

  Widget? _buildFooter(
    TextTheme textTheme,
    _PragmaTextAreaColors colors,
    bool hasError,
    bool hasSuccess,
  ) {
    String? supporting = widget.description;
    IconData? icon = Icons.info_outline;
    Color iconColor = colors.supportingColor;

    if (hasError) {
      supporting = widget.errorText;
      icon = Icons.error_outline;
      iconColor = colors.errorColor;
    } else if (hasSuccess) {
      supporting = widget.successText;
      icon = Icons.check_circle_outline;
      iconColor = colors.successColor;
    }

    if (supporting == null || supporting.isEmpty) {
      icon = null;
    }

    final List<Widget> rowChildren = <Widget>[];
    if (supporting != null && supporting.isNotEmpty) {
      rowChildren.addAll(<Widget>[
        Icon(icon ?? Icons.info_outline, size: 16, color: iconColor),
        const SizedBox(width: PragmaSpacing.xxxs),
        Expanded(
          child: Text(
            supporting,
            style: textTheme.bodySmall?.copyWith(color: iconColor) ??
                TextStyle(color: iconColor, fontSize: 12),
          ),
        ),
      ]);
    } else {
      rowChildren.add(const Spacer());
    }

    Widget? counter;
    if (widget.maxLength != null && widget.showCounter) {
      final String value = '$_currentLength/${widget.maxLength}';
      counter = Text(
        value,
        style: textTheme.labelSmall?.copyWith(color: colors.counterColor) ??
            TextStyle(color: colors.counterColor),
      );
    }

    if (rowChildren.isEmpty && counter == null) {
      return null;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (rowChildren.isNotEmpty) ...rowChildren,
        if (counter != null) ...<Widget>[
          if (rowChildren.isNotEmpty) const SizedBox(width: PragmaSpacing.sm),
          counter,
        ],
      ],
    );
  }
}

class _PragmaTextAreaColors {
  const _PragmaTextAreaColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.labelColor,
    required this.textColor,
    required this.placeholderColor,
    required this.cursorColor,
    required this.supportingColor,
    required this.errorColor,
    required this.successColor,
    required this.counterColor,
    required this.accentGradient,
    required this.glow,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color labelColor;
  final Color textColor;
  final Color placeholderColor;
  final Color cursorColor;
  final Color supportingColor;
  final Color errorColor;
  final Color successColor;
  final Color counterColor;
  final Gradient accentGradient;
  final List<BoxShadow> glow;

  static _PragmaTextAreaColors resolve({
    required ColorScheme scheme,
    required bool enabled,
    required bool hasError,
    required bool hasSuccess,
    required bool isFilled,
  }) {
    final Color baseBackground = scheme.surface;
    final Color filledBackground = scheme.primary.withValues(alpha: 0.05);
    final Color disabledBackground = scheme.surfaceContainerHighest;
    final Color errorBackground = scheme.errorContainer.withValues(alpha: 0.9);
    final Color successBackground =
        scheme.secondaryContainer.withValues(alpha: 0.9);

    Color background = baseBackground;
    if (!enabled) {
      background = disabledBackground;
    } else if (hasError) {
      background = errorBackground;
    } else if (hasSuccess) {
      background = successBackground;
    } else if (isFilled) {
      background = filledBackground;
    }

    Color borderColor = scheme.primary;
    if (!enabled) {
      borderColor = scheme.outlineVariant;
    } else if (hasError) {
      borderColor = scheme.error;
    } else if (hasSuccess) {
      borderColor = scheme.secondary;
    } else if (!isFilled) {
      borderColor = scheme.primary.withValues(alpha: 0.7);
    }

    final Color labelColor =
        enabled ? scheme.primary : scheme.primary.withValues(alpha: 0.5);
    final Color textColor =
        enabled ? scheme.onSurface : scheme.onSurface.withValues(alpha: 0.6);
    final Color placeholderColor = textColor.withValues(alpha: 0.4);

    final Gradient accentGradient = LinearGradient(
      colors: <Color>[
        scheme.primary,
        Color.lerp(scheme.primary, scheme.secondary, 0.45)!,
      ],
    );
    final List<BoxShadow> glow = <BoxShadow>[
      BoxShadow(
        color: scheme.primary.withValues(alpha: 0.35),
        blurRadius: 36,
        offset: const Offset(0, 20),
      ),
    ];

    return _PragmaTextAreaColors(
      backgroundColor: background,
      borderColor: borderColor,
      labelColor: labelColor,
      textColor: textColor,
      placeholderColor: placeholderColor,
      cursorColor: scheme.primary,
      supportingColor: scheme.primary,
      errorColor: scheme.error,
      successColor: scheme.secondary,
      counterColor: scheme.onSurfaceVariant,
      accentGradient: accentGradient,
      glow: glow,
    );
  }
}
