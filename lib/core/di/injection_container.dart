import 'package:coin_converter/data/datasources/local/currency_local_data_source.dart';
import 'package:coin_converter/data/datasources/remote/currency_remote_data_source_impl.dart';
import 'package:coin_converter/data/datasources/local/currency_local_data_source_impl.dart';
import 'package:get_it/get_it.dart';
import '../../data/datasources/remote/currency_remote_data_source.dart';
import '../../data/repositories/currency_repository_impl.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../domain/usecases/get_available_currencies.dart';
import '../../domain/usecases/get_exchange_rate.dart';
import '../../presentation/blocs/currency_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubit
  sl.registerFactory(
    () => CurrencyCubit(getAvailableCurrencies: sl(), getExchangeRate: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAvailableCurrencies(sl()));
  sl.registerLazySingleton(() => GetExchangeRate(sl()));

  // Repository
  sl.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<CurrencyRemoteDataSource>(
    () => CurrencyRemoteDataSourceImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<CurrencyLocalDataSource>(
    () => CurrencyLocalDataSourceImpl(),
  );
}
