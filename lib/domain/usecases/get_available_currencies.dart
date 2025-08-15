import '../entities/currency.dart';
import '../repositories/currency_repository.dart';

class GetAvailableCurrencies {
  final CurrencyRepository repository;

  GetAvailableCurrencies(this.repository);

  List<Currency> call() {
    return repository.getAvailableCurrencies();
  }
}
