import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class L10n {
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  static Locale? localeOf(BuildContext context) {
    return Localizations.localeOf(context);
  }

  static List<Locale> get supportedLocales => AppLocalizations.supportedLocales;
}
