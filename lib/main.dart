import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:dio/browser.dart';

import 'features/countries/data/datasources/country_remote_data_source.dart';
import 'features/countries/data/repositories/country_repository_impl.dart';
import 'features/countries/domain/repositories/country_repository.dart';
import 'features/countries/domain/usecases/get_all_countries_usecase.dart';
import 'features/countries/presentation/bloc/country_bloc.dart';
import 'features/countries/presentation/pages/countries_page.dart';
import 'core/network/network_info.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Core
  getIt.registerLazySingleton(() {
    final dio = Dio();
    dio.httpClientAdapter = BrowserHttpClientAdapter();
    return dio;
  });
  
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(),
  );

  // Data sources
  getIt.registerLazySingleton<CountryRemoteDataSource>(
    () => CountryRemoteDataSourceImpl(dio: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<CountryRepository>(
    () => CountryRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetAllCountriesUseCase(getIt()));

  // BLoC
  getIt.registerFactory(
    () => CountryBloc(getAllCountriesUseCase: getIt()),
  );
}

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countries App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => getIt<CountryBloc>(),
        child: const CountriesPage(),
      ),
    );
  }
} 