import 'dart:async';

import 'package:flutter/material.dart';
import '../../core/constants/size_tokens.dart';
import '../../core/constants/color_tokens.dart';
import '../../core/utils/helpers.dart';

class AmountInput extends StatefulWidget {
  final String? fromCurrencySymbol;
  final ValueChanged<double> onAmountChanged;
  final bool isVisible;
  final double currentAmount;

  const AmountInput({
    super.key,
    this.fromCurrencySymbol,
    required this.onAmountChanged,
    required this.isVisible,
    this.currentAmount = 0.0,
  });

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _updateControllerText();
  }

  @override
  void didUpdateWidget(AmountInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentAmount != widget.currentAmount) {
      _updateControllerText();
    }
  }

  void _updateControllerText() {
    final text = widget.currentAmount > 0 
        ? _formatAmount(widget.currentAmount)
        : '';
    if (_controller.text != text) {
      _controller.text = text;
    }
  }

  String _formatAmount(double amount) {
    // Remove unnecessary decimal places
    if (amount == amount.roundToDouble()) {
      return amount.toInt().toString();
    } else {
      return amount.toString();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible || widget.fromCurrencySymbol == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeTokens.horizontalPadding,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorTokens.primary,
          width: SizeTokens.borderWidth,
        ),
        borderRadius: BorderRadius.circular(SizeTokens.borderRadius / 2),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: SizeTokens.horizontalPadding / 2,
            ),
            child: Text(
              widget.fromCurrencySymbol!,
              style: TextStyle(
                fontSize: SizeTokens.titleFontSize,
                fontWeight: FontWeight.w600,
                color: ColorTokens.primary,
              ),
            ),
          ),
          Expanded(
            child: _AmountTextField(
              controller: _controller,
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 250), () {
                  final amount = double.tryParse(value) ?? 0.0;
                  widget.onAmountChanged(amount);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _AmountTextField({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      inputFormatters: [Helper.decimalInputFormatter],
      style: TextStyle(
        fontSize: SizeTokens.titleFontSize,
        fontWeight: FontWeight.w600,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: '0.00',
      ),
      onChanged: onChanged,
    );
  }
}
