import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tipografía oficial basada en la familia Poppins y los tamaños
/// suministrados por el equipo de diseño.
class PragmaTypography {
  const PragmaTypography._();

  static const String _fontFamily = 'Poppins';

  static TextTheme textTheme({Brightness brightness = Brightness.light}) {
    final Color color =
        brightness == Brightness.dark ? Colors.white : const Color(0xFF111111);

    TextStyle style(PragmaTextStyleToken token) => token.resolve(color: color);

    return TextTheme(
      displayLarge: style(PragmaTypographyTokens.display01SemiBold),
      displayMedium: style(PragmaTypographyTokens.display02SemiBold),
      displaySmall: style(PragmaTypographyTokens.heading01SemiBold),
      headlineLarge: style(PragmaTypographyTokens.heading02SemiBold),
      headlineMedium: style(PragmaTypographyTokens.heading03SemiBold),
      headlineSmall: style(PragmaTypographyTokens.heading04SemiBold),
      titleLarge: style(PragmaTypographyTokens.heading05SemiBold),
      titleMedium: style(PragmaTypographyTokens.heading06SemiBold),
      titleSmall: style(PragmaTypographyTokens.subheadingRegular),
      bodyLarge: style(PragmaTypographyTokens.paragraph01Regular),
      bodyMedium: style(PragmaTypographyTokens.paragraph02Regular),
      bodySmall: style(PragmaTypographyTokens.paragraph03Regular),
      labelLarge: style(PragmaTypographyTokens.captionBold),
      labelMedium: style(PragmaTypographyTokens.captionRegular),
      labelSmall: style(PragmaTypographyTokens.footerRegular),
    );
  }
}

/// Descriptor de un token tipográfico con su bloque de estilo.
@immutable
class PragmaTextStyleToken {
  const PragmaTextStyleToken({
    required this.name,
    required this.designToken,
    required this.fontSize,
    required this.lineHeight,
    required this.fontWeight,
    this.decoration,
    this.letterSpacing,
    this.isUppercase = false,
  });

  final String name;
  final String designToken;
  final double fontSize;
  final double lineHeight;
  final FontWeight fontWeight;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final bool isUppercase;

  double get height => lineHeight / fontSize;

  TextStyle resolve({Color? color}) {
    final TextStyle base = TextStyle(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: fontWeight,
      decoration: decoration,
      letterSpacing: letterSpacing,
    );

    if (GoogleFonts.config.allowRuntimeFetching) {
      return GoogleFonts.poppins(textStyle: base);
    }

    return base.copyWith(fontFamily: PragmaTypography._fontFamily);
  }
}

/// Escala de estilos disponibles para tokens.
class PragmaTypographyTokens {
  const PragmaTypographyTokens._();

  static const PragmaTextStyleToken display01Regular = PragmaTextStyleToken(
    name: 'Display 01 Regular',
    designToken: r'$pds-font-display-01-regular',
    fontSize: 72,
    lineHeight: 76,
    fontWeight: FontWeight.w400,
  );
  static const PragmaTextStyleToken display01SemiBold = PragmaTextStyleToken(
    name: 'Display 01 SemiBold',
    designToken: r'$pds-font-display-01-semibold',
    fontSize: 72,
    lineHeight: 76,
    fontWeight: FontWeight.w600,
  );
  static const PragmaTextStyleToken display01Bold = PragmaTextStyleToken(
    name: 'Display 01 Bold',
    designToken: r'$pds-font-display-01-bold',
    fontSize: 72,
    lineHeight: 76,
    fontWeight: FontWeight.w700,
  );

  static const PragmaTextStyleToken display02Regular = PragmaTextStyleToken(
    name: 'Display 02 Regular',
    designToken: r'$pds-font-display-02-regular',
    fontSize: 60,
    lineHeight: 64,
    fontWeight: FontWeight.w400,
  );
  static const PragmaTextStyleToken display02SemiBold = PragmaTextStyleToken(
    name: 'Display 02 SemiBold',
    designToken: r'$pds-font-display-02-semibold',
    fontSize: 60,
    lineHeight: 64,
    fontWeight: FontWeight.w600,
  );
  static const PragmaTextStyleToken display02Bold = PragmaTextStyleToken(
    name: 'Display 02 Bold',
    designToken: r'$pds-font-display-02-bold',
    fontSize: 60,
    lineHeight: 64,
    fontWeight: FontWeight.w700,
  );

