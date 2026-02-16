import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('ModelThemeData', () {
    test('pragmaDefault uses Pragma color schemes', () {
      final ModelThemeData model = ModelThemeData.pragmaDefault();

      expect(model.useMaterial3, isTrue);
      expect(model.lightScheme.primary, PragmaColors.lightScheme.primary);
      expect(model.darkScheme.primary, PragmaColors.darkScheme.primary);
    });

    test('json roundtrip keeps values', () {
      final ModelThemeData model = ModelThemeData.pragmaDefault();

      final ModelThemeData restored = ModelThemeData.fromJson(model.toJson());

      expect(restored.toJson(), model.toJson());
    });
  });

  group('ModelSemanticColors', () {
    test('fallback json roundtrip works', () {
      final ModelSemanticColors model = ModelSemanticColors.fallbackLight();

      final ModelSemanticColors restored =
          ModelSemanticColors.fromJson(model.toJson());

      expect(restored, model);
    });
  });

  group('ModelDsComponentAnatomy', () {
    test('json roundtrip works', () {
      const ModelDsComponentAnatomy model = ModelDsComponentAnatomy(
        id: 'ds.sidebar',
        name: 'Sidebar',
        description: 'Main app navigation component.',
        tags: <String>['navigation', 'layout'],
        status: ModelDsComponentStatusEnum.stable,
        platforms: <ModelDsComponentPlatformEnum>[
          ModelDsComponentPlatformEnum.web,
          ModelDsComponentPlatformEnum.android,
        ],
        slots: <ModelDsComponentSlot>[
          ModelDsComponentSlot(
            name: 'Header',
            role: 'Brand and context label',
            rules: <String>['Shows imagotype in collapsed mode'],
            tokensUsed: <String>['spacingSm', 'primaryPurple500'],
          ),
        ],
      );

      final ModelDsComponentAnatomy restored =
          ModelDsComponentAnatomy.fromJson(model.toJson());

      expect(restored.id, model.id);
      expect(restored.name, model.name);
      expect(restored.status, model.status);
      expect(restored.slots, model.slots);
    });
  });

  group('ModelDesignSystem', () {
    test('pragmaDefault is serializable and builds theme', () {
      final ModelDesignSystem ds = ModelDesignSystem.pragmaDefault();
      final ModelDesignSystem restored =
          ModelDesignSystem.fromJson(ds.toJson());

      final ThemeData light =
          restored.toThemeData(brightness: Brightness.light);

      expect(restored.toJson(), ds.toJson());
      expect(light.extension<DsExtendedTokensExtension>(), isNotNull);
      expect(light.dsTokens.spacing, ds.tokens.spacing);
      expect(light.dsSemantic.success, ds.semanticLight.success);
      expect(
        light.textTheme.bodyMedium?.fontSize,
        ds.typographyTokens.bodyMedium.fontSize,
      );
    });

    test('typographyTokens override text theme generation', () {
      final ModelDesignSystem base = ModelDesignSystem.pragmaDefault();
      final ModelDesignSystem tuned = base.copyWith(
        typographyTokens: base.typographyTokens.copyWith(
          bodyMedium: base.typographyTokens.bodyMedium.copyWith(fontSize: 18),
        ),
      );

      final ThemeData light = tuned.toThemeData(brightness: Brightness.light);

      expect(light.textTheme.bodyMedium?.fontSize, 18);
    });
  });

  group('ModelTypographyTokens', () {
    test('json roundtrip works', () {
      final ModelTypographyTokens model = ModelTypographyTokens.pragmaDefault();
      final ModelTypographyTokens restored =
          ModelTypographyTokens.fromJson(model.toJson());

      expect(restored, model);
    });
  });
}
