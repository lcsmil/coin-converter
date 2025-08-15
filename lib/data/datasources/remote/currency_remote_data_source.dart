import 'package:coin_converter/data/models/exchange_rate_model.dart';

abstract class CurrencyRemoteDataSource {
  Future<ExchangeRateModel> getExchangeRate({
    required String fromCurrencyId,
    required String toCurrencyId,
    required double amount,
    required String amountCurrencyId,
  });
}