  static const PragmaTextStyleToken heading01Regular = PragmaTextStyleToken(
    name: 'Heading 01 Regular',
    designToken: r'$pds-font-heading-01-regular',
    fontSize: 46,
    lineHeight: 50,
    fontWeight: FontWeight.w400,
  );
  static const PragmaTextStyleToken heading01SemiBold = PragmaTextStyleToken(
    name: 'Heading 01 SemiBold',
    designToken: r'$pds-font-heading-01-semibold',
    fontSize: 46,
    lineHeight: 50,
    fontWeight: FontWeight.w600,
  );
  static const PragmaTextStyleToken heading01Bold = PragmaTextStyleToken(
    name: 'Heading 01 Bold',
    designToken: r'$pds-font-heading-01-bold',
    fontSize: 46,
    lineHeight: 50,
    fontWeight: FontWeight.w700,
  );

  static const PragmaTextStyleToken heading02Regular = PragmaTextStyleToken(
    name: 'Heading 02 Regular',
    designToken: r'$pds-font-heading-02-regular',
    fontSize: 36,
    lineHeight: 40,
    fontWeight: FontWeight.w400,
  );
  static const PragmaTextStyleToken heading02SemiBold = PragmaTextStyleToken(
    name: 'Heading 02 SemiBold',
    designToken: r'$pds-font-heading-02-semibold',
    fontSize: 36,
    lineHeight: 40,
    fontWeight: FontWeight.w600,
  );
  static const PragmaTextStyleToken heading02Bold = PragmaTextStyleToken(
    name: 'Heading 02 Bold',
    designToken: r'$pds-font-heading-02-bold',
    fontSize: 36,
    lineHeight: 40,
    fontWeight: FontWeight.w700,
  );

  static const PragmaTextStyleToken heading03Regular = PragmaTextStyleToken(
    name: 'Heading 03 Regular',
    designToken: r'$pds-font-heading-03-regular',
    fontSize: 30,
    lineHeight: 34,
    fontWeight: FontWeight.w400,
  );
  static const PragmaTextStyleToken heading03SemiBold = PragmaTextStyleToken(
    name: 'Heading 03 SemiBold',
    designToken: r'$pds-font-heading-03-semibold',
    fontSize: 30,
    lineHeight: 34,
    fontWeight: FontWeight.w600,
  );
  static const PragmaTextStyleToken heading03Bold = PragmaTextStyleToken(
    name: 'Heading 03 Bold',
    designToken: r'$pds-font-heading-03-bold',
    fontSize: 30,
    lineHeight: 34,
    fontWeight: FontWeight.w700,
  );

  static const PragmaTextStyleToken heading04Regular = PragmaTextStyleToken(
    name: 'Heading 04 Regular',
    designToken: r'$pds-font-heading-04-regular',
    fontSize: 26,
    lineHeight: 30,
    fontWeight: FontWeight.w400,
  );
  static const PragmaTextStyleToken heading04SemiBold = PragmaTextStyleToken(
    name: 'Heading 04 SemiBold',
    designToken: r'$pds-font-heading-04-semibold',
    fontSize: 26,
    lineHeight: 30,
    fontWeight: FontWeight.w600,
  );
  static const PragmaTextStyleToken heading04Bold = PragmaTextStyleToken(
    name: 'Heading 04 Bold',
    designToken: r'$pds-font-heading-04-bold',
    fontSize: 26,
    lineHeight: 30,
    fontWeight: FontWeight.w700,
  );

  static const PragmaTextStyleToken heading05Regular = PragmaTextStyleToken(
    name: 'Heading 05 Regular',
    designToken: r'$pds-font-heading-05-regular',
    fontSize: 21,
    lineHeight: 25,
    fontWeight: FontWeight.w400,
  );
  static const PragmaTextStyleToken heading05SemiBold = PragmaTextStyleToken(
    name: 'Heading 05 SemiBold',
    designToken: r'$pds-font-heading-05-semibold',
    fontSize: 21,
    lineHeight: 25,
    fontWeight: FontWeight.w600,
  );
  static const PragmaTextStyleToken heading05Bold = PragmaTextStyleToken(
    name: 'Heading 05 Bold',
    designToken: r'$pds-font-heading-05-bold',
    fontSize: 21,
    lineHeight: 25,
    fontWeight: FontWeight.w700,
  );

