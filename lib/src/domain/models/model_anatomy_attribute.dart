import 'package:flutter/foundation.dart';

/// Enumera las propiedades serializables del [ModelAnatomyAttribute].
enum AnatomyAttributeEnum { title, description, value }

/// Describe un atributo anatómico dentro de un componente de Figma.
@immutable
class ModelAnatomyAttribute {
  const ModelAnatomyAttribute({
    required this.title,
    this.description = '',
    this.value = 0.1,
  });

  /// Crea una instancia a partir de un mapa JSON.
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

  /// Nombre visible del elemento anatómico.
  final String title;

  /// Descripción opcional del elemento.
  final String description;

  /// Valor asociado (por ejemplo porcentaje de tamaño relativo, entre 0.0 y 1.0).
  final double value;

  /// Genera una copia con valores reemplazados.
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

  /// Serializa el atributo a JSON.
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
