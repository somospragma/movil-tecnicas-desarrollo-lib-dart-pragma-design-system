import 'package:flutter/foundation.dart';

/// Enumerates the serialized properties of [ModelFieldState].
enum FieldStateEnum {
  value,
  errorText,
  suggestions,
  isDirty,
  isValid,
}

/// Immutable model that represents the state of a text field.
///
/// The state stores the current value, optional error text, the available
/// autocomplete suggestions, and derived helpers to know if the field is dirty
/// or valid.
@immutable
class ModelFieldState {
  factory ModelFieldState({
    String value = '',
    String? errorText,
    List<String> suggestions = const <String>[],
    bool isDirty = false,
    bool isValid = true,
  }) {
    return ModelFieldState._(
      value: value,
      errorText: (errorText?.trim().isEmpty ?? true) ? null : errorText,
      suggestions: List<String>.unmodifiable(suggestions),
      isDirty: isDirty,
      isValid: isValid,
    );
  }

  /// Creates a model from raw JSON.
  factory ModelFieldState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return empty;
    }

    return ModelFieldState(
      value: _string(json[FieldStateEnum.value.name]),
      errorText: _nullableString(json[FieldStateEnum.errorText.name]),
      suggestions: _stringList(json[FieldStateEnum.suggestions.name]),
      isDirty: _bool(json[FieldStateEnum.isDirty.name], fallback: false),
      isValid: _bool(json[FieldStateEnum.isValid.name], fallback: true),
    );
  }

  const ModelFieldState._({
    required this.value,
    required this.errorText,
    required this.suggestions,
    required this.isDirty,
    required this.isValid,
  });

  /// Handy empty instance useful for controllers.
  static const ModelFieldState empty = ModelFieldState._(
    value: '',
    errorText: null,
    suggestions: <String>[],
    isDirty: false,
    isValid: true,
  );

  /// Current text value captured inside the field.
  final String value;

  /// Optional error text displayed alongside the decoration.
  final String? errorText;

  /// Suggestions used by the autocomplete overlay.
  final List<String> suggestions;

  /// Whether the user has interacted with the field.
  final bool isDirty;

  /// Whether the latest validation run marked the input as valid.
  final bool isValid;

  /// Serializes this state into a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      FieldStateEnum.value.name: value,
      FieldStateEnum.errorText.name: errorText,
      FieldStateEnum.suggestions.name: suggestions,
      FieldStateEnum.isDirty.name: isDirty,
      FieldStateEnum.isValid.name: isValid,
    };
  }

  /// Returns a copy with the provided overrides.
  ModelFieldState copyWith({
    String? value,
    String? errorText,
    List<String>? suggestions,
    bool? isDirty,
    bool? isValid,
  }) {
    return ModelFieldState(
      value: value ?? this.value,
      errorText: errorText ?? this.errorText,
      suggestions: suggestions ?? this.suggestions,
      isDirty: isDirty ?? this.isDirty,
      isValid: isValid ?? this.isValid,
    );
  }

  /// Creates a new instance without the existing error message.
  ModelFieldState clearError() {
    if (errorText == null) {
      return this;
    }
    return copyWith(errorText: null);
  }

  /// Convenience getter to know if there is an error to display.
  bool get hasError => errorText != null && errorText!.trim().isNotEmpty;

  @override
  String toString() => '${toJson()}';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ModelFieldState &&
            runtimeType == other.runtimeType &&
            value == other.value &&
            errorText == other.errorText &&
            listEquals(suggestions, other.suggestions) &&
            isDirty == other.isDirty &&
            isValid == other.isValid;
  }

  @override
  int get hashCode => Object.hash(
        value,
        errorText,
        Object.hashAll(suggestions),
        isDirty,
        isValid,
      );

  static String _string(dynamic value) {
    if (value is String) {
      return value;
    }
    if (value == null) {
      return '';
    }
    return value.toString();
  }

  static String? _nullableString(dynamic value) {
    final String candidate = _string(value);
    if (candidate.isEmpty) {
      return null;
    }
    return candidate;
  }

  static List<String> _stringList(dynamic value) {
    if (value is List) {
      return value
          .where((dynamic element) => element != null)
          .map<String>((dynamic element) => element.toString())
          .toList(growable: false);
    }
    return <String>[];
  }

  static bool _bool(dynamic value, {required bool fallback}) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final String normalized = value.toLowerCase().trim();
      if (normalized == 'true' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }
    return fallback;
  }
}
