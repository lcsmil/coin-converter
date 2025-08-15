import 'package:coin_converter/presentation/blocs/currency_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/currency.dart';
import '../../domain/usecases/get_available_currencies.dart';
import '../../domain/usecases/get_exchange_rate.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  final GetAvailableCurrencies getAvailableCurrencies;
  final GetExchangeRate getExchangeRate;

  CurrencyCubit({
    required this.getAvailableCurrencies,
    required this.getExchangeRate,
  }) : super(CurrencyInitial());

  void loadCurrencies() {
    final currencies = getAvailableCurrencies();

    if (currencies.isNotEmpty) {
      final cryptoCurrencies = currencies
          .where((c) => c.type == CurrencyType.crypto)
          .toList();
      final fiatCurrencies = currencies
          .where((c) => c.type == CurrencyType.fiat)
          .toList();

      final initialFromCurrency = cryptoCurrencies.isNotEmpty
          ? cryptoCurrencies.first
          : currencies.first;
      final initialToCurrency = fiatCurrencies.isNotEmpty
          ? fiatCurrencies.first
          : currencies.first;

      emit(
        CurrencyLoaded(
          currencies: currencies,
          selectedFromCurrency: initialFromCurrency,
          selectedToCurrency: initialToCurrency,
        ),
      );
    } else {
      emit(CurrencyError('No currencies available'));
    }
  }

  void selectFromCurrency(Currency currency) {
    final currentState = state;
    if (currentState is! CurrencyLoaded) return;
    
    final shouldResetRate = currentState.selectedFromCurrency?.id != currency.id;

    emit(
      currentState.copyWith(
        selectedFromCurrency: currency,
        exchangeRate: shouldResetRate ? null : currentState.exchangeRate,
        convertedAmount: shouldResetRate ? 0.0 : currentState.convertedAmount,
      ),
    );
  }

  void selectToCurrency(Currency currency) {
    final currentState = state;
    if (currentState is! CurrencyLoaded) return;
    
    final shouldResetRate = currentState.selectedToCurrency?.id != currency.id;

    emit(
      currentState.copyWith(
        selectedToCurrency: currency,
        exchangeRate: shouldResetRate ? null : currentState.exchangeRate,
        convertedAmount: shouldResetRate ? 0.0 : currentState.convertedAmount,
      ),
    );
  }

  void swapCurrencies() {
    final currentState = state;
    if (currentState is! CurrencyLoaded) return;
    
    emit(
      currentState.copyWith(
        selectedFromCurrency: currentState.selectedToCurrency,
        selectedToCurrency: currentState.selectedFromCurrency,
        exchangeRate: null,
        convertedAmount: 0.0,
      ),
    );
  }

  
  void updateAmount(double amount) {
    final currentState = state;
    if (currentState is! CurrencyLoaded) return;
    
    emit(currentState.copyWith(amount: amount));
  }

  Future<bool> performConversion() async {
    final currentState = state;
    if (currentState is! CurrencyLoaded) return false;

    if (currentState.selectedFromCurrency == null ||
        currentState.selectedToCurrency == null ||
        currentState.amount <= 0) {
      return false;
    }

    final previousState = currentState;
    emit(CurrencyLoading());

    try {
      final exchangeRate = await getExchangeRate(
        fromCurrencyId: currentState.selectedFromCurrency!.id,
        toCurrencyId: currentState.selectedToCurrency!.id,
        amount: currentState.amount,
        amountCurrencyId: currentState.selectedFromCurrency!.id,
      );

      final convertedAmount = exchangeRate.convertAmount(currentState.amount);
      emit(
        currentState.copyWith(
          exchangeRate: exchangeRate,
          convertedAmount: convertedAmount,
        ),
      );
      return true;
    } catch (e) {
      emit(previousState);
      return false;
    }
  }
}
