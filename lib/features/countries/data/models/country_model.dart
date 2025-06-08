import '../../domain/entities/country_entity.dart';

class CountryModel extends CountryEntity {
  const CountryModel({
    required String name,
    required String officialName,
    required List<String> languages,
    required String region,
    required String flag,
    required String capital,
    required int population,
  }) : super(
          name: name,
          officialName: officialName,
          languages: languages,
          region: region,
          flag: flag,
          capital: capital,
          population: population,
        );

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name']['common'],
      officialName: json['name']['official'],
      languages: json['languages'] != null
          ? List<String>.from(json['languages'].values)
          : [],
      region: json['region'],
      flag: json['flags']['png'],
      capital: json['capital']?.first ?? '',
      population: json['population'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {
        'common': name,
        'official': officialName,
      },
      'languages': languages,
      'region': region,
      'flags': {
        'png': flag,
      },
      'capital': [capital],
      'population': population,
    };
  }
} 