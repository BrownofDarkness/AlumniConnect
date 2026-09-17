import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Échelle typographique Inter (unique famille).
///
/// Pour un rendu responsive, chaîner `.responsive(context)` sur le style
/// (extension définie dans core/utils/responsive.dart). Ex :
/// `AppTextStyles.title.responsive(context).copyWith(color: ...)`.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base(
    double size,
    FontWeight weight, {
    double letterSpacing = 0,
    double height = 1.5,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle get displayXL =>
      _base(32, FontWeight.w800, letterSpacing: -0.6, height: 1.1);

  static TextStyle get display =>
      _base(26, FontWeight.w700, letterSpacing: -0.4, height: 1.15);

  static TextStyle get title =>
      _base(20, FontWeight.w700, letterSpacing: -0.2, height: 1.2);

  static TextStyle get heading =>
      _base(16, FontWeight.w600, height: 1.3);

  static TextStyle get bodyLg =>
      _base(15, FontWeight.w400, height: 1.5);

  static TextStyle get body =>
      _base(14, FontWeight.w400, height: 1.5);

  static TextStyle get bodySm =>
      _base(13, FontWeight.w400, height: 1.4);

  static TextStyle get caption =>
      _base(12, FontWeight.w500, height: 1.3);

  static TextStyle get labelCaps =>
      _base(11, FontWeight.w600, letterSpacing: 1.5, height: 1.2);
}
