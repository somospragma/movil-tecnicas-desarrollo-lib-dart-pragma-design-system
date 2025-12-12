import 'package:flutter/foundation.dart';

/// Enumerates the serializable properties of [ModelAnatomyAttribute].
enum AnatomyAttributeEnum { title, description, value }

/// Describes a single anatomy attribute inside a Figma component.
@immutable
class ModelAnatomyAttribute {
  const ModelAnatomyAttribute({
    required this.title,
    this.description = '',
    this.value = 0.1,
  });

  /// Creates an instance from a JSON map.
  factory ModelAnatomyAttribute.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ModelAnatomyAttribute(title: '');
    }

    return ModelAnatomyAttribute(
      title: _string(json[AnatomyAttributeEnum.title.name]),
      description: _string(json[AnatomyAttributeEnum.description.name]),
      value: _double(json[AnatomyAttributeEnum.value.name], fallback: 0.1),
    );
  }

  /// Visible name of the anatomy entry.
  final String title;

  /// Optional extended description.
  final String description;

  /// Associated value (for example, a relative percentage in the 0.0–1.0 range).
  final double value;

  /// Returns a copy with the provided overrides.
  ModelAnatomyAttribute copyWith({
    String? title,
    String? description,
    double? value,
  }) {
    return ModelAnatomyAttribute(
      title: title ?? this.title,
      description: description ?? this.description,
      value: value ?? this.value,
    );
  }

  /// Serializes the attribute into JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      AnatomyAttributeEnum.title.name: title,
      AnatomyAttributeEnum.description.name: description,
      AnatomyAttributeEnum.value.name: value,
    };
  }

  @override
  String toString() => '${toJson()}';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ModelAnatomyAttribute &&
            runtimeType == other.runtimeType &&
            title == other.title &&
            description == other.description &&
            value == other.value;
  }

  @override
  int get hashCode => Object.hash(title, description, value);

  static String _string(dynamic value) {
    if (value is String) {
      return value;
    }
    if (value == null) {
      return '';
    }
    return value.toString();
  }

  static double _double(dynamic value, {required double fallback}) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
