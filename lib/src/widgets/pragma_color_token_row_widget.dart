import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../domain/models/model_color_token.dart';
import '../tokens/pragma_spacing.dart';

/// Row-based widget that previews a [ModelColorToken] alongside its label and
/// editable hexadecimal value.
class PragmaColorTokenRowWidget extends StatefulWidget {
  const PragmaColorTokenRowWidget({
    required this.token,
    super.key,
    this.onChanged,
    this.enabled = true,
    this.previewSize = const Size(72, 48),
    this.hexFieldLabel,
  });

  /// Key applied to the leading preview container (useful for tests).
  static const Key previewKey = Key('pragma_color_token_row_preview');

  /// Key applied to the suffix preview box rendered inside the text field.
  static const Key suffixPreviewKey =
      Key('pragma_color_token_row_suffix_preview');

  /// Token rendered by the row.
  final ModelColorToken token;

  /// Callback invoked when the hex value changes and becomes valid.
  final ValueChanged<ModelColorToken>? onChanged;

  /// Whether the row is interactive.
  final bool enabled;

  /// Size of the leading color preview container.
  final Size previewSize;

  /// Custom label for the hex input field.
  final String? hexFieldLabel;

  @override
  State<PragmaColorTokenRowWidget> createState() =>
      _PragmaColorTokenRowWidgetState();
}

class _PragmaColorTokenRowWidgetState extends State<PragmaColorTokenRowWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  Color? _pendingPreviewColor;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _digitsFrom(widget.token.color));
    _focusNode = FocusNode();
    _pendingPreviewColor = _colorFromHex(widget.token.color);
  }

  @override
  void didUpdateWidget(covariant PragmaColorTokenRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.token.color != oldWidget.token.color) {
      final String digits = _digitsFrom(widget.token.color);
      if (_controller.text != digits) {
        _controller.value = TextEditingValue(
          text: digits,
          selection: TextSelection.collapsed(offset: digits.length),
        );
      }
      setState(() {
        _pendingPreviewColor = _colorFromHex(widget.token.color);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme scheme = theme.colorScheme;
    final Color previewColor = _pendingPreviewColor ??
        _colorFromHex(widget.token.color) ??
        scheme.surfaceContainerHighest;

    return Padding(
      padding: PragmaSpacing.insetSymmetric(
        horizontal: PragmaSpacing.md,
        vertical: PragmaSpacing.xs,
      ),
      child: Row(
        children: <Widget>[
          _buildPreviewBox(previewColor),
          const SizedBox(width: PragmaSpacing.md),
          Expanded(
            child: Text(
              widget.token.label,
              style: textTheme.titleMedium,
            ),
          ),
          const SizedBox(width: PragmaSpacing.md),
          SizedBox(
            width: 160,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              decoration: InputDecoration(
                labelText: widget.hexFieldLabel ?? 'Hexadecimal',
                prefixText: '#',
                suffixIcon: _buildSuffixPreview(previewColor, scheme),
              ),
              style: textTheme.bodyMedium,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.characters,
              autocorrect: false,
              enableSuggestions: false,
              onChanged: _handleHexChanged,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]')),
                LengthLimitingTextInputFormatter(8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewBox(Color color) {
    return Semantics(
      label: 'Color ${widget.token.label}',
      value: '#${_controller.text}',
      child: AnimatedContainer(
        key: PragmaColorTokenRowWidget.previewKey,
        duration: const Duration(milliseconds: 200),
        width: widget.previewSize.width,
        height: widget.previewSize.height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(PragmaSpacing.sm),
          border: Border.all(),
        ),
      ),
    );
  }

  Widget _buildSuffixPreview(Color color, ColorScheme scheme) {
    return Padding(
      padding: PragmaSpacing.insetSymmetric(
        horizontal: PragmaSpacing.xs,
        vertical: PragmaSpacing.xs,
      ),
      child: DecoratedBox(
        key: PragmaColorTokenRowWidget.suffixPreviewKey,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(PragmaSpacing.xs),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: const SizedBox(width: 28, height: 28),
      ),
    );
  }

  void _handleHexChanged(String value) {
    final String digits = value.toUpperCase();
    if (digits != value) {
      _controller.value = TextEditingValue(
        text: digits,
        selection: TextSelection.collapsed(offset: digits.length),
      );
    }

    final bool hasEnoughData = digits.length == 6 || digits.length == 8;
    if (!hasEnoughData) {
      setState(() {
        _pendingPreviewColor = null;
      });
      return;
    }

    final String normalized = '#$digits';
    final Color? parsed = _colorFromHex(normalized);
    if (parsed == null) {
      return;
    }

    setState(() {
      _pendingPreviewColor = parsed;
    });

    if (normalized != widget.token.color) {
      widget.onChanged?.call(
        widget.token.copyWith(color: normalized),
      );
    }
  }

  String _digitsFrom(String hex) {
    final String sanitized = hex.replaceAll('#', '').toUpperCase();
    if (sanitized.length > 8) {
      return sanitized.substring(0, 8);
    }
    return sanitized;
  }

  Color? _colorFromHex(String? value) {
    if (value == null) {
      return null;
    }
    final String digits = value.replaceAll('#', '').toUpperCase();
    try {
      if (digits.length == 6) {
        return Color(int.parse('0xFF$digits'));
      }
      if (digits.length == 8) {
        return Color(int.parse('0x$digits'));
      }
    } on FormatException {
      return null;
    }
    return null;
  }
}
