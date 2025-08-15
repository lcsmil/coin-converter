import 'package:coin_converter/data/models/currency_model.dart';

abstract class CurrencyLocalDataSource {
  List<CurrencyModel> getAvailableCurrencies();
  CurrencyModel? getCurrencyById(String id);
}
