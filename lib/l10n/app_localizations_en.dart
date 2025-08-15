// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Coin Converter';

  @override
  String get networkErrorMessage => 'Network error. Please check your connection.';

  @override
  String get generalErrorMessage => 'Something went wrong. Please try again.';

  @override
  String get invalidAmountMessage => 'Please enter a valid amount.';

  @override
  String get convertButtonLabel => 'Convert';

  @override
  String get errorDialogTitle => 'Error';

  @override
  String get conversionErrorMessage => 'Could not perform the conversion. Please try again.';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get fromCurrencyLabel => 'From';

  @override
  String get toCurrencyLabel => 'To';

  @override
  String get fiatCurrencyTitle => 'FIAT';

  @override
  String get cryptoCurrencyTitle => 'Crypto';

  @override
  String get estimatedRateLabel => 'Estimated rate';

  @override
  String get youWillReceiveLabel => 'You\'ll receive';

  @override
  String get estimatedTimeLabel => 'Estimated time';
}
