import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:coin_converter/domain/entities/currency.dart';
import 'package:coin_converter/domain/entities/exchange_rate.dart';
import 'package:coin_converter/domain/repositories/currency_repository.dart';
import 'package:coin_converter/domain/usecases/get_exchange_rate.dart';
import 'package:coin_converter/core/errors/exceptions.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

void main() {
  late GetExchangeRate useCase;
  late MockCurrencyRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrencyRepository();
    useCase = GetExchangeRate(mockRepository);
  });

  group('GetExchangeRate UseCase', () {
    const tFromCurrencyId = 'BTC';
    const tToCurrencyId = 'USD';
    const tAmount = 100.0;
    const tAmountCurrencyId = 'USD';

    final tFromCurrency = const Currency(
      id: 'BTC',
      name: 'Bitcoin',
      symbol: 'BTC',
      type: CurrencyType.crypto,
    );

    final tToCurrency = const Currency(
      id: 'USD',
      name: 'US Dollar',
      symbol: 'USD',
      type: CurrencyType.fiat,
    );

    final tExchangeRate = ExchangeRate(
      fromCurrency: tFromCurrency,
      toCurrency: tToCurrency,
      rate: 50000.0,
    );

    test('should get exchange rate from the repository', () async {
      // arrange
      when(() => mockRepository.getExchangeRate(
        fromCurrencyId: any(named: 'fromCurrencyId'),
        toCurrencyId: any(named: 'toCurrencyId'),
        amount: any(named: 'amount'),
        amountCurrencyId: any(named: 'amountCurrencyId'),
      )).thenAnswer((_) async => tExchangeRate);

      // act
      final result = await useCase.call(
        fromCurrencyId: tFromCurrencyId,
        toCurrencyId: tToCurrencyId,
        amount: tAmount,
        amountCurrencyId: tAmountCurrencyId,
      );

      // assert
      expect(result, equals(tExchangeRate));
      verify(() => mockRepository.getExchangeRate(
        fromCurrencyId: tFromCurrencyId,
        toCurrencyId: tToCurrencyId,
        amount: tAmount,
        amountCurrencyId: tAmountCurrencyId,
      ));
    });

    test('should throw AppException when repository throws AppException', () async {
      // arrange
      final tException = AppException('Test error', ServerFailure('Server error'));
      when(() => mockRepository.getExchangeRate(
        fromCurrencyId: any(named: 'fromCurrencyId'),
        toCurrencyId: any(named: 'toCurrencyId'),
        amount: any(named: 'amount'),
        amountCurrencyId: any(named: 'amountCurrencyId'),
      )).thenThrow(tException);

      // act & assert
      expect(
        () async => await useCase.call(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tAmount,
          amountCurrencyId: tAmountCurrencyId,
        ),
        throwsA(isA<AppException>()),
      );
    });

    test('should wrap generic exception in AppException', () async {
      // arrange
      const tGenericException = 'Generic error';
      when(() => mockRepository.getExchangeRate(
        fromCurrencyId: any(named: 'fromCurrencyId'),
        toCurrencyId: any(named: 'toCurrencyId'),
        amount: any(named: 'amount'),
        amountCurrencyId: any(named: 'amountCurrencyId'),
      )).thenThrow(tGenericException);

      // act & assert
      expect(
        () async => await useCase.call(
          fromCurrencyId: tFromCurrencyId,
          toCurrencyId: tToCurrencyId,
          amount: tAmount,
          amountCurrencyId: tAmountCurrencyId,
        ),
        throwsA(isA<AppException>().having(
          (e) => e.message,
          'message',
          contains('Failed to get exchange rate'),
        )),
      );
    });

    test('should pass correct parameters to repository', () async {
      // arrange
      when(() => mockRepository.getExchangeRate(
        fromCurrencyId: any(named: 'fromCurrencyId'),
        toCurrencyId: any(named: 'toCurrencyId'),
        amount: any(named: 'amount'),
        amountCurrencyId: any(named: 'amountCurrencyId'),
      )).thenAnswer((_) async => tExchangeRate);

      // act
      await useCase.call(
        fromCurrencyId: tFromCurrencyId,
        toCurrencyId: tToCurrencyId,
        amount: tAmount,
        amountCurrencyId: tAmountCurrencyId,
      );

      // assert
      verify(() => mockRepository.getExchangeRate(
        fromCurrencyId: tFromCurrencyId,
        toCurrencyId: tToCurrencyId,
        amount: tAmount,
        amountCurrencyId: tAmountCurrencyId,
      )).called(1);
    });

    test('should work with different currency combinations', () async {
      // arrange
      final cryptoToCrypto = ExchangeRate(
        fromCurrency: const Currency(
          id: 'BTC',
          name: 'Bitcoin',
          symbol: 'BTC',
          type: CurrencyType.crypto,
        ),
        toCurrency: const Currency(
          id: 'ETH',
          name: 'Ethereum',
          symbol: 'ETH',
          type: CurrencyType.crypto,
        ),
        rate: 15.5,
      );

      when(() => mockRepository.getExchangeRate(
        fromCurrencyId: 'BTC',
        toCurrencyId: 'ETH',
        amount: 1.0,
        amountCurrencyId: 'BTC',
      )).thenAnswer((_) async => cryptoToCrypto);

      // act
      final result = await useCase.call(
        fromCurrencyId: 'BTC',
        toCurrencyId: 'ETH',
        amount: 1.0,
        amountCurrencyId: 'BTC',
      );

      // assert
      expect(result, equals(cryptoToCrypto));
      expect(result.fromCurrency.type, equals(CurrencyType.crypto));
      expect(result.toCurrency.type, equals(CurrencyType.crypto));
    });
  });
}
