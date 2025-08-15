// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Conversor de Monedas';

  @override
  String get networkErrorMessage => 'Error de red. Por favor, comprueba tu conexión.';

  @override
  String get generalErrorMessage => 'Algo salió mal. Por favor, inténtalo de nuevo.';

  @override
  String get invalidAmountMessage => 'Por favor, introduce una cantidad válida.';

  @override
  String get convertButtonLabel => 'Cambiar';

  @override
  String get errorDialogTitle => 'Error';

  @override
  String get conversionErrorMessage => 'No se pudo realizar la conversión. Por favor intenta de nuevo.';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get fromCurrencyLabel => 'De';

  @override
  String get toCurrencyLabel => 'A';

  @override
  String get fiatCurrencyTitle => 'FIAT';

  @override
  String get cryptoCurrencyTitle => 'Crypto';

  @override
  String get estimatedRateLabel => 'Tasa estimada';

  @override
  String get youWillReceiveLabel => 'Recibirás';

  @override
  String get estimatedTimeLabel => 'Tiempo estimado';
}
