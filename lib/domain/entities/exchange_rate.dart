import 'currency.dart';

class ExchangeRate {
  final Currency fromCurrency;
  final Currency toCurrency;
  final double rate;

  const ExchangeRate({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
  });

  /// Converts an amount from the source currency to the target currency
  /// using the exchange rate
  double convertAmount(double amount) {
    return amount * rate;
  }
}
