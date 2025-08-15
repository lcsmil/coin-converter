import 'package:coin_converter/core/constants/size_tokens.dart';
import 'package:coin_converter/core/utils/helpers.dart';
import 'package:coin_converter/domain/entities/currency.dart';
import 'package:coin_converter/presentation/widgets/currency_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import '../../core/constants/color_tokens.dart';

class CurrencyDisplay extends StatelessWidget {
  final Currency? selectedCurrency;
  final List<Currency> availableCurrencies;
  final ValueChanged<Currency> onCurrencySelected;

  const CurrencyDisplay({
    super.key,
    required this.selectedCurrency,
    required this.availableCurrencies,
    required this.onCurrencySelected,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = SizeTokens.iconSize;
    final double codeFontSize = SizeTokens.bodyFontSize;

    final currencyToShow = selectedCurrency ?? availableCurrencies.first;

    return GestureDetector(
      onTap: () => showCurrencyPickerBottomSheet(
        context,
        availableCurrencies,
        onCurrencySelected,
      ),
      child: Row(
        children: [
          Image.asset(
            Helper.getCurrencyImagePath(currencyToShow),
            width: iconSize,
            height: iconSize,
            fit: BoxFit.cover,
          ),
          SizedBox(width: SizeTokens.spacingSmall),
          Text(
            currencyToShow.symbol,
            style: TextStyle(
              fontSize: codeFontSize,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: SizeTokens.spacingExtraSmall),
          Icon(
            Icons.keyboard_arrow_down,
            color: ColorTokens.textLight,
            size: SizeTokens.arrowIconSize,
          ),
        ],
      ),
    );
  }
}
