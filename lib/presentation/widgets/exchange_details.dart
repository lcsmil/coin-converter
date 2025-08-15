import 'package:flutter/material.dart';
import '../../core/constants/color_tokens.dart';
import '../../core/utils/l10n_helper.dart';
import '../../core/constants/size_tokens.dart';

class ExchangeDetails extends StatelessWidget {
  final double? exchangeRate;
  final double convertedAmount;
  final String? toCurrencySymbol;
  final bool isVisible;

  const ExchangeDetails({
    super.key,
    this.exchangeRate,
    required this.convertedAmount,
    this.toCurrencySymbol,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible || exchangeRate == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        _DetailRow(
          label: L10n.of(context).estimatedRateLabel,
          value:
              '≈ ${exchangeRate!.toStringAsFixed(2)} ${toCurrencySymbol ?? ''}',
        ),
        SizedBox(height: SizeTokens.spacingMedium),
        _DetailRow(
          label: L10n.of(context).youWillReceiveLabel,
          value:
              '≈ ${convertedAmount.toStringAsFixed(2)} ${toCurrencySymbol ?? ''}',
        ),
        SizedBox(height: SizeTokens.spacingMedium),
        _DetailRow(
          label: L10n.of(context).estimatedTimeLabel,
          value: '≈ 10 Min',
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: SizeTokens.bodyFontSize,
            color: ColorTokens.textLight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: SizeTokens.bodyFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
