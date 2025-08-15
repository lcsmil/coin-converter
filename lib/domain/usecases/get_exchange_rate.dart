import '../entities/exchange_rate.dart';
import '../repositories/currency_repository.dart';
import '../../core/errors/exceptions.dart';

class GetExchangeRate {
  final CurrencyRepository repository;

  GetExchangeRate(this.repository);

  Future<ExchangeRate> call({
    required String fromCurrencyId,
    required String toCurrencyId,
    required double amount,
    required String amountCurrencyId,
  }) async {
    try {
      return await repository.getExchangeRate(
        fromCurrencyId: fromCurrencyId,
        toCurrencyId: toCurrencyId,
        amount: amount,
        amountCurrencyId: amountCurrencyId,
      );
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AppException('Failed to get exchange rate: ${e.toString()}', ServerFailure(e.toString()));
    }
  }
}
