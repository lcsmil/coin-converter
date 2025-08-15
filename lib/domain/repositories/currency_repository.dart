import '../entities/currency.dart';
import '../entities/exchange_rate.dart';

abstract class CurrencyRepository {
  List<Currency> getAvailableCurrencies();
  Future<ExchangeRate> getExchangeRate({
    required String fromCurrencyId,
    required String toCurrencyId,
    required double amount,
    required String amountCurrencyId,
  });
}