  static const PragmaTextStyleToken heading06Regular = PragmaTextStyleToken(
    name: 'Heading 06 Regular',
    designToken: r'$pds-font-heading-06-regular',
    fontSize: 16,
    lineHeight: 20,
    fontWeight: FontWeight.w400,
  );
  static const PragmaTextStyleToken heading06SemiBold = PragmaTextStyleToken(
    name: 'Heading 06 SemiBold',
    designToken: r'$pds-font-heading-06-semibold',
    fontSize: 16,
    lineHeight: 20,
    fontWeight: FontWeight.w600,
  );
  static const PragmaTextStyleToken heading06Bold = PragmaTextStyleToken(
    name: 'Heading 06 Bold',
    designToken: r'$pds-font-heading-06-bold',
    fontSize: 16,
    lineHeight: 20,
    fontWeight: FontWeight.w700,
  );

  static const PragmaTextStyleToken subheadingRegular = PragmaTextStyleToken(
    name: 'Subheading Regular',
    designToken: r'$pds-font-subheading-regular',
    fontSize: 30,
    lineHeight: 34,
    fontWeight: FontWeight.w400,
  );
  static const PragmaTextStyleToken subheadingBold = PragmaTextStyleToken(
    name: 'Subheading Bold',
    designToken: r'$pds-font-subheading-bold',
    fontSize: 30,
    lineHeight: 34,
    fontWeight: FontWeight.w700,
  );
  static const PragmaTextStyleToken subheadingRegularUnderline =
      PragmaTextStyleToken(
    name: 'Subheading Regular Underline',
    designToken: r'$pds-font-subheading-regular-underline',
    fontSize: 30,
    lineHeight: 34,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
  );

  static const PragmaTextStyleToken paragraph01Regular = PragmaTextStyleToken(
    name: 'Paragraph 01 Regular',
    designToken: r'$pds-font-paragraph-01-regular',
    fontSize: 21,
    lineHeight: 25,
    fontWeight: FontWeight.w400,
  );
  static const PragmaTextStyleToken paragraph01Bold = PragmaTextStyleToken(
    name: 'Paragraph 01 Bold',
    designToken: r'$pds-font-paragraph-01-bold',
    fontSize: 21,
    lineHeight: 25,
    fontWeight: FontWeight.w700,
  );
  static const PragmaTextStyleToken paragraph01RegularUnderline =
      PragmaTextStyleToken(
    name: 'Paragraph 01 Regular Underline',
    designToken: r'$pds-font-paragraph-01-regular-underline',
    fontSize: 21,
    lineHeight: 25,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
  );

  static const PragmaTextStyleToken paragraph02Regular = PragmaTextStyleToken(
    name: 'Paragraph 02 Regular',
    designToken: r'$pds-font-paragraph-02-regular',
    fontSize: 16,
    lineHeight: 20,
    fontWeight: FontWeight.w400,
  );
  static const PragmaTextStyleToken paragraph02Bold = PragmaTextStyleToken(
    name: 'Paragraph 02 Bold',
    designToken: r'$pds-font-paragraph-02-bold',
    fontSize: 16,
    lineHeight: 20,
    fontWeight: FontWeight.w700,
  );
  static const PragmaTextStyleToken paragraph02RegularUnderline =
      PragmaTextStyleToken(
    name: 'Paragraph 02 Regular Underline',
    designToken: r'$pds-font-paragraph-02-regular-underline',
    fontSize: 16,
    lineHeight: 20,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
  );

