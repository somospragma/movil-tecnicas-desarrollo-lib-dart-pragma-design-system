import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';

/// Tonos soportados por [PragmaSearchWidget].
enum PragmaSearchTone { light, dark }

/// Tamaños disponibles para [PragmaSearchWidget].
enum PragmaSearchSize { small, large }

/// Campo de búsqueda que replica el glow morado y las variantes light/dark
/// descritas en la guía de diseño.
class PragmaSearchWidget extends StatefulWidget {
  const PragmaSearchWidget({
    super.key,
    this.controller,
    this.initialValue,
    this.placeholder = 'Buscar... ',
    this.enabled = true,
    this.autofocus = false,
    this.tone = PragmaSearchTone.dark,
    this.size = PragmaSearchSize.large,
    this.infoText,
    this.leading,
    this.trailing,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.semanticsLabel,
    this.semanticsHint,
  });

  /// Controlador externo opcional. Si no se provee se crea uno interno.
  final TextEditingController? controller;

  /// Valor inicial cuando se genera el controlador interno.
  final String? initialValue;

  /// Texto que aparece cuando no hay query.
  final String placeholder;

  /// Habilita o deshabilita el campo.
  final bool enabled;

  /// Define si debe tomar foco automáticamente.
  final bool autofocus;

  /// Tonalidad base.
  final PragmaSearchTone tone;

  /// Altura y densidad del campo.
  final PragmaSearchSize size;

  /// Mensaje informativo que aparece debajo del campo.
  final String? infoText;

  /// Widget opcional que se coloca antes del texto (chips, etiquetas).
  final Widget? leading;

  /// Acción personalizada que reemplaza el botón circular por defecto.
  final Widget? trailing;

  /// Nodo de foco externo.
  final FocusNode? focusNode;

  /// Callbacks para cambios y submit.
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  /// Etiquetas de accesibilidad.
  final String? semanticsLabel;
  final String? semanticsHint;

  @override
  State<PragmaSearchWidget> createState() => _PragmaSearchWidgetState();
}

class _PragmaSearchWidgetState extends State<PragmaSearchWidget> {
  late TextEditingController _controller;
  late bool _ownsController;
  FocusNode? _internalFocusNode;
  bool _isHovered = false;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ??
        TextEditingController(text: widget.initialValue ?? '');
    _controller.addListener(_handleControllerChanged);
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
    }
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant PragmaSearchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (_ownsController) {
        _controller.removeListener(_handleControllerChanged);
        if (oldWidget.controller == null) {
          _controller.dispose();
        }
      }
      _ownsController = widget.controller == null;
      _controller = widget.controller ??
          TextEditingController(text: widget.initialValue ?? '');
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final _PragmaSearchStyle style =
        _PragmaSearchStyle.resolve(scheme: scheme, tone: widget.tone);
    final _PragmaSearchMetrics metrics = _PragmaSearchMetrics(widget.size);

    final bool showGlow = widget.enabled && _isHovered;
    final bool showAccent =
        widget.enabled && (_focusNode.hasFocus || _hasValue || _isHovered);

    final Color innerColor = widget.enabled
        ? style.innerBackground
        : style.innerBackground.withValues(alpha: 0.4);

    final TextStyle textStyle = theme.textTheme.bodyLarge?.copyWith(
          fontSize: metrics.fontSize,
          color: widget.enabled
              ? style.textColor
              : style.textColor.withValues(alpha: 0.5),
        ) ??
        TextStyle(
          fontSize: metrics.fontSize,
          color: widget.enabled
              ? style.textColor
              : style.textColor.withValues(alpha: 0.5),
        );

    final Widget field = _buildField(textStyle, metrics, style);

    final Widget container = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: showAccent ? null : style.outerBackground,
          gradient: showAccent ? style.accentGradient : null,
          borderRadius: BorderRadius.circular(PragmaBorderRadius.xl),
          border: showAccent
              ? null
              : Border.all(color: style.frameColor, width: 1.5),
          boxShadow: showGlow ? style.glow : null,
        ),
        padding: const EdgeInsets.all(1.5),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: innerColor,
            borderRadius: BorderRadius.circular(PragmaBorderRadius.xl - 2),
          ),
          child: field,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        container,
        if (widget.infoText != null)
          Padding(
            padding: const EdgeInsets.only(top: PragmaSpacing.xs),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: widget.enabled
                      ? style.infoColor
                      : style.infoColor.withValues(alpha: 0.4),
                ),
                const SizedBox(width: PragmaSpacing.xxxs),
                Expanded(
                  child: Text(
                    widget.infoText!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: widget.enabled
                          ? style.infoColor
                          : style.infoColor.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildField(
    TextStyle textStyle,
    _PragmaSearchMetrics metrics,
    _PragmaSearchStyle style,
  ) {
    final Widget input = TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      textInputAction: TextInputAction.search,
      textAlignVertical: TextAlignVertical.center,
      style: textStyle,
      cursorColor: style.cursorColor,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.placeholder,
        hintStyle: textStyle.copyWith(color: style.placeholderColor),
        isCollapsed: true,
        contentPadding: EdgeInsets.zero,
      ),
      onChanged: (String value) {
        widget.onChanged?.call(value);
        setState(() {});
      },
      onSubmitted: widget.onSubmitted,
    );

    final Widget trailing = widget.trailing ??
        _SearchActionIcon(
          icon: _hasValue ? Icons.close : Icons.search,
          tooltip: _hasValue ? 'Limpiar búsqueda' : 'Buscar',
          onPressed: !widget.enabled
              ? null
              : _hasValue
                  ? _handleClear
                  : () => widget.onSubmitted?.call(_controller.text),
          style: style,
          size: metrics.iconContainerSize,
        );

    final Widget? leading = widget.leading;

    Widget content = Container(
      height: metrics.fieldHeight,
      padding: EdgeInsets.symmetric(horizontal: metrics.horizontalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (leading != null) ...<Widget>[
            DefaultTextStyle.merge(
              style: textStyle.copyWith(fontWeight: FontWeight.w600),
              child: leading,
            ),
            const SizedBox(width: PragmaSpacing.sm),
          ],
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: input,
            ),
          ),
          const SizedBox(width: PragmaSpacing.sm),
          trailing,
        ],
      ),
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

  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
    setState(() {});
  }
}

