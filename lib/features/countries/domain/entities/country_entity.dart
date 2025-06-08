import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable {
  final String name;
  final String officialName;
  final List<String> languages;
  final String region;
  final String flag;
  final String capital;
  final int population;

  const CountryEntity({
    required this.name,
    required this.officialName,
    required this.languages,
    required this.region,
    required this.flag,
    required this.capital,
    required this.population,
  });

  @override
  List<Object?> get props => [
        name,
        officialName,
        languages,
        region,
        flag,
        capital,
        population,
      ];
} 