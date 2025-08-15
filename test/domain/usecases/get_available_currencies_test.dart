import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:coin_converter/domain/entities/currency.dart';
import 'package:coin_converter/domain/repositories/currency_repository.dart';
import 'package:coin_converter/domain/usecases/get_available_currencies.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

void main() {
  late GetAvailableCurrencies useCase;
  late MockCurrencyRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrencyRepository();
    useCase = GetAvailableCurrencies(mockRepository);
  });

  group('GetAvailableCurrencies UseCase', () {
    final tCurrencies = [
      const Currency(
        id: 'BTC',
        name: 'Bitcoin',
        symbol: 'BTC',
        type: CurrencyType.crypto,
      ),
      const Currency(
        id: 'USD',
        name: 'US Dollar',
        symbol: 'USD',
        type: CurrencyType.fiat,
      ),
      const Currency(
        id: 'ETH',
        name: 'Ethereum',
        symbol: 'ETH',
        type: CurrencyType.crypto,
      ),
    ];

    test('should get list of currencies from the repository', () {
      // arrange
      when(() => mockRepository.getAvailableCurrencies()).thenReturn(tCurrencies);

      // act
      final result = useCase();

      // assert
      expect(result, equals(tCurrencies));
      verify(() => mockRepository.getAvailableCurrencies());
    });

    test('should return empty list when repository returns empty list', () {
      // arrange
      when(() => mockRepository.getAvailableCurrencies()).thenReturn([]);

      // act
      final result = useCase();

      // assert
      expect(result, equals([]));
      verify(() => mockRepository.getAvailableCurrencies());
    });

    test('should call repository method only once per call', () {
      // arrange
      when(() => mockRepository.getAvailableCurrencies()).thenReturn(tCurrencies);

      // act
      useCase();
      useCase();

      // assert
      verify(() => mockRepository.getAvailableCurrencies()).called(2);
    });

    test('should return the same currencies on multiple calls', () {
      // arrange
      when(() => mockRepository.getAvailableCurrencies()).thenReturn(tCurrencies);

      // act
      final result1 = useCase();
      final result2 = useCase();

      // assert
      expect(result1, result2);
      expect(result1, tCurrencies);
      verify(() => mockRepository.getAvailableCurrencies()).called(2);
    });

    test('should return currencies with mixed types (fiat and crypto)', () {
      // arrange
      final mixedCurrencies = [
        const Currency(
          id: 'USD',
          name: 'US Dollar',
          symbol: 'USD',
          type: CurrencyType.fiat,
        ),
        const Currency(
          id: 'BTC',
          name: 'Bitcoin',
          symbol: 'BTC',
          type: CurrencyType.crypto,
        ),
      ];
      when(() => mockRepository.getAvailableCurrencies()).thenReturn(mixedCurrencies);

      // act
      final result = useCase();

      // assert
      expect(result, equals(mixedCurrencies));
      expect(result.length, equals(2));
      expect(result[0].type, equals(CurrencyType.fiat));
      expect(result[1].type, equals(CurrencyType.crypto));
    });
  });
}
