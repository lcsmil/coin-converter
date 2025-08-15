import 'package:flutter_test/flutter_test.dart';
import 'package:coin_converter/data/datasources/local/currency_local_data_source_impl.dart';
import 'package:coin_converter/data/models/currency_model.dart';
import 'package:coin_converter/domain/entities/currency.dart';

void main() {
  group('CurrencyLocalDataSourceImpl', () {
    late CurrencyLocalDataSourceImpl dataSource;

    setUp(() {
      dataSource = CurrencyLocalDataSourceImpl();
    });

    group('getAvailableCurrencies', () {
      test('should return list of predefined currencies', () {
        // Act
        final result = dataSource.getAvailableCurrencies();

        // Assert
        expect(result, isA<List<CurrencyModel>>());
        expect(result.isNotEmpty, true);
      });

      test('should return currencies with correct properties', () {
        // Act
        final result = dataSource.getAvailableCurrencies();

        // Assert
        expect(result.length, 5);
        
        // Check USDT
        final usdt = result.firstWhere((c) => c.id == 'TATUM-TRON-USDT');
        expect(usdt.name, 'Tether (USDT)');
        expect(usdt.symbol, 'USDT');
        expect(usdt.type, CurrencyType.crypto);

        // Check VES
        final ves = result.firstWhere((c) => c.id == 'VES');
        expect(ves.name, 'Bolívares (Bs)');
        expect(ves.symbol, 'VES');
        expect(ves.type, CurrencyType.fiat);

        // Check BRL
        final brl = result.firstWhere((c) => c.id == 'BRL');
        expect(brl.name, 'Real Brasileño (R\$)');
        expect(brl.symbol, 'BRL');
        expect(brl.type, CurrencyType.fiat);

        // Check COP
        final cop = result.firstWhere((c) => c.id == 'COP');
        expect(cop.name, 'Pesos Colombianos (COL\$)');
        expect(cop.symbol, 'COP');
        expect(cop.type, CurrencyType.fiat);

        // Check PEN
        final pen = result.firstWhere((c) => c.id == 'PEN');
        expect(pen.name, 'Soles Peruanos (S/)');
        expect(pen.symbol, 'PEN');
        expect(pen.type, CurrencyType.fiat);
      });

      test('should return mix of crypto and fiat currencies', () {
        // Act
        final result = dataSource.getAvailableCurrencies();

        // Assert
        final cryptoCurrencies = result.where((c) => c.type == CurrencyType.crypto).toList();
        final fiatCurrencies = result.where((c) => c.type == CurrencyType.fiat).toList();

        expect(cryptoCurrencies.length, 1);
        expect(fiatCurrencies.length, 4);
      });

      test('should return same currencies on multiple calls', () {
        // Act
        final result1 = dataSource.getAvailableCurrencies();
        final result2 = dataSource.getAvailableCurrencies();

        // Assert
        expect(result1.length, result2.length);
        for (int i = 0; i < result1.length; i++) {
          expect(result1[i].id, result2[i].id);
          expect(result1[i].name, result2[i].name);
          expect(result1[i].symbol, result2[i].symbol);
          expect(result1[i].type, result2[i].type);
        }
      });
    });

    group('getCurrencyById', () {
      test('should return currency when valid id is provided', () {
        // Act
        final result = dataSource.getCurrencyById('TATUM-TRON-USDT');

        // Assert
        expect(result, isNotNull);
        expect(result!.id, 'TATUM-TRON-USDT');
        expect(result.name, 'Tether (USDT)');
        expect(result.symbol, 'USDT');
        expect(result.type, CurrencyType.crypto);
      });

      test('should return null when invalid id is provided', () {
        // Act
        final result = dataSource.getCurrencyById('INVALID_ID');

        // Assert
        expect(result, isNull);
      });

      test('should return null when empty id is provided', () {
        // Act
        final result = dataSource.getCurrencyById('');

        // Assert
        expect(result, isNull);
      });

      test('should return correct currency for each valid id', () {
        // Arrange
        final expectedCurrencies = {
          'TATUM-TRON-USDT': ('Tether (USDT)', 'USDT', CurrencyType.crypto),
          'VES': ('Bolívares (Bs)', 'VES', CurrencyType.fiat),
          'BRL': ('Real Brasileño (R\$)', 'BRL', CurrencyType.fiat),
          'COP': ('Pesos Colombianos (COL\$)', 'COP', CurrencyType.fiat),
          'PEN': ('Soles Peruanos (S/)', 'PEN', CurrencyType.fiat),
        };

        // Act & Assert
        expectedCurrencies.forEach((id, expectedData) {
          final result = dataSource.getCurrencyById(id);
          expect(result, isNotNull);
          expect(result!.id, id);
          expect(result.name, expectedData.$1);
          expect(result.symbol, expectedData.$2);
          expect(result.type, expectedData.$3);
        });
      });

      test('should be case sensitive for currency ids', () {
        // Act
        final result1 = dataSource.getCurrencyById('ves'); // lowercase
        final result2 = dataSource.getCurrencyById('VES'); // uppercase

        // Assert
        expect(result1, isNull);
        expect(result2, isNotNull);
      });

      test('should handle special characters in currency ids', () {
        // Act
        final result = dataSource.getCurrencyById('TATUM-TRON-USDT');

        // Assert
        expect(result, isNotNull);
        expect(result!.id, 'TATUM-TRON-USDT');
      });
    });

    group('data consistency', () {
      test('should ensure getCurrencyById returns currencies from getAvailableCurrencies', () {
        // Arrange
        final allCurrencies = dataSource.getAvailableCurrencies();

        // Act & Assert
        for (final currency in allCurrencies) {
          final foundCurrency = dataSource.getCurrencyById(currency.id);
          expect(foundCurrency, isNotNull);
          expect(foundCurrency!.id, currency.id);
          expect(foundCurrency.name, currency.name);
          expect(foundCurrency.symbol, currency.symbol);
          expect(foundCurrency.type, currency.type);
        }
      });

      test('should have unique currency ids', () {
        // Arrange
        final allCurrencies = dataSource.getAvailableCurrencies();

        // Act
        final ids = allCurrencies.map((c) => c.id).toList();
        final uniqueIds = ids.toSet();

        // Assert
        expect(ids.length, uniqueIds.length);
      });

      test('should have unique currency symbols', () {
        // Arrange
        final allCurrencies = dataSource.getAvailableCurrencies();

        // Act
        final symbols = allCurrencies.map((c) => c.symbol).toList();
        final uniqueSymbols = symbols.toSet();

        // Assert
        expect(symbols.length, uniqueSymbols.length);
      });
    });
  });
}
