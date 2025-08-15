import 'package:coin_converter/core/constants/size_tokens.dart';
import 'package:coin_converter/core/constants/color_tokens.dart';
import 'package:coin_converter/core/utils/l10n_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/currency_cubit.dart';
import '../blocs/currency_state.dart';
import '../../domain/entities/currency.dart';
import '../widgets/currency_selector.dart';
import '../widgets/amount_input.dart';
import '../widgets/exchange_details.dart';
import '../widgets/convert_button.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  @override
  void initState() {
    super.initState();
    context.read<CurrencyCubit>().loadCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CurrencyCubit, CurrencyState>(
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(color: ColorTokens.background),
              ),
              Positioned(
                right: -MediaQuery.of(context).size.width * 1.9,
                top: -MediaQuery.of(context).size.width * 0.2,
                bottom: 0,
                width: MediaQuery.of(context).size.width * 2.4,
                child: Container(
                  decoration: const BoxDecoration(
                    color: ColorTokens.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(SizeTokens.horizontalPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: ColorTokens.white,
                          borderRadius: BorderRadius.circular(
                            SizeTokens.borderRadius,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: ColorTokens.shadow,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(SizeTokens.verticalPadding),
                          child: Column(
                            children: [
                              _buildCurrencySelector(state),
                              SizedBox(height: SizeTokens.spaceBetween),
                              _buildAmountInput(state),
                              SizedBox(height: SizeTokens.spaceBetween),
                              _buildExchangeDetails(state),
                              SizedBox(height: SizeTokens.spaceBetween),
                              _buildConvertButton(state),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCurrencySelector(CurrencyState state) {
    if (state is! CurrencyLoaded) {
      return const SizedBox.shrink();
    }

    final cryptoCurrencies = state.currencies
        .where((c) => c.type == CurrencyType.crypto)
        .toList();
    final fiatCurrencies = state.currencies
        .where((c) => c.type == CurrencyType.fiat)
        .toList();

    // Determine which currencies to show in each card based on the selected currencies
    final fromCurrencyType = state.selectedFromCurrency?.type;

    // If both are the same type, default to crypto for 'from' and fiat for 'to'
    final List<Currency> fromCurrencies =
        fromCurrencyType == CurrencyType.crypto
        ? cryptoCurrencies
        : fiatCurrencies;
    final List<Currency> toCurrencies = fromCurrencyType == CurrencyType.crypto
        ? fiatCurrencies
        : cryptoCurrencies;

    return CurrencySelector(
      selectedFromCurrency: state.selectedFromCurrency,
      selectedToCurrency: state.selectedToCurrency,
      fromCurrencies: fromCurrencies,
      toCurrencies: toCurrencies,
      onFromCurrencySelected: (currency) {
        context.read<CurrencyCubit>().selectFromCurrency(currency);
      },
      onToCurrencySelected: (currency) {
        context.read<CurrencyCubit>().selectToCurrency(currency);
      },
      onSwap: () {
        context.read<CurrencyCubit>().swapCurrencies();
      },
      isVisible: true,
    );
  }

  Widget _buildAmountInput(CurrencyState state) {
    return AmountInput(
      fromCurrencySymbol: state is CurrencyLoaded
          ? state.selectedFromCurrency?.symbol
          : null,
      currentAmount: state is CurrencyLoaded ? state.amount : 0.0,
      onAmountChanged: (amount) {
        if (state is CurrencyLoaded &&
            state.selectedFromCurrency != null &&
            state.selectedToCurrency != null) {
          context.read<CurrencyCubit>().updateAmount(amount);
        }
      },
      isVisible: state is CurrencyLoaded,
    );
  }

  Widget _buildExchangeDetails(CurrencyState state) {
    if (state is! CurrencyLoaded) {
      return const SizedBox.shrink();
    }

    return ExchangeDetails(
      exchangeRate: state.exchangeRate?.rate,
      convertedAmount: state.convertedAmount,
      toCurrencySymbol: state.selectedToCurrency?.symbol,
      isVisible: state.exchangeRate != null,
    );
  }

  Widget _buildConvertButton(CurrencyState state) {
    final isLoading = state is CurrencyLoading;
    final canConvert =
        state is CurrencyLoaded &&
        state.selectedFromCurrency != null &&
        state.selectedToCurrency != null &&
        state.amount > 0;

    return ConvertButton(
      isLoading: isLoading,
      canConvert: canConvert,
      onConvert: () => _performConversion(),
    );
  }

  void _performConversion() async {
    final cubit = context.read<CurrencyCubit>();
    final success = await cubit.performConversion();

    if (!success && mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(L10n.of(context).errorDialogTitle),
          content: Text(L10n.of(context).conversionErrorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(L10n.of(context).okButtonLabel),
            ),
          ],
        ),
      );
    }
  }
}
