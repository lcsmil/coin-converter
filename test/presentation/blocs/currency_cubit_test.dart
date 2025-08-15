import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:coin_converter/presentation/blocs/currency_cubit.dart';
import 'package:coin_converter/presentation/blocs/currency_state.dart';
import 'package:coin_converter/domain/entities/currency.dart';
import 'package:coin_converter/domain/entities/exchange_rate.dart';
import 'package:coin_converter/domain/usecases/get_available_currencies.dart';
import 'package:coin_converter/domain/usecases/get_exchange_rate.dart';
import 'package:coin_converter/core/errors/exceptions.dart';

// Mock classes
class MockGetAvailableCurrencies extends Mock implements GetAvailableCurrencies {}
class MockGetExchangeRate extends Mock implements GetExchangeRate {}

void main() {
  group('CurrencyCubit', () {
    late CurrencyCubit cubit;
    late MockGetAvailableCurrencies mockGetAvailableCurrencies;
    late MockGetExchangeRate mockGetExchangeRate;

    // Test data
    const tCryptoCurrency = Currency(
      id: 'TATUM-TRON-USDT',
      name: 'Tether (USDT)',
      symbol: 'USDT',
      type: CurrencyType.crypto,
    );

    const tFiatCurrency = Currency(
      id: 'VES',
      name: 'Bolívares (Bs)',
      symbol: 'VES',
      type: CurrencyType.fiat,
    );

    const tFiatCurrency2 = Currency(
      id: 'BRL',
      name: 'Real Brasileño (R\$)',
      symbol: 'BRL',
      type: CurrencyType.fiat,
    );

    final tCurrencies = [tCryptoCurrency, tFiatCurrency, tFiatCurrency2];

    final tExchangeRate = ExchangeRate(
      fromCurrency: tCryptoCurrency,
      toCurrency: tFiatCurrency,
      rate: 36.5,
    );

    setUp(() {
      mockGetAvailableCurrencies = MockGetAvailableCurrencies();
      mockGetExchangeRate = MockGetExchangeRate();
      cubit = CurrencyCubit(
        getAvailableCurrencies: mockGetAvailableCurrencies,
        getExchangeRate: mockGetExchangeRate,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state should be CurrencyInitial', () {
      expect(cubit.state, isA<CurrencyInitial>());
    });

    group('loadCurrencies', () {
      test('should emit CurrencyLoaded when currencies are available', () {
        // arrange
        when(() => mockGetAvailableCurrencies()).thenReturn(tCurrencies);

        // act
        cubit.loadCurrencies();

        // assert
        expect(cubit.state, isA<CurrencyLoaded>());
        final state = cubit.state as CurrencyLoaded;
        expect(state.currencies, tCurrencies);
        expect(state.selectedFromCurrency, tCryptoCurrency); // crypto first
        expect(state.selectedToCurrency, tFiatCurrency); // fiat first
      });

      test('should select first currency as both from and to when only one type exists', () {
        // arrange
        final onlyFiatCurrencies = [tFiatCurrency, tFiatCurrency2];
        when(() => mockGetAvailableCurrencies()).thenReturn(onlyFiatCurrencies);

        // act
        cubit.loadCurrencies();

        // assert
        final state = cubit.state as CurrencyLoaded;
        expect(state.selectedFromCurrency, tFiatCurrency);
        expect(state.selectedToCurrency, tFiatCurrency);
      });

      test('should emit CurrencyError when no currencies are available', () {
        // arrange
        when(() => mockGetAvailableCurrencies()).thenReturn([]);

        // act
        cubit.loadCurrencies();

        // assert
        expect(cubit.state, isA<CurrencyError>());
        final state = cubit.state as CurrencyError;
        expect(state.message, 'No currencies available');
      });
    });

    group('selectFromCurrency', () {
      test('should update selectedFromCurrency and reset conversion when currency changes', () {
        // arrange
        when(() => mockGetAvailableCurrencies()).thenReturn(tCurrencies);
        cubit.loadCurrencies();
        final initialState = cubit.state as CurrencyLoaded;
        final updatedState = initialState.copyWith(
          exchangeRate: tExchangeRate,
          convertedAmount: 100.0,

        );
        cubit.emit(updatedState);

        // act
        cubit.selectFromCurrency(tFiatCurrency2);

        // assert
        final state = cubit.state as CurrencyLoaded;
        expect(state.selectedFromCurrency, tFiatCurrency2);
        expect(state.exchangeRate, isNull);
        expect(state.convertedAmount, 0.0);

      });

      test('should not reset conversion when selecting same currency', () {
        // arrange
        when(() => mockGetAvailableCurrencies()).thenReturn(tCurrencies);
        cubit.loadCurrencies();
        final initialState = cubit.state as CurrencyLoaded;
        final updatedState = initialState.copyWith(
          exchangeRate: tExchangeRate,
          convertedAmount: 100.0,

        );
        cubit.emit(updatedState);

        // act
        cubit.selectFromCurrency(tCryptoCurrency); // same as initial

        // assert
        final state = cubit.state as CurrencyLoaded;
        expect(state.selectedFromCurrency, tCryptoCurrency);
        expect(state.exchangeRate, tExchangeRate);
        expect(state.convertedAmount, 100.0);
      });

      test('should do nothing when state is not CurrencyLoaded', () {
        // arrange
        expect(cubit.state, isA<CurrencyInitial>());

        // act
        cubit.selectFromCurrency(tFiatCurrency);

        // assert
        expect(cubit.state, isA<CurrencyInitial>());
      });
    });

    group('selectToCurrency', () {
      test('should update selectedToCurrency and reset conversion when currency changes', () {
        // arrange
        when(() => mockGetAvailableCurrencies()).thenReturn(tCurrencies);
        cubit.loadCurrencies();
        final initialState = cubit.state as CurrencyLoaded;
        final updatedState = initialState.copyWith(
          exchangeRate: tExchangeRate,
          convertedAmount: 100.0,

        );
        cubit.emit(updatedState);

        // act
        cubit.selectToCurrency(tFiatCurrency2);

        // assert
        final state = cubit.state as CurrencyLoaded;
        expect(state.selectedToCurrency, tFiatCurrency2);
        expect(state.exchangeRate, isNull);
        expect(state.convertedAmount, 0.0);

      });

      test('should do nothing when state is not CurrencyLoaded', () {
        // arrange
        expect(cubit.state, isA<CurrencyInitial>());

        // act
        cubit.selectToCurrency(tFiatCurrency);

        // assert
        expect(cubit.state, isA<CurrencyInitial>());
      });
    });

    group('swapCurrencies', () {
      test('should swap currencies and reset conversion', () {
        // arrange
        when(() => mockGetAvailableCurrencies()).thenReturn(tCurrencies);
        cubit.loadCurrencies();
        final initialState = cubit.state as CurrencyLoaded;
        final updatedState = initialState.copyWith(
          exchangeRate: tExchangeRate,
          convertedAmount: 100.0,

        );
        cubit.emit(updatedState);

        // act
        cubit.swapCurrencies();

        // assert
        final state = cubit.state as CurrencyLoaded;
        expect(state.selectedFromCurrency, tFiatCurrency); // was toCurrency
        expect(state.selectedToCurrency, tCryptoCurrency); // was fromCurrency
        expect(state.exchangeRate, isNull);
        expect(state.convertedAmount, 0.0);

      });

      test('should do nothing when state is not CurrencyLoaded', () {
        // arrange
        expect(cubit.state, isA<CurrencyInitial>());

        // act
        cubit.swapCurrencies();

        // assert
        expect(cubit.state, isA<CurrencyInitial>());
      });
    });

    group('updateAmount', () {
      test('should update amount and mark conversion as outdated', () {
        // arrange
        when(() => mockGetAvailableCurrencies()).thenReturn(tCurrencies);
        cubit.loadCurrencies();
        final initialState = cubit.state as CurrencyLoaded;
        final updatedState = initialState.copyWith(
          amount: 50.0,
        );
        cubit.emit(updatedState);

        // act
        cubit.updateAmount(100.0);

        // assert
        final state = cubit.state as CurrencyLoaded;
        expect(state.amount, 100.0);
      });

      test('should do nothing when state is not CurrencyLoaded', () {
        // arrange
        expect(cubit.state, isA<CurrencyInitial>());

        // act
        cubit.updateAmount(100.0);

        // assert
        expect(cubit.state, isA<CurrencyInitial>());
      });
    });

    group('performConversion', () {
      test('should return false when state is not CurrencyLoaded', () async {
        // arrange
        expect(cubit.state, isA<CurrencyInitial>());

        // act
        final result = await cubit.performConversion();

        // assert
        expect(result, false);
      });

      test('should return false when fromCurrency is null', () async {
        // arrange
        when(() => mockGetAvailableCurrencies()).thenReturn(tCurrencies);
        cubit.loadCurrencies();
        final initialState = cubit.state as CurrencyLoaded;
        cubit.emit(initialState.copyWith(
          selectedFromCurrency: null,
          amount: 100.0,
        ));

        // act
        final result = await cubit.performConversion();

        // assert
        expect(result, false);
      });

      test('should return false when toCurrency is null', () async {
        // arrange
        when(() => mockGetAvailableCurrencies()).thenReturn(tCurrencies);
        cubit.loadCurrencies();
        final initialState = cubit.state as CurrencyLoaded;
        cubit.emit(initialState.copyWith(
          selectedToCurrency: null,
          amount: 100.0,
        ));

        // act
        final result = await cubit.performConversion();

        // assert
        expect(result, false);
      });

      test('should return false when amount is zero or negative', () async {
        // arrange
        when(() => mockGetAvailableCurrencies()).thenReturn(tCurrencies);
        cubit.loadCurrencies();
        final initialState = cubit.state as CurrencyLoaded;
        cubit.emit(initialState.copyWith(amount: 0.0));

        // act
        final result = await cubit.performConversion();

        // assert
        expect(result, false);
      });

      test('should emit loading state and return true on successful conversion', () async {
        // arrange
        when(() => mockGetAvailableCurrencies()).thenReturn(tCurrencies);
        when(() => mockGetExchangeRate(
          fromCurrencyId: any(named: 'fromCurrencyId'),
          toCurrencyId: any(named: 'toCurrencyId'),
          amount: any(named: 'amount'),
          amountCurrencyId: any(named: 'amountCurrencyId'),
        )).thenAnswer((_) async => tExchangeRate);

        cubit.loadCurrencies();
        final initialState = cubit.state as CurrencyLoaded;
        cubit.emit(initialState.copyWith(amount: 100.0));

        // act
        final result = await cubit.performConversion();

        // assert
        expect(result, true);
        final state = cubit.state as CurrencyLoaded;
        expect(state.exchangeRate, tExchangeRate);
        expect(state.convertedAmount, tExchangeRate.convertAmount(100.0));
        expect(state.amount, 100.0); // amount should be preserved

        verify(() => mockGetExchangeRate(
          fromCurrencyId: tCryptoCurrency.id,
          toCurrencyId: tFiatCurrency.id,
          amount: 100.0,
          amountCurrencyId: tCryptoCurrency.id,
        )).called(1);
      });

      test('should emit error state and return false on AppException', () async {
        // arrange
        when(() => mockGetAvailableCurrencies()).thenReturn(tCurrencies);
        when(() => mockGetExchangeRate(
          fromCurrencyId: any(named: 'fromCurrencyId'),
          toCurrencyId: any(named: 'toCurrencyId'),
          amount: any(named: 'amount'),
          amountCurrencyId: any(named: 'amountCurrencyId'),
        )).thenThrow(AppException('Network error', const ServerFailure('Network error')));

        cubit.loadCurrencies();
        final initialState = cubit.state as CurrencyLoaded;
        cubit.emit(initialState.copyWith(amount: 100.0));

        // act
        final result = await cubit.performConversion();

        // assert
        expect(result, false);
        expect(cubit.state, isA<CurrencyLoaded>());
        final state = cubit.state as CurrencyLoaded;
        expect(state.amount, 100.0); // state should be restored
      });

      test('should emit error state with generic message on other exceptions', () async {
        // arrange
        when(() => mockGetAvailableCurrencies()).thenReturn(tCurrencies);
        when(() => mockGetExchangeRate(
          fromCurrencyId: any(named: 'fromCurrencyId'),
          toCurrencyId: any(named: 'toCurrencyId'),
          amount: any(named: 'amount'),
          amountCurrencyId: any(named: 'amountCurrencyId'),
        )).thenThrow(Exception('Unknown error'));

        cubit.loadCurrencies();
        final initialState = cubit.state as CurrencyLoaded;
        cubit.emit(initialState.copyWith(amount: 100.0));

        // act
        final result = await cubit.performConversion();

        // assert
        expect(result, false);
        expect(cubit.state, isA<CurrencyLoaded>());
        final state = cubit.state as CurrencyLoaded;
        expect(state.amount, 100.0); // state should be restored
      });
    });
  });
}
