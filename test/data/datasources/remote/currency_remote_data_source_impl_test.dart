import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:coin_converter/data/datasources/remote/currency_remote_data_source_impl.dart';
import 'package:coin_converter/data/datasources/local/currency_local_data_source.dart';
import 'package:coin_converter/data/models/currency_model.dart';
import 'package:coin_converter/domain/entities/currency.dart';
import 'package:coin_converter/core/errors/exceptions.dart';

class MockClient extends Mock implements http.Client {}
class MockCurrencyLocalDataSource extends Mock implements CurrencyLocalDataSource {}

void main() {
  late CurrencyRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;
  late MockCurrencyLocalDataSource mockLocalDataSource;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  setUp(() {
    mockHttpClient = MockClient();
    mockLocalDataSource = MockCurrencyLocalDataSource();
    dataSource = CurrencyRemoteDataSourceImpl(
      client: mockHttpClient,
      localDataSource: mockLocalDataSource,
    );
  });

  group('CurrencyRemoteDataSourceImpl', () {
    const tFromCurrencyId = 'TATUM-TRON-USDT';
    const tToCurrencyId = 'USD';
    const tAmount = 100.0;
    const tAmountCurrencyId = 'USD';

    final tFromCurrency = const CurrencyModel(
      id: 'TATUM-TRON-USDT',
      name: 'Tether (USDT)',
      symbol: 'USDT',
      type: CurrencyType.crypto,
    );

    final tToCurrency = const CurrencyModel(
      id: 'USD',
      name: 'US Dollar',
      symbol: 'USD',
      type: CurrencyType.fiat,
    );

    final tApiResponse = {
      'data': {
        'byPrice': {
          'fiatToCryptoExchangeRate': '0.00002',
        }
      }
    };

    group('getExchangeRate', () {
      test('should perform GET request on correct URL for crypto to fiat', () async {
        // arrange
        when(() => mockLocalDataSource.getCurrencyById(tFromCurrencyId))
            .thenReturn(tFromCurrency);
        when(() => mockLocalDataSource.getCurrencyById(tToCurrencyId))
            .thenReturn(tToCurrency);
        when(() => mockHttpClient.get(any()))
            .thenAnswer((_) async => http.Response(json.encode(tApiResponse), 200));

        // act
        await dataSource.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tAmount,
          amountCurrencyId: tAmountCurrencyId,
        );

        // assert
        verify(() => mockHttpClient.get(any(that: predicate<Uri>((uri) {
          return uri.queryParameters['type'] == '0' && // crypto to fiat
                 uri.queryParameters['cryptoCurrencyId'] == tFromCurrencyId &&
                 uri.queryParameters['fiatCurrencyId'] == tToCurrencyId &&
                 uri.queryParameters['amount'] == tAmount.toString() &&
                 uri.queryParameters['amountCurrencyId'] == tAmountCurrencyId;
        }))));
      });

      test('should perform GET request on correct URL for fiat to crypto', () async {
        // arrange
        when(() => mockLocalDataSource.getCurrencyById(tToCurrencyId))
            .thenReturn(tToCurrency);
        when(() => mockLocalDataSource.getCurrencyById(tFromCurrencyId))
            .thenReturn(tFromCurrency);
        when(() => mockHttpClient.get(any()))
            .thenAnswer((_) async => http.Response(json.encode(tApiResponse), 200));

        // act
        await dataSource.getExchangeRate(
          fromCurrencyId: tToCurrencyId,
          toCurrencyId: tFromCurrencyId,
          amount: tAmount,
          amountCurrencyId: tAmountCurrencyId,
        );

        // assert
        verify(() => mockHttpClient.get(any(that: predicate<Uri>((uri) {
          return uri.queryParameters['type'] == '1' && // fiat to crypto
                 uri.queryParameters['fiatCurrencyId'] == tToCurrencyId &&
                 uri.queryParameters['cryptoCurrencyId'] == tFromCurrencyId &&
                 uri.queryParameters['amount'] == tAmount.toString() &&
                 uri.queryParameters['amountCurrencyId'] == tAmountCurrencyId;
        }))));
      });

      test('should return ExchangeRateModel when request is successful', () async {
        // arrange
        when(() => mockLocalDataSource.getCurrencyById(tFromCurrencyId))
            .thenReturn(tFromCurrency);
        when(() => mockLocalDataSource.getCurrencyById(tToCurrencyId))
            .thenReturn(tToCurrency);
        when(() => mockHttpClient.get(any()))
            .thenAnswer((_) async => http.Response(json.encode(tApiResponse), 200));

        // Act
        final result = await dataSource.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tAmount,
          amountCurrencyId: tAmountCurrencyId,
        );

        // Assert
        expect(result.fromCurrency, tFromCurrency);
        expect(result.toCurrency, tToCurrency);
        expect(result.rate, 0.00002);
      });

      test('should throw AppException when fromCurrency is not found', () async {
        // arrange
        when(() => mockLocalDataSource.getCurrencyById(tFromCurrencyId))
            .thenReturn(null);
        when(() => mockLocalDataSource.getCurrencyById(tToCurrencyId))
            .thenReturn(tToCurrency);

        // Act & Assert
        expect(
          () async => await dataSource.getExchangeRate(
            fromCurrencyId: tFromCurrencyId,
            toCurrencyId: tToCurrencyId,
            amount: tAmount,
            amountCurrencyId: tAmountCurrencyId,
          ),
          throwsA(isA<AppException>().having(
            (e) => e.message,
            'message',
            'Invalid currency ID',
          )),
        );
      });

      test('should throw AppException when toCurrency is not found', () async {
        // Arrange
        when(() => mockLocalDataSource.getCurrencyById(tFromCurrencyId))
            .thenReturn(tFromCurrency);
        when(() => mockLocalDataSource.getCurrencyById(tToCurrencyId))
            .thenReturn(null);

        // Act & Assert
        expect(
          () async => await dataSource.getExchangeRate(
            fromCurrencyId: tFromCurrencyId,
            toCurrencyId: tToCurrencyId,
            amount: tAmount,
            amountCurrencyId: tAmountCurrencyId,
          ),
          throwsA(isA<AppException>().having(
            (e) => e.message,
            'message',
            'Invalid currency ID',
          )),
        );
      });

      test('should throw AppException when both currencies are of same type', () async {
        // Arrange
        final tCryptoCurrency1 = const CurrencyModel(
          id: 'BTC',
          name: 'Bitcoin',
          symbol: 'BTC',
          type: CurrencyType.crypto,
        );
        final tCryptoCurrency2 = const CurrencyModel(
          id: 'ETH',
          name: 'Ethereum',
          symbol: 'ETH',
          type: CurrencyType.crypto,
        );

        when(() => mockLocalDataSource.getCurrencyById('BTC'))
            .thenReturn(tCryptoCurrency1);
        when(() => mockLocalDataSource.getCurrencyById('ETH'))
            .thenReturn(tCryptoCurrency2);

        // Act & Assert
        expect(
          () async => await dataSource.getExchangeRate(
            fromCurrencyId: 'BTC',
            toCurrencyId: 'ETH',
            amount: tAmount,
            amountCurrencyId: 'BTC',
          ),
          throwsA(isA<AppException>().having(
            (e) => e.message,
            'message',
            'Unsupported pair',
          )),
        );
      });

      test('should throw AppException when HTTP request fails', () async {
        // arrange
        when(() => mockLocalDataSource.getCurrencyById(tFromCurrencyId))
            .thenReturn(tFromCurrency);
        when(() => mockLocalDataSource.getCurrencyById(tToCurrencyId))
            .thenReturn(tToCurrency);
        when(() => mockHttpClient.get(any()))
            .thenAnswer((_) async => http.Response('Error', 500));

        // Act & Assert
        expect(
          () async => await dataSource.getExchangeRate(
            fromCurrencyId: tFromCurrencyId,
            toCurrencyId: tToCurrencyId,
            amount: tAmount,
            amountCurrencyId: tAmountCurrencyId,
          ),
          throwsA(isA<AppException>().having(
            (e) => e.message,
            'message',
            'Failed to fetch exchange rate',
          )),
        );
      });

      test('should throw AppException when response is not valid JSON', () async {
        // arrange
        when(() => mockLocalDataSource.getCurrencyById(tFromCurrencyId))
            .thenReturn(tFromCurrency);
        when(() => mockLocalDataSource.getCurrencyById(tToCurrencyId))
            .thenReturn(tToCurrency);
        when(() => mockHttpClient.get(any()))
            .thenAnswer((_) async => http.Response('Invalid JSON', 200));

        // Act & Assert
        expect(
          () async => await dataSource.getExchangeRate(
            fromCurrencyId: tFromCurrencyId,
            toCurrencyId: tToCurrencyId,
            amount: tAmount,
            amountCurrencyId: tAmountCurrencyId,
          ),
          throwsA(isA<AppException>().having(
            (e) => e.message,
            'message',
            'Failed to parse response',
          )),
        );
      });

      test('should throw AppException when API response format is invalid', () async {
        // Arrange
        final invalidApiResponse = {
          'data': {
            'invalidField': 'value'
          }
        };

        when(() => mockLocalDataSource.getCurrencyById(tFromCurrencyId))
            .thenReturn(tFromCurrency);
        when(() => mockLocalDataSource.getCurrencyById(tToCurrencyId))
            .thenReturn(tToCurrency);
        when(() => mockHttpClient.get(any()))
            .thenAnswer((_) async => http.Response(json.encode(invalidApiResponse), 200));

        // Act & Assert
        expect(
          () async => await dataSource.getExchangeRate(
            fromCurrencyId: tFromCurrencyId,
            toCurrencyId: tToCurrencyId,
            amount: tAmount,
            amountCurrencyId: tAmountCurrencyId,
          ),
          throwsA(isA<AppException>().having(
            (e) => e.message,
            'message',
            'Failed to parse response',
          )),
        );
      });

      test('should handle network exceptions gracefully', () async {
        // arrange
        when(() => mockLocalDataSource.getCurrencyById(tFromCurrencyId))
            .thenReturn(tFromCurrency);
        when(() => mockLocalDataSource.getCurrencyById(tToCurrencyId))
            .thenReturn(tToCurrency);
        when(() => mockHttpClient.get(any()))
            .thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () async => await dataSource.getExchangeRate(
            fromCurrencyId: tFromCurrencyId,
            toCurrencyId: tToCurrencyId,
            amount: tAmount,
            amountCurrencyId: tAmountCurrencyId,
          ),
          throwsA(isA<AppException>().having(
            (e) => e.message,
            'message',
            'Failed to fetch exchange rate',
          )),
        );
      });

      test('should correctly calculate rate for different amounts', () async {
        // arrange
        const differentAmount = 500.0;
        when(() => mockLocalDataSource.getCurrencyById(tFromCurrencyId))
            .thenReturn(tFromCurrency);
        when(() => mockLocalDataSource.getCurrencyById(tToCurrencyId))
            .thenReturn(tToCurrency);
        when(() => mockHttpClient.get(any()))
            .thenAnswer((_) async => http.Response(json.encode(tApiResponse), 200));

        // Act
        final result = await dataSource.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: differentAmount,
          amountCurrencyId: tAmountCurrencyId,
        );

        // Assert
        expect(result.rate, 0.00002); // Rate should be independent of amount
        verify(() => mockHttpClient.get(any(that: predicate<Uri>((uri) {
          return uri.queryParameters['amount'] == differentAmount.toString();
        }))));
      });
    });
  });
}
