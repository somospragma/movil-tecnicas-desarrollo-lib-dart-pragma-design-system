import 'package:flutter/foundation.dart';

import 'model_anatomy_attribute.dart';

/// Enumerates the serialized fields of [ModelPragmaComponent].
enum PragmaComponentEnum {
  titleComponent,
  description,
  anatomy,
  useCases,
  urlImages,
}

/// Document a UI component coming from Figma as an immutable value object.
///
/// This model stores the component title, a short description, a list of
/// anatomy attributes, recommended use cases, and image URLs.
///
/// Functional example:
/// ```dart
/// void main() {
///   final ModelPragmaComponent component = ModelPragmaComponent(
///     titleComponent: 'PragmaButton',
///     description: 'Primary call-to-action button',
///     anatomy: <ModelAnatomyAttribute>[
///       ModelAnatomyAttribute(title: 'Padding', value: 16.0),
///     ],
///     useCases: <String>['Submit form', 'Confirm dialog'],
///     urlImages: <String>['https://example.com/button.png'],
///   );
///
///   final Map<String, dynamic> json = component.toJson();
///   final ModelPragmaComponent decoded = ModelPragmaComponent.fromJson(json);
///
///   assert(component == decoded);
///   print(decoded.titleComponent);
/// }
/// ```
///
/// Contracts:
/// - The instance is immutable (lists are stored as unmodifiable).
/// - [fromJson] returns [ModelPragmaComponent.empty] when `json` is `null`.
@immutable
class ModelPragmaComponent {
  factory ModelPragmaComponent({
    required String titleComponent,
    required String description,
    List<ModelAnatomyAttribute> anatomy = const <ModelAnatomyAttribute>[],
    List<String> useCases = const <String>[],
    List<String> urlImages = const <String>[],
  }) {
    return ModelPragmaComponent._(
      titleComponent: titleComponent,
      description: description,
      anatomy: List<ModelAnatomyAttribute>.unmodifiable(anatomy),
      useCases: List<String>.unmodifiable(useCases),
      urlImages: List<String>.unmodifiable(urlImages),
    );
  }

  /// Creates a model from raw JSON.
  factory ModelPragmaComponent.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return empty;
    }

    return ModelPragmaComponent(
      titleComponent: _string(json[PragmaComponentEnum.titleComponent.name]),
      description: _string(json[PragmaComponentEnum.description.name]),
      anatomy: _anatomyList(json[PragmaComponentEnum.anatomy.name]),
      useCases: _stringList(json[PragmaComponentEnum.useCases.name]),
      urlImages: _stringList(json[PragmaComponentEnum.urlImages.name]),
    );
  }
  const ModelPragmaComponent._({
    required this.titleComponent,
    required this.description,
    required this.anatomy,
    required this.useCases,
    required this.urlImages,
  });

  /// Handy instance for tests or default states.
  static const ModelPragmaComponent empty = ModelPragmaComponent._(
    titleComponent: '',
    description: '',
    anatomy: <ModelAnatomyAttribute>[],
    useCases: <String>[],
    urlImages: <String>[],
  );

  /// Component title (matches the Figma node name).
  final String titleComponent;

  /// Short description that explains the component intent.
  final String description;

  /// Highlighted anatomy entries used by the documentation.
  final List<ModelAnatomyAttribute> anatomy;

  /// Recommended use cases.
  final List<String> useCases;

  /// URLs that point to screenshots or mockups.
  final List<String> urlImages;

  /// Serializes the component into JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      PragmaComponentEnum.titleComponent.name: titleComponent,
      PragmaComponentEnum.description.name: description,
      PragmaComponentEnum.anatomy.name:
          anatomy.map((ModelAnatomyAttribute e) => e.toJson()).toList(),
      PragmaComponentEnum.useCases.name: useCases,
      PragmaComponentEnum.urlImages.name: urlImages,
    };
  }

  /// Returns a copy with the provided overrides.
  ModelPragmaComponent copyWith({
    String? titleComponent,
    String? description,
    List<ModelAnatomyAttribute>? anatomy,
    List<String>? useCases,
    List<String>? urlImages,
  }) {
    return ModelPragmaComponent(
      titleComponent: titleComponent ?? this.titleComponent,
      description: description ?? this.description,
      anatomy: anatomy ?? this.anatomy,
      useCases: useCases ?? this.useCases,
      urlImages: urlImages ?? this.urlImages,
    );
  }

  @override
  String toString() => '${toJson()}';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ModelPragmaComponent &&
            runtimeType == other.runtimeType &&
            titleComponent == other.titleComponent &&
            description == other.description &&
            listEquals(anatomy, other.anatomy) &&
            listEquals(useCases, other.useCases) &&
            listEquals(urlImages, other.urlImages);
  }

  @override
  int get hashCode => Object.hash(
        titleComponent,
        description,
        Object.hashAll(anatomy),
        Object.hashAll(useCases),
        Object.hashAll(urlImages),
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

  static List<String> _stringList(dynamic value) {
    if (value is List) {
      return value
          .where((dynamic element) => element != null)
          .map<String>((dynamic element) => element.toString())
          .toList();
    }
    return <String>[];
  }

  static List<ModelAnatomyAttribute> _anatomyList(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map<String, dynamic>>()
          .map<ModelAnatomyAttribute>(ModelAnatomyAttribute.fromJson)
          .toList();
    }
    return <ModelAnatomyAttribute>[];
  }
}
