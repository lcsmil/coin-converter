import 'package:coin_converter/data/datasources/local/currency_local_data_source.dart';
import 'package:coin_converter/data/models/currency_model.dart';
import 'package:coin_converter/domain/entities/currency.dart';

class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  CurrencyLocalDataSourceImpl();
  @override
  List<CurrencyModel> getAvailableCurrencies() {
    final currencies = <CurrencyModel>[
      const CurrencyModel(
        id: 'TATUM-TRON-USDT',
        name: 'Tether (USDT)',
        symbol: 'USDT',
        type: CurrencyType.crypto,
      ),
      const CurrencyModel(
        id: 'VES',
        name: 'Bolívares (Bs)',
        symbol: 'VES',
        type: CurrencyType.fiat,
      ),
      const CurrencyModel(
        id: 'BRL',
        name: 'Real Brasileño (R\$)',
        symbol: 'BRL',
        type: CurrencyType.fiat,
      ),
      const CurrencyModel(
        id: 'COP',
        name: 'Pesos Colombianos (COL\$)',
        symbol: 'COP',
        type: CurrencyType.fiat,
      ),
      const CurrencyModel(
        id: 'PEN',
        name: 'Soles Peruanos (S/)',
        symbol: 'PEN',
        type: CurrencyType.fiat,
      ),
    ];

    return currencies;
  }

  @override
  CurrencyModel? getCurrencyById(String id) {
    final currencies = getAvailableCurrencies();
    try {
      return currencies.firstWhere((currency) => currency.id == id);
    } catch (_) {
      return null;
    }
  }
}
