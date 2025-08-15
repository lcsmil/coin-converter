import 'package:flutter/material.dart';
import '../../domain/entities/currency.dart';
import '../../core/constants/size_tokens.dart';
import '../../core/utils/l10n_helper.dart';
import '../../core/utils/helpers.dart';
import '../../core/constants/color_tokens.dart';

void showCurrencyPickerBottomSheet(
  BuildContext context,
  List<Currency> currencies,
  Function(Currency) onCurrencySelected,
) {
  final double iconSize = SizeTokens.iconSize;
  final double fontSize = SizeTokens.titleFontSize;
  final double subtitleSize = SizeTokens.bodyFontSize;

  final String title = currencies.isNotEmpty && currencies.first.type == CurrencyType.fiat
      ? L10n.of(context).fiatCurrencyTitle
      : L10n.of(context).cryptoCurrencyTitle;
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: ColorTokens.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(SizeTokens.modalSheetBorderRadius)),
    ),
    builder: (context) => Container(
      padding: EdgeInsets.all(SizeTokens.modalSheetPadding),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: SizeTokens.dragHandleWidth,
            height: SizeTokens.dragHandleHeight,
            margin: EdgeInsets.only(bottom: SizeTokens.modalSheetPadding),
            decoration: BoxDecoration(
              color: ColorTokens.textLight,
              borderRadius: BorderRadius.circular(SizeTokens.dragHandleBorderRadius),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: SizeTokens.modalSheetPadding),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                return _CurrencyPickerListItem(
                  currency: currency,
                  onCurrencySelected: onCurrencySelected,
                  iconSize: iconSize,
                  subtitleSize: subtitleSize,
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class _CurrencyPickerListItem extends StatelessWidget {
  final Currency currency;
  final Function(Currency) onCurrencySelected;
  final double iconSize;
  final double subtitleSize;

  const _CurrencyPickerListItem({
    required this.currency,
    required this.onCurrencySelected,
    required this.iconSize,
    required this.subtitleSize,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: SizeTokens.modalSheetPadding,
        vertical: SizeTokens.spacingSmall,
      ),
      leading: Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(iconSize / 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(iconSize / 2),
          child: Image.asset(
            Helper.getCurrencyImagePath(currency),
            width: iconSize,
            height: iconSize,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        currency.symbol,
        style: TextStyle(fontSize: SizeTokens.mediumFontSize),
      ),
      subtitle: Text(
        currency.name,
        style: TextStyle(fontSize: subtitleSize),
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        onCurrencySelected(currency);
        Navigator.pop(context);
      },
    );
  }
}
