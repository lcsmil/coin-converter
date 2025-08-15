import 'package:flutter/material.dart';
import '../../domain/entities/currency.dart';
import '../../core/constants/size_tokens.dart';
import '../../core/constants/color_tokens.dart';
import '../../core/utils/l10n_helper.dart';
import 'swap_button.dart';
import 'currency_display.dart';

class CurrencySelector extends StatelessWidget {
  final Currency? selectedFromCurrency;
  final Currency? selectedToCurrency;
  final List<Currency> fromCurrencies;
  final List<Currency> toCurrencies;
  final ValueChanged<Currency> onFromCurrencySelected;
  final ValueChanged<Currency> onToCurrencySelected;
  final VoidCallback onSwap;
  final bool isVisible;

  const CurrencySelector({
    super.key,
    this.selectedFromCurrency,
    this.selectedToCurrency,
    required this.fromCurrencies,
    required this.toCurrencies,
    required this.onFromCurrencySelected,
    required this.onToCurrencySelected,
    required this.onSwap,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double borderRadius = SizeTokens.borderRadius;
        final double swapButtonSize = SizeTokens.buttonSize;
        final double labelFontSize = SizeTokens.labelFontSize;
        final double horizontalPadding = SizeTokens.horizontalPadding;
        final double verticalPadding = SizeTokens.verticalPadding;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: EdgeInsets.only(top: labelFontSize / 2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorTokens.primary,
                  width: SizeTokens.borderWidth,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding / 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CurrencyDisplay(
                      selectedCurrency: selectedFromCurrency,
                      availableCurrencies: fromCurrencies,
                      onCurrencySelected: onFromCurrencySelected,
                    ),
                    SizedBox(width: swapButtonSize),
                    CurrencyDisplay(
                      selectedCurrency: selectedToCurrency,
                      availableCurrencies: toCurrencies,
                      onCurrencySelected: onToCurrencySelected,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: horizontalPadding,
              top: 0,
              child: _CurrencyLabel(
                label: L10n.of(context).fromCurrencyLabel,
                labelFontSize: labelFontSize,
              ),
            ),
            Positioned(
              right: horizontalPadding,
              top: 0,
              child: _CurrencyLabel(
                label: L10n.of(context).toCurrencyLabel,
                labelFontSize: labelFontSize,
              ),
            ),
            Positioned(
              top: SizeTokens.swapButtonVerticalOffset,
              left: 0,
              right: 0,
              child: Center(
                child: SwapButton(
                  swapButtonSize: swapButtonSize,
                  onSwap: onSwap,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CurrencyLabel extends StatelessWidget {
  final String label;
  final double labelFontSize;

  const _CurrencyLabel({required this.label, required this.labelFontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeTokens.spacingSmall),
      color: ColorTokens.white,
      child: Text(
        label,
        style: TextStyle(
          fontSize: labelFontSize,
          fontWeight: FontWeight.bold,
          color: ColorTokens.text,
        ),
      ),
    );
  }
}
