import 'package:coin_converter/data/datasources/local/currency_local_data_source.dart';
import 'package:coin_converter/data/datasources/remote/currency_remote_data_source.dart';

import '../../domain/entities/currency.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../core/errors/exceptions.dart';


class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  List<Currency> getAvailableCurrencies() {
    return localDataSource.getAvailableCurrencies();
  }

  @override
  Future<ExchangeRate> getExchangeRate({
    required String fromCurrencyId,
    required String toCurrencyId,
    required double amount,
    required String amountCurrencyId,
  }) async {
    try {
      return await remoteDataSource.getExchangeRate(
        fromCurrencyId: fromCurrencyId,
        toCurrencyId: toCurrencyId,
        amount: amount,
        amountCurrencyId: amountCurrencyId,
      );
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AppException('Failed to get exchange rate', ServerFailure('Failed to get exchange rate: ${e.toString()}'));
    }
  }
}
