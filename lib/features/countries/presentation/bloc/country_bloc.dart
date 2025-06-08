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

class SearchCountriesByNameEvent extends CountryEvent {
  final String name;
  const SearchCountriesByNameEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class FilterCountriesByRegionEvent extends CountryEvent {
  final String region;
  const FilterCountriesByRegionEvent(this.region);

  @override
  List<Object?> get props => [region];
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
  const CountryLoaded(this.countries);

  @override
  List<Object?> get props => [countries];
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

  CountryBloc({
    required this.getAllCountriesUseCase,
  }) : super(CountryInitial()) {
    on<GetAllCountriesEvent>((event, emit) async {
      emit(CountryLoading());
      final result = await getAllCountriesUseCase();
      result.fold(
        (failure) => emit(CountryError(failure.message)),
        (countries) => emit(CountryLoaded(countries)),
      );
    });
  }
} 