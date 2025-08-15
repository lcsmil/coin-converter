import 'package:coin_converter/domain/entities/currency.dart';
import 'package:coin_converter/domain/entities/exchange_rate.dart';

abstract class CurrencyState {}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyLoaded extends CurrencyState {
  final List<Currency> currencies;
  final Currency? selectedFromCurrency;
  final Currency? selectedToCurrency;
  final ExchangeRate? exchangeRate;
  final double amount;
  final double convertedAmount;

  CurrencyLoaded({
    required this.currencies,
    this.selectedFromCurrency,
    this.selectedToCurrency,
    this.exchangeRate,
    this.amount = 0.0,
    this.convertedAmount = 0.0,
  });

  CurrencyLoaded copyWith({
    List<Currency>? currencies,
    Currency? selectedFromCurrency,
    Currency? selectedToCurrency,
    Object? exchangeRate = _notProvided,
    double? amount,
    double? convertedAmount,
  }) {
    return CurrencyLoaded(
      currencies: currencies ?? this.currencies,
      selectedFromCurrency: selectedFromCurrency ?? this.selectedFromCurrency,
      selectedToCurrency: selectedToCurrency ?? this.selectedToCurrency,
      exchangeRate: exchangeRate == _notProvided ? this.exchangeRate : exchangeRate as ExchangeRate?,
      amount: amount ?? this.amount,
      convertedAmount: convertedAmount ?? this.convertedAmount,
    );
  }
}

const Object _notProvided = Object();

class CurrencyError extends CurrencyState {
  final String message;

  CurrencyError(this.message);
}