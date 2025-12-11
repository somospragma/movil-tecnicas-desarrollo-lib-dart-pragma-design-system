import 'package:flutter/material.dart';

/// Tokens oficiales de color del Design System de Pragma.
///
/// > Nota: los widgets no deben usar estos valores directamente. Consume los
/// > colores solo a través de `Theme.of(context)` y del `ColorScheme`
/// > configurado por `PragmaTheme`.
class PragmaColorTokens {
  const PragmaColorTokens._();

  // Paleta primaria - morados.
  static const Color primaryPurple50 = Color(0xFFF7DDF8);
  static const Color primaryPurple300 = Color(0xFFABB8E7);
  static const Color primaryPurple500 = Color(0xFF6429CD);
  static const Color primaryPurple700 = Color(0xFF330072);
  static const Color primaryPurple900 = Color(0xFF1F0D3F);

  // Paleta primaria - grises base.
  static const Color primaryGray50 = Color(0xFFD8D8D6);
  static const Color primaryGray300 = Color(0xFF75756D);
  static const Color primaryGray500 = Color(0xFF1D1D1B);
  static const Color primaryGray700 = Color(0xFF141413);
  static const Color primaryGray900 = Color(0xFF030302);

  // Paleta primaria - índigos.
  static const Color primaryIndigo50 = Color(0xFFF6F6FC);
  static const Color primaryIndigo300 = Color(0xFFDFDFFF);
  static const Color primaryIndigo500 = Color(0xFF8B8BFF);
  static const Color primaryIndigo700 = Color(0xFF4A8AFF);
  static const Color primaryIndigo900 = Color(0xFF4646FF);

  // Paleta secundaria - fucsias.
  static const Color secondaryFuchsia50 = Color(0xFFFDF9FF);
  static const Color secondaryFuchsia300 = Color(0xFFF3D7FF);
  static const Color secondaryFuchsia500 = Color(0xFFE4A4FF);
  static const Color secondaryFuchsia700 = Color(0xFFDD52DD);
  static const Color secondaryFuchsia900 = Color(0xFF7500A0);

  // Paleta secundaria - morados.
  static const Color secondaryPurple50 = Color(0xFFF0DCFF);
  static const Color secondaryPurple300 = Color(0xFFB885FF);
  static const Color secondaryPurple500 = Color(0xFF9610FF);
  static const Color secondaryPurple700 = Color(0xFF440099);
  static const Color secondaryPurple900 = Color(0xFF150030);

  // Paleta terciaria - amarillos de acento.
  static const Color tertiaryYellow50 = Color(0xFFFDECD0);
  static const Color tertiaryYellow300 = Color(0xFFFACA7E);
  static const Color tertiaryYellow500 = Color(0xFFF8A53C);
  static const Color tertiaryYellow700 = Color(0xFFC77C07);
  static const Color tertiaryYellow900 = Color(0xFF7F5404);

  // Escala neutra de grises (tokens "Gray").
  static const Color neutralGray50 = Color(0xFFF6F7FC);
  static const Color neutralGray100 = Color(0xFFE8E8ED);
  static const Color neutralGray200 = Color(0xFFD2D2D6);
  static const Color neutralGray300 = Color(0xFFB6B6BA);
  static const Color neutralGray400 = Color(0xFF9D9DA1);
  static const Color neutralGray500 = Color(0xFF828285);
  static const Color neutralGray600 = Color(0xFF666669);
  static const Color neutralGray700 = Color(0xFF4D4D4F);
  static const Color neutralGray800 = Color(0xFF282829);
  static const Color neutralGray900 = Color(0xFF0C0C0D);

  // Estados - éxito.
  static const Color success50 = Color(0xFFD3F5EB);
  static const Color success300 = Color(0xFF1AFFBA);
  static const Color success500 = Color(0xFF00ECA5);
  static const Color success700 = Color(0xFF00B880);
  static const Color success900 = Color(0xFF006B4B);

  // Estados - advertencia.
  static const Color warning50 = Color(0xFFFFEEB3);
  static const Color warning300 = Color(0xFFFFDA57);
  static const Color warning500 = Color(0xFFFFCA10);
  static const Color warning700 = Color(0xFFDBA800);
  static const Color warning900 = Color(0xFF997700);

  // Estados - error.
  static const Color error50 = Color(0xFFFFB8C9);
  static const Color error300 = Color(0xFFFF527B);
  static const Color error500 = Color(0xFFED0039);
  static const Color error700 = Color(0xFFB8002C);
  static const Color error900 = Color(0xFF660019);

  // Tonos básicos.
  static const Color basicWhite50 = Color(0xFFFFFFFF);
  static const Color basicBlack300 = Color(0xFF000000);
}
