import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:coin_converter/domain/entities/currency.dart';
import 'package:coin_converter/data/repositories/currency_repository_impl.dart';
import 'package:coin_converter/data/datasources/local/currency_local_data_source.dart';
import 'package:coin_converter/data/datasources/remote/currency_remote_data_source.dart';
import 'package:coin_converter/data/models/currency_model.dart';
import 'package:coin_converter/data/models/exchange_rate_model.dart';
import 'package:coin_converter/core/errors/exceptions.dart';

class MockCurrencyLocalDataSource extends Mock implements CurrencyLocalDataSource {}
class MockCurrencyRemoteDataSource extends Mock implements CurrencyRemoteDataSource {}

void main() {
  late CurrencyRepositoryImpl repository;
  late MockCurrencyLocalDataSource mockLocalDataSource;
  late MockCurrencyRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockLocalDataSource = MockCurrencyLocalDataSource();
    mockRemoteDataSource = MockCurrencyRemoteDataSource();
    repository = CurrencyRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('CurrencyRepositoryImpl', () {
    final tCurrencies = [
      const CurrencyModel(
        id: 'TATUM-TRON-USDT',
        name: 'Tether (USDT)',
        symbol: 'USDT',
        type: CurrencyType.crypto,
      ),
      const CurrencyModel(
        id: 'USD',
        name: 'US Dollar',
        symbol: 'USD',
        type: CurrencyType.fiat,
      ),
      const CurrencyModel(
        id: 'BRL',
        name: 'Real Brasileño',
        symbol: 'BRL',
        type: CurrencyType.fiat,
      ),
    ];

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

    final tExchangeRateModel = ExchangeRateModel(
      fromCurrency: tFromCurrency,
      toCurrency: tToCurrency,
      rate: 0.99,
    );

    group('getAvailableCurrencies', () {
      test('should return list of currencies from local data source', () {
        // arrange
        when(() => mockLocalDataSource.getAvailableCurrencies()).thenReturn(tCurrencies);

        // act
        final result = repository.getAvailableCurrencies();

        // assert
        expect(result, tCurrencies);
        verify(() => mockLocalDataSource.getAvailableCurrencies());
      });

      test('should return empty list when local data source returns empty list', () {
        // arrange
        when(() => mockLocalDataSource.getAvailableCurrencies()).thenReturn([]);

        // act
        final result = repository.getAvailableCurrencies();

        // assert
        expect(result, []);
        verify(() => mockLocalDataSource.getAvailableCurrencies());
      });

      test('should only call local data source', () {
        // arrange
        when(() => mockLocalDataSource.getAvailableCurrencies()).thenReturn(tCurrencies);

        // act
        repository.getAvailableCurrencies();

        // assert
        verify(() => mockLocalDataSource.getAvailableCurrencies());
        verifyNever(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: any(named: 'fromCurrencyId'),
          toCurrencyId: any(named: 'toCurrencyId'),
          amount: any(named: 'amount'),
          amountCurrencyId: any(named: 'amountCurrencyId'),
        ));
      });

      test('should return currencies as domain entities', () {
        // arrange
        when(() => mockLocalDataSource.getAvailableCurrencies()).thenReturn(tCurrencies);

        // act
        final result = repository.getAvailableCurrencies();

        // assert
        expect(result, isA<List<Currency>>());
        for (final currency in result) {
          expect(currency, isA<Currency>());
        }
      });

      test('should handle multiple calls correctly', () {
        // arrange
        when(() => mockLocalDataSource.getAvailableCurrencies()).thenReturn(tCurrencies);

        // act
        final result1 = repository.getAvailableCurrencies();
        final result2 = repository.getAvailableCurrencies();

        // assert
        expect(result1, result2);
        verify(() => mockLocalDataSource.getAvailableCurrencies()).called(2);
      });
    });

    group('getExchangeRate', () {
      const tFromCurrencyId = 'TATUM-TRON-USDT';
      const tToCurrencyId = 'USD';
      const tAmount = 100.0;
      const tAmountCurrencyId = 'USD';

      test('should return exchange rate from remote data source', () async {
        // arrange
        when(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: any(named: 'fromCurrencyId'),
          toCurrencyId: any(named: 'toCurrencyId'),
          amount: any(named: 'amount'),
          amountCurrencyId: any(named: 'amountCurrencyId'),
        )).thenAnswer((_) async => tExchangeRateModel);

        // act
        final result = await repository.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tAmount,
          amountCurrencyId: tAmountCurrencyId,
        );

        // assert
        expect(result, tExchangeRateModel);
        verify(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tAmount,
          amountCurrencyId: tAmountCurrencyId,
        ));
      });

      test('should call remote data source with correct parameters', () async {
        // arrange
        when(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: any(named: 'fromCurrencyId'),
          toCurrencyId: any(named: 'toCurrencyId'),
          amount: any(named: 'amount'),
          amountCurrencyId: any(named: 'amountCurrencyId'),
        )).thenAnswer((_) async => tExchangeRateModel);

        // act
        await repository.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tAmount,
          amountCurrencyId: tAmountCurrencyId,
        );

        // assert
        verify(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tAmount,
          amountCurrencyId: tAmountCurrencyId,
        )).called(1);
      });

      test('should rethrow AppException when remote data source throws AppException', () async {
        // arrange
        final tException = AppException('Test error', ServerFailure('Server error'));
        when(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: any(named: 'fromCurrencyId'),
          toCurrencyId: any(named: 'toCurrencyId'),
          amount: any(named: 'amount'),
          amountCurrencyId: any(named: 'amountCurrencyId'),
        )).thenThrow(tException);

        // act & assert
        expect(
          () async => await repository.getExchangeRate(
            fromCurrencyId: tFromCurrencyId,
            toCurrencyId: tToCurrencyId,
            amount: tAmount,
            amountCurrencyId: tAmountCurrencyId,
          ),
          throwsA(isA<AppException>().having(
            (e) => e.message,
            'message',
            'Test error',
          )),
        );
      });

      test('should wrap generic exception in AppException', () async {
        // arrange
        const tGenericException = 'Generic error';
        when(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: any(named: 'fromCurrencyId'),
          toCurrencyId: any(named: 'toCurrencyId'),
          amount: any(named: 'amount'),
          amountCurrencyId: any(named: 'amountCurrencyId'),
        )).thenThrow(tGenericException);

        // act & assert
        expect(
          () async => await repository.getExchangeRate(
            fromCurrencyId: tFromCurrencyId,
            toCurrencyId: tToCurrencyId,
            amount: tAmount,
            amountCurrencyId: tAmountCurrencyId,
          ),
          throwsA(isA<AppException>().having(
            (e) => e.message,
            'message',
            'Failed to get exchange rate',
          )),
        );
      });
      test('should handle different currency combinations', () async {
        // Arrange
        const tEthId = 'ETH';
        const tEurId = 'EUR';
        final tEthCurrency = const CurrencyModel(
          id: 'ETH',
          name: 'Ethereum',
          symbol: 'ETH',
          type: CurrencyType.crypto,
        );
        final tEurCurrency = const CurrencyModel(
          id: 'EUR',
          name: 'Euro',
          symbol: 'EUR',
          type: CurrencyType.fiat,
        );
        final tEthEurRate = ExchangeRateModel(
          fromCurrency: tEthCurrency,
          toCurrency: tEurCurrency,
          rate: 3000.0,
        );

        when(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: tEthId,
          toCurrencyId: tEurId,
          amount: tAmount,
          amountCurrencyId: tEurId,
        )).thenAnswer((_) async => tEthEurRate);

        // Act
        final result = await repository.getExchangeRate(
          fromCurrencyId: tEthId,
          toCurrencyId: tEurId,
          amount: tAmount,
          amountCurrencyId: tEurId,
        );

        // Assert
        expect(result, tEthEurRate);
        expect(result.fromCurrency.id, tEthId);
        expect(result.toCurrency.id, tEurId);
        expect(result.rate, 3000.0);
      });

      test('should handle zero amount correctly', () async {
        // arrange
        const tZeroAmount = 0.0;
        when(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tZeroAmount,
          amountCurrencyId: tAmountCurrencyId,
        )).thenAnswer((_) async => tExchangeRateModel);

        // act
        final result = await repository.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tZeroAmount,
          amountCurrencyId: tAmountCurrencyId,
        );

        // assert
        expect(result, tExchangeRateModel);
        verify(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tZeroAmount,
          amountCurrencyId: tAmountCurrencyId,
        ));
      });

      test('should handle large amounts correctly', () async {
        // arrange
        const tLargeAmount = 1000000.0;
        when(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tLargeAmount,
          amountCurrencyId: tAmountCurrencyId,
        )).thenAnswer((_) async => tExchangeRateModel);

        // act
        final result = await repository.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tLargeAmount,
          amountCurrencyId: tAmountCurrencyId,
        );

        // assert
        expect(result, tExchangeRateModel);
        verify(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tLargeAmount,
          amountCurrencyId: tAmountCurrencyId,
        ));
      });

      test('should handle decimal amounts correctly', () async {
        // arrange
        const tDecimalAmount = 123.456;
        when(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tDecimalAmount,
          amountCurrencyId: tAmountCurrencyId,
        )).thenAnswer((_) async => tExchangeRateModel);

        // act
        final result = await repository.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tDecimalAmount,
          amountCurrencyId: tAmountCurrencyId,
        );

        // assert
        expect(result, tExchangeRateModel);
        verify(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tDecimalAmount,
          amountCurrencyId: tAmountCurrencyId,
        ));
      });
    });

    group('integration scenarios', () {
      test('should handle repository operations independently', () async {
        // arrange
        when(() => mockLocalDataSource.getAvailableCurrencies()).thenReturn(tCurrencies);
        when(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: any(named: 'fromCurrencyId'),
          toCurrencyId: any(named: 'toCurrencyId'),
          amount: any(named: 'amount'),
          amountCurrencyId: any(named: 'amountCurrencyId'),
        )).thenAnswer((_) async => tExchangeRateModel);

        // act
        final currencies = repository.getAvailableCurrencies();
        final exchangeRate = await repository.getExchangeRate(
          fromCurrencyId: 'TATUM-TRON-USDT',
          toCurrencyId: 'USD',
          amount: 100.0,
          amountCurrencyId: 'USD',
        );

        // assert
        expect(currencies, tCurrencies);
        expect(exchangeRate, tExchangeRateModel);
        verify(() => mockLocalDataSource.getAvailableCurrencies());
        verify(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: 'TATUM-TRON-USDT',
          toCurrencyId: 'USD',
          amount: 100.0,
          amountCurrencyId: 'USD',
        ));
      });

      test('should not affect local operations when remote operations fail', () async {
        // arrange
        when(() => mockLocalDataSource.getAvailableCurrencies()).thenReturn(tCurrencies);
        when(() => mockRemoteDataSource.getExchangeRate(
          fromCurrencyId: any(named: 'fromCurrencyId'),
          toCurrencyId: any(named: 'toCurrencyId'),
          amount: any(named: 'amount'),
          amountCurrencyId: any(named: 'amountCurrencyId'),
        )).thenThrow(AppException('Network error', ServerFailure('Network error')));

        // act & assert
        final currencies = repository.getAvailableCurrencies();
        expect(currencies, tCurrencies);

        expect(
          () async => await repository.getExchangeRate(
            fromCurrencyId: 'TATUM-TRON-USDT',
            toCurrencyId: 'USD',
            amount: 100.0,
            amountCurrencyId: 'USD',
          ),
          throwsA(isA<AppException>()),
        );
      });
    });
  });
}