class _PragmaSearchMetrics {
  _PragmaSearchMetrics(this.size);

  final PragmaSearchSize size;

  double get fontSize => size == PragmaSearchSize.large ? 16 : 14;
  double get horizontalPadding =>
      size == PragmaSearchSize.large ? PragmaSpacing.lg : PragmaSpacing.md;
  double get fieldHeight => size == PragmaSearchSize.large ? 56 : 46;
  double get iconContainerSize => size == PragmaSearchSize.large ? 44 : 36;
}

class _PragmaSearchStyle {
  const _PragmaSearchStyle({
    required this.outerBackground,
    required this.innerBackground,
    required this.placeholderColor,
    required this.textColor,
    required this.iconColor,
    required this.disabledIconColor,
    required this.infoColor,
    required this.cursorColor,
    required this.frameColor,
    required this.accentGradient,
    required this.glow,
  });

  final Color outerBackground;
  final Color innerBackground;
  final Color placeholderColor;
  final Color textColor;
  final Color iconColor;
  final Color disabledIconColor;
  final Color infoColor;
  final Color cursorColor;
  final Color frameColor;
  final Gradient accentGradient;
  final List<BoxShadow> glow;

  static _PragmaSearchStyle resolve({
    required ColorScheme scheme,
    required PragmaSearchTone tone,
  }) {
    final bool isDark = tone == PragmaSearchTone.dark;
    final Color primary = scheme.primary;
    final Color accent = Color.lerp(primary, scheme.secondary, 0.45)!;
    return _PragmaSearchStyle(
      outerBackground: isDark ? scheme.surfaceContainerHighest : scheme.surface,
      innerBackground:
          isDark ? scheme.surface.withValues(alpha: 0.9) : scheme.surface,
      placeholderColor: isDark
          ? Colors.white.withValues(alpha: 0.6)
          : scheme.onSurfaceVariant,
      textColor: isDark ? Colors.white : scheme.onSurface,
      iconColor: isDark ? Colors.white : scheme.onSurface,
      disabledIconColor:
          (isDark ? Colors.white : scheme.onSurface).withValues(alpha: 0.5),
      infoColor: isDark ? Colors.white70 : scheme.primary,
      cursorColor: primary,
      frameColor:
          isDark ? Colors.white.withValues(alpha: 0.45) : scheme.primary,
      accentGradient: LinearGradient(
        colors: <Color>[primary, accent],
      ),
      glow: <BoxShadow>[
        BoxShadow(
          color: accent.withValues(alpha: 0.45),
          blurRadius: 32,
          offset: const Offset(0, 16),
        ),
      ],
    );
  }
}

class _SearchActionIcon extends StatelessWidget {
  const _SearchActionIcon({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.style,
    required this.size,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final _PragmaSearchStyle style;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    final Widget button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: enabled ? style.accentGradient : null,
        color: enabled ? null : style.innerBackground.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Icon(
        icon,
        color: enabled ? style.iconColor : style.disabledIconColor,
      ),
    );

    if (!enabled) {
      return button;
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Tooltip(message: tooltip, child: button),
      ),
    );
  }
}
