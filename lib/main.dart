import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/di/injection_container.dart' as di;
import 'presentation/blocs/currency_cubit.dart';
import 'presentation/pages/currency_converter_page.dart';
import 'core/utils/l10n_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.supportedLocales,
      locale: const Locale('en'),
      home: Builder(
        builder: (context) {
          return BlocProvider(
            create: (context) => di.sl<CurrencyCubit>(),
            child: const CurrencyConverterPage(),
          );
        },
      ),
    );
  }
}
