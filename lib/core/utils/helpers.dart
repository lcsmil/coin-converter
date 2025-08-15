import 'package:flutter/services.dart';
import '../../domain/entities/currency.dart';

class Helper {
  static String getCurrencyImagePath(Currency currency) {
    if (currency.type == CurrencyType.crypto) {
      return 'assets/cripto_currencies/${currency.id}.png';
    } else {
      return 'assets/fiat_currencies/${currency.id}.png';
    }
  }

  static final FilteringTextInputFormatter decimalInputFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'));
}
