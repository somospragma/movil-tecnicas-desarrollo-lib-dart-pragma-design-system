import 'package:flutter/foundation.dart';

/// Enumerates the serialized fields for [ModelColorToken].
enum ColorTokenEnum { label, color }

/// Immutable model that represents a single color token entry.
@immutable
class ModelColorToken {
  factory ModelColorToken({
    required String label,
    required String color,
  }) {
    return ModelColorToken._(
      label: label.trim(),
      color: _normalizeHex(color),
    );
  }

  /// Builds an instance from raw JSON.
  factory ModelColorToken.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return empty;
    }

    return ModelColorToken(
      label: _string(json[ColorTokenEnum.label.name]),
      color: _string(json[ColorTokenEnum.color.name]),
    );
  }

  const ModelColorToken._({
    required this.label,
    required this.color,
  });

  /// Empty token useful for placeholders.
  static const ModelColorToken empty = ModelColorToken._(
    label: '',
    color: '#000000',
  );

  /// Display label bound to the token.
  final String label;

  /// Hexadecimal color value (always uppercase and prefixed with `#`).
  final String color;

  /// Serializes this token to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ColorTokenEnum.label.name: label,
      ColorTokenEnum.color.name: color,
    };
  }

  /// Clones the instance overriding the provided attributes.
  ModelColorToken copyWith({
    String? label,
    String? color,
  }) {
    return ModelColorToken(
      label: label ?? this.label,
      color: color ?? this.color,
    );
  }

  /// Whether the current color string is a valid hex value (with optional alpha).
  bool get isValidHex => _isValidHex(color);

  @override
  String toString() => '${toJson()}';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ModelColorToken &&
            runtimeType == other.runtimeType &&
            label == other.label &&
            color == other.color;
  }

  @override
  int get hashCode => Object.hash(label, color);

  static String _string(dynamic value) {
    if (value is String) {
      return value;
    }
    if (value == null) {
      return '';
    }
    return value.toString();
  }

  static bool _isValidHex(String value) {
    return RegExp(r'^#[0-9A-F]{6}([0-9A-F]{2})?$').hasMatch(value);
  }

  static String _normalizeHex(String input) {
    if (input.isEmpty) {
      return '#000000';
    }

    final String digits =
        input.replaceAll(RegExp(r'[^0-9a-fA-F]'), '').toUpperCase();
    if (digits.isEmpty) {
      return '#000000';
    }

    String sanitized = digits;
    if (sanitized.length > 8) {
      sanitized = sanitized.substring(0, 8);
    }

    if (sanitized.length == 6 || sanitized.length == 8) {
      return '#$sanitized';
    }

    if (sanitized.length < 6) {
      sanitized = sanitized.padRight(6, '0');
      return '#$sanitized';
    }

    // Length is 7; trim to 6 to keep RGB consistent.
    return '#${sanitized.substring(0, 6)}';
  }
}
