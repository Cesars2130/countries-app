import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/usecases/get_all_countries_usecase.dart';

// Events
abstract class CountryEvent extends Equatable {
  const CountryEvent();

  @override
  List<Object?> get props => [];
}

class GetAllCountriesEvent extends CountryEvent {}

class ApplyFiltersEvent extends CountryEvent {
  final String? name;
  final String? language;
  final String? region;

  const ApplyFiltersEvent({
    this.name,
    this.language,
    this.region,
  });

  @override
  List<Object?> get props => [name, language, region];
}

// States
abstract class CountryState extends Equatable {
  const CountryState();

  @override
  List<Object?> get props => [];
}

class CountryInitial extends CountryState {}

class CountryLoading extends CountryState {}

class CountryLoaded extends CountryState {
  final List<CountryEntity> countries;
  final List<String> availableLanguages;
  final List<String> availableRegions;
  final String? currentName;
  final String? currentLanguage;
  final String? currentRegion;

  const CountryLoaded({
    required this.countries,
    required this.availableLanguages,
    required this.availableRegions,
    this.currentName,
    this.currentLanguage,
    this.currentRegion,
  });

  @override
  List<Object?> get props => [
        countries,
        availableLanguages,
        availableRegions,
        currentName,
        currentLanguage,
        currentRegion,
      ];

  CountryLoaded copyWith({
    List<CountryEntity>? countries,
    List<String>? availableLanguages,
    List<String>? availableRegions,
    String? currentName,
    String? currentLanguage,
    String? currentRegion,
  }) {
    return CountryLoaded(
      countries: countries ?? this.countries,
      availableLanguages: availableLanguages ?? this.availableLanguages,
      availableRegions: availableRegions ?? this.availableRegions,
      currentName: currentName ?? this.currentName,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      currentRegion: currentRegion ?? this.currentRegion,
    );
  }
}

class CountryError extends CountryState {
  final String message;
  const CountryError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final GetAllCountriesUseCase getAllCountriesUseCase;
  List<CountryEntity> allCountries = [];

  CountryBloc({
    required this.getAllCountriesUseCase,
  }) : super(CountryInitial()) {
    on<GetAllCountriesEvent>(_onGetAllCountries);
    on<ApplyFiltersEvent>(_onApplyFilters);
  }

  Future<void> _onGetAllCountries(
    GetAllCountriesEvent event,
    Emitter<CountryState> emit,
  ) async {
    emit(CountryLoading());
    final result = await getAllCountriesUseCase();
    result.fold(
      (failure) => emit(CountryError(failure.message)),
      (countries) {
        allCountries = countries;
        emit(CountryLoaded(
          countries: countries,
          availableLanguages: _extractLanguages(countries),
          availableRegions: _extractRegions(countries),
        ));
      },
    );
  }

  void _onApplyFilters(
    ApplyFiltersEvent event,
    Emitter<CountryState> emit,
  ) {
    if (state is! CountryLoaded) return;

    var filteredCountries = allCountries;

    // Apply name filter
    if (event.name != null && event.name!.isNotEmpty) {
      filteredCountries = filteredCountries
          .where((country) =>
              country.name.toLowerCase().contains(event.name!.toLowerCase()))
          .toList();
    }

    // Apply language filter
    if (event.language != null && event.language!.isNotEmpty) {
      filteredCountries = filteredCountries
          .where((country) => country.languages.contains(event.language))
          .toList();
    }

    // Apply region filter
    if (event.region != null && event.region!.isNotEmpty) {
      filteredCountries = filteredCountries
          .where((country) => country.region == event.region)
          .toList();
    }

    emit(CountryLoaded(
      countries: filteredCountries,
      availableLanguages: _extractLanguages(allCountries),
      availableRegions: _extractRegions(allCountries),
      currentName: event.name,
      currentLanguage: event.language,
      currentRegion: event.region,
    ));
  }

  List<String> _extractLanguages(List<CountryEntity> countries) {
    final languages = countries
        .expand((country) => country.languages)
        .toSet()
        .toList()
      ..sort();
    return languages;
  }

  List<String> _extractRegions(List<CountryEntity> countries) {
    final regions = countries
        .map((country) => country.region)
        .where((region) => region.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return regions;
  }
} 