  static const PragmaTextStyleToken paragraph03Regular = PragmaTextStyleToken(
    name: 'Paragraph 03 Regular',
    designToken: r'$pds-font-paragraph-03-regular',
    fontSize: 14,
    lineHeight: 18,
    fontWeight: FontWeight.w400,
  );
  static const PragmaTextStyleToken paragraph03SemiBold = PragmaTextStyleToken(
    name: 'Paragraph 03 SemiBold',
    designToken: r'$pds-font-paragraph-03-semibold',
    fontSize: 14,
    lineHeight: 18,
    fontWeight: FontWeight.w600,
  );
  static const PragmaTextStyleToken paragraph03Bold = PragmaTextStyleToken(
    name: 'Paragraph 03 Bold',
    designToken: r'$pds-font-paragraph-03-bold',
    fontSize: 14,
    lineHeight: 18,
    fontWeight: FontWeight.w700,
  );
  static const PragmaTextStyleToken paragraph03RegularUnderline =
      PragmaTextStyleToken(
    name: 'Paragraph 03 Regular Underline',
    designToken: r'$pds-font-paragraph-03-regular-underline',
    fontSize: 14,
    lineHeight: 18,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
  );

  static const PragmaTextStyleToken captionRegular = PragmaTextStyleToken(
    name: 'Caption Regular',
    designToken: r'$pds-font-caption-regular',
    fontSize: 12,
    lineHeight: 16,
    fontWeight: FontWeight.w400,
  );
  static const PragmaTextStyleToken captionBold = PragmaTextStyleToken(
    name: 'Caption Bold',
    designToken: r'$pds-font-caption-bold',
    fontSize: 12,
    lineHeight: 16,
    fontWeight: FontWeight.w700,
  );
  static const PragmaTextStyleToken captionRegularUnderline =
      PragmaTextStyleToken(
    name: 'Caption Regular Underline',
    designToken: r'$pds-font-caption-regular-underline',
    fontSize: 12,
    lineHeight: 16,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
  );
  static const PragmaTextStyleToken captionBoldUnderline = PragmaTextStyleToken(
    name: 'Caption Bold Underline',
    designToken: r'$pds-font-caption-bold-underline',
    fontSize: 12,
    lineHeight: 16,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
  );
  static const PragmaTextStyleToken captionRegularUppercase =
      PragmaTextStyleToken(
    name: 'Caption Regular Uppercase',
    designToken: r'$pds-font-caption-regular-uppercase',
    fontSize: 12,
    lineHeight: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    isUppercase: true,
  );

  static const PragmaTextStyleToken footerRegular = PragmaTextStyleToken(
    name: 'Footer Regular',
    designToken: r'$pds-font-footer-regular',
    fontSize: 10,
    lineHeight: 14,
    fontWeight: FontWeight.w400,
  );
  static const PragmaTextStyleToken footerBold = PragmaTextStyleToken(
    name: 'Footer Bold',
    designToken: r'$pds-font-footer-bold',
    fontSize: 10,
    lineHeight: 14,
    fontWeight: FontWeight.w700,
  );
  static const PragmaTextStyleToken footerRegularUppercase =
      PragmaTextStyleToken(
    name: 'Footer Regular Uppercase',
    designToken: r'$pds-font-footer-regular-uppercase',
    fontSize: 10,
    lineHeight: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    isUppercase: true,
  );

  /// Colección completa para automatizar catálogos o herramientas.
  static const List<PragmaTextStyleToken> all = <PragmaTextStyleToken>[
    display01Regular,
    display01SemiBold,
    display01Bold,
    display02Regular,
    display02SemiBold,
    display02Bold,
    heading01Regular,
    heading01SemiBold,
    heading01Bold,
    heading02Regular,
    heading02SemiBold,
    heading02Bold,
    heading03Regular,
    heading03SemiBold,
    heading03Bold,
    heading04Regular,
    heading04SemiBold,
    heading04Bold,
    heading05Regular,
    heading05SemiBold,
    heading05Bold,
    heading06Regular,
    heading06SemiBold,
    heading06Bold,
    subheadingRegular,
    subheadingBold,
    subheadingRegularUnderline,
    paragraph01Regular,
    paragraph01Bold,
    paragraph01RegularUnderline,
    paragraph02Regular,
    paragraph02Bold,
    paragraph02RegularUnderline,
    paragraph03Regular,
    paragraph03SemiBold,
    paragraph03Bold,
    paragraph03RegularUnderline,
    captionRegular,
    captionBold,
    captionRegularUnderline,
    captionBoldUnderline,
    captionRegularUppercase,
    footerRegular,
    footerBold,
    footerRegularUppercase,
  ];
}
