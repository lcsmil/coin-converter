import 'dart:convert';
import 'package:coin_converter/core/errors/exceptions.dart';
import 'package:coin_converter/core/utils/logger.dart';
import 'package:coin_converter/data/datasources/local/currency_local_data_source.dart';
import 'package:coin_converter/data/models/exchange_rate_model.dart';
import 'package:coin_converter/domain/entities/currency.dart';
import 'package:http/http.dart' as http;
import 'package:coin_converter/core/constants/app_constants.dart';
import 'currency_remote_data_source.dart';

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final http.Client client;
  final CurrencyLocalDataSource localDataSource;

  CurrencyRemoteDataSourceImpl({
    http.Client? client,
    required this.localDataSource,
  }) : client = client ?? http.Client();

  @override
  Future<ExchangeRateModel> getExchangeRate({
    required String fromCurrencyId,
    required String toCurrencyId,
    required double amount,
    required String amountCurrencyId,
  }) async {
    try {
      final fromCurrency = localDataSource.getCurrencyById(fromCurrencyId);
      final toCurrency = localDataSource.getCurrencyById(toCurrencyId);

      if (fromCurrency == null || toCurrency == null) {
        throw AppException(
          'Invalid currency ID',
          GenericFailure('Invalid currency ID'),
        );
      }

      final bool fromIsCrypto = fromCurrency.type == CurrencyType.crypto;
      final bool toIsCrypto = toCurrency.type == CurrencyType.crypto;

      if (fromIsCrypto == toIsCrypto) {
        throw AppException(
          'Unsupported pair',
          GenericFailure(
            'Unsupported pair. Use crypto-to-fiat or fiat-to-crypto.',
          ),
        );
      }

      final bool cryptoToFiat = fromIsCrypto && !toIsCrypto;
      final int type = cryptoToFiat ? 0 : 1;

      final String cryptoId = cryptoToFiat ? fromCurrencyId : toCurrencyId;
      final String fiatId = cryptoToFiat ? toCurrencyId : fromCurrencyId;

      final uri = Uri.parse(AppConstants.baseUrl).replace(
        queryParameters: {
          'type': type.toString(),
          'cryptoCurrencyId': cryptoId,
          'fiatCurrencyId': fiatId,
          'amount': amount.toString(),
          'amountCurrencyId': amountCurrencyId,
        },
      );

      ApiLogger.logRequest(uri);

      final response = await client.get(uri);

      ApiLogger.logResponse(response.statusCode, response.body);
      if (response.statusCode != 200) {
        ApiLogger.logError(
          'Failed to fetch exchange rate',
          'Status code: ${response.statusCode}',
        );
        throw AppException(
          'Failed to fetch exchange rate',
          ServerFailure(
            'Failed to fetch exchange rate: ${response.statusCode}',
          ),
        );
      }

      try {
        final Map<String, dynamic> jsonData =
            json.decode(response.body) as Map<String, dynamic>;

        try {
          final exchangeRate = ExchangeRateModel.fromApiResponse(
            jsonData,
            fromCurrency,
            toCurrency,
            cryptoToFiat,
          );
          return exchangeRate;
        } catch (e) {
          ApiLogger.logError('Failed to parse exchange rate data', e);
          throw AppException(
            'Failed to parse exchange rate data',
            ServerFailure('Failed to parse exchange rate data: $e'),
          );
        }
      } catch (e) {
        ApiLogger.logError('Failed to parse JSON response', e);
        throw AppException(
          'Failed to parse response',
          ServerFailure('Failed to parse response: $e'),
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AppException(
        'Failed to fetch exchange rate',
        ServerFailure('Failed to fetch exchange rate: ${e.toString()}'),
      );
    }
  }
}
