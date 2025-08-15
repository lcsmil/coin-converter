import 'package:flutter/material.dart';
import '../../core/constants/color_tokens.dart';
import '../../core/utils/l10n_helper.dart';
import '../../core/constants/size_tokens.dart';

class ConvertButton extends StatelessWidget {
  final bool isLoading;
  final bool canConvert;
  final VoidCallback? onConvert;

  const ConvertButton({
    super.key,
    required this.isLoading,
    required this.canConvert,
    this.onConvert,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SizeTokens.inputFieldHeight,
      child: ElevatedButton(
        onPressed: canConvert && !isLoading ? onConvert : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorTokens.primary,
          foregroundColor: ColorTokens.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeTokens.buttonBorderRadius),
          ),
          elevation: SizeTokens.buttonElevation,
        ),
        child: isLoading
            ? SizedBox(
                width: SizeTokens.iconSize,
                height: SizeTokens.iconSize,
                child: CircularProgressIndicator(
                  color: ColorTokens.white,
                  strokeWidth: SizeTokens.indicatorStrokeWidth,
                ),
              )
            : Text(
                L10n.of(context).convertButtonLabel,
                style: TextStyle(
                  fontSize: SizeTokens.titleFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
