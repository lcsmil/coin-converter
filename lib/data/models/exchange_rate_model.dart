import '../../domain/entities/exchange_rate.dart';
import '../../domain/entities/currency.dart';

class ExchangeRateModel extends ExchangeRate {
  const ExchangeRateModel({
    required super.fromCurrency,
    required super.toCurrency,
    required super.rate,
  });
  
  factory ExchangeRateModel.fromApiResponse(Map<String, dynamic> response, Currency fromCurrency, Currency toCurrency, bool cryptoToFiat) {
    final dynamic byPrice = response['data']?['byPrice'];
    if (byPrice == null || byPrice['fiatToCryptoExchangeRate'] == null) {
      throw Exception('Invalid API response');
    }
    
    final double fiatToCryptoRate = double.parse(byPrice['fiatToCryptoExchangeRate']);
    
    // fiatToCryptoRate represents how many crypto units you get for 1 fiat unit
    // For fiat->crypto: use the rate directly (multiply amount by rate)
    // For crypto->fiat: use the inverse (divide amount by rate)
    final double rate = cryptoToFiat ? fiatToCryptoRate : (1 / fiatToCryptoRate);
    
    return ExchangeRateModel(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      rate: rate,
    );
  }

  ExchangeRateModel copyWith({
    Currency? fromCurrency,
    Currency? toCurrency,
    double? rate,
  }) {
    return ExchangeRateModel(
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      rate: rate ?? this.rate,
    );
  }
}
