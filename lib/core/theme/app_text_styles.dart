import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Poppins/700/32 - Bold
  static TextStyle get h1 => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: AppColors.black100,
  );

  // Poppins/700/24 - Bold
  static TextStyle get h2 => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: AppColors.black100,
  );

  // Poppins/500/24 - Medium
  static TextStyle get h2Medium => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.black100,
  );

  // Poppins/700/16 - Bold (Subtitle/Button)
  static TextStyle get bodyLargeBold => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: AppColors.black100,
  );

  // Poppins/500/16 - Medium (Body)
  static TextStyle get bodyLargeMedium => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.black100,
  );

  static TextStyle get bodyMediumMedium => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.black100,
  );

  // Poppins/700/12 - Bold (Caption)
  static TextStyle get bodySmallBold => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: AppColors.black100,
  );

  // Poppins/500/12 - Medium (Caption)
  static TextStyle get bodySmallMedium => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.black100,
  );
}
