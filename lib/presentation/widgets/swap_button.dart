import 'package:flutter/material.dart';
import '../../core/constants/color_tokens.dart';
import '../../core/constants/size_tokens.dart';

class SwapButton extends StatelessWidget {
  const SwapButton({
    super.key,
    required this.swapButtonSize,
    required this.onSwap,
  });

  final double swapButtonSize;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSwap,
      child: Container(
        width: swapButtonSize,
        height: swapButtonSize,
        decoration: const BoxDecoration(
          color: ColorTokens.primary,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back,
              color: ColorTokens.white,
              size: SizeTokens.swapButtonIconSize,
            ),
            Icon(
              Icons.arrow_forward,
              color: ColorTokens.white,
              size: SizeTokens.swapButtonIconSize,
            ),
          ],
        ),
      ),
    );
  }
}
