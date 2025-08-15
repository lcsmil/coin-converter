// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Conversor de Moedas';

  @override
  String get networkErrorMessage => 'Erro de rede. Por favor, verifique sua conexão.';

  @override
  String get generalErrorMessage => 'Algo deu errado. Por favor, tente novamente.';

  @override
  String get invalidAmountMessage => 'Por favor, insira um valor válido.';

  @override
  String get convertButtonLabel => 'Converter';

  @override
  String get errorDialogTitle => 'Erro';

  @override
  String get conversionErrorMessage => 'Não foi possível realizar a conversão. Por favor, tente novamente.';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get fromCurrencyLabel => 'De';

  @override
  String get toCurrencyLabel => 'Para';

  @override
  String get fiatCurrencyTitle => 'FIAT';

  @override
  String get cryptoCurrencyTitle => 'Crypto';

  @override
  String get estimatedRateLabel => 'Taxa estimada';

  @override
  String get youWillReceiveLabel => 'Você receberá';

  @override
  String get estimatedTimeLabel => 'Tempo estimado';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr(): super('pt_BR');

  @override
  String get appName => 'Conversor de Moedas';

  @override
  String get networkErrorMessage => 'Erro de rede. Por favor, verifique sua conexão.';

  @override
  String get generalErrorMessage => 'Algo deu errado. Por favor, tente novamente.';

  @override
  String get invalidAmountMessage => 'Por favor, insira um valor válido.';

  @override
  String get convertButtonLabel => 'Converter';

  @override
  String get errorDialogTitle => 'Erro';

  @override
  String get conversionErrorMessage => 'Não foi possível realizar a conversão. Por favor, tente novamente.';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get fromCurrencyLabel => 'De';

  @override
  String get toCurrencyLabel => 'Para';

  @override
  String get fiatCurrencyTitle => 'FIAT';

  @override
  String get cryptoCurrencyTitle => 'Crypto';

  @override
  String get estimatedRateLabel => 'Taxa estimada';

  @override
  String get youWillReceiveLabel => 'Você receberá';

  @override
  String get estimatedTimeLabel => 'Tempo estimado';
}
