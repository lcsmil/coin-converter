import 'package:flutter/material.dart';

class SizeTokens {
  // Border properties
  static double get borderRadius => 30.0;
  static double get iconBorderRadius => 4.0;
  static double get borderWidth => 2.0;
  
  // Icon sizes
  static double get iconSize => 24.0;
  static double get arrowIconSize => 24.0;
  
  // Button properties
  static double get buttonSize => 50.0;
  static double get buttonBorderRadius => 12.0;
  static double get buttonElevation => 2.0;
  static double get swapButtonVerticalOffset => 4.0;
  static double get swapButtonIconSize => 18.0;

  // Indicator properties
  static double get indicatorStrokeWidth => 2.0;
  
  // Font sizes
  static double get labelFontSize => 12.0;
  static double get bodyFontSize => 14.0;
  static double get mediumFontSize => 16.0;
  static double get titleFontSize => 18.0;
  static double get headingFontSize => 24.0;
  
  // Padding and spacing
  static double get horizontalPadding => 16.0;
  static double get verticalPadding => 18.0;
  static double get spaceBetween => 24.0;
  static double get spacingSmall => 8.0;
  static double get spacingMedium => 12.0;
  static double get spacingExtraSmall => 4.0;
  
  // Modal sheet properties
  static double get modalSheetBorderRadius => 20.0;
  static double get modalSheetPadding => 16.0;
  static double get dragHandleWidth => 40.0;
  static double get dragHandleHeight => 4.0;
  static double get dragHandleBorderRadius => 2.0;
  
  // Input field properties
  static double get inputFieldHeight => 56.0;
  
  // Context-dependent properties
  static double getModalSheetMaxHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.7;
  }
}
