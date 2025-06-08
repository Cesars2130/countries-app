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
      name: json['name']['common'] ?? '',
      officialName: json['name']['official'] ?? '',
      languages: json['languages'] != null 
          ? (json['languages'] as Map<String, dynamic>).values.toList().cast<String>()
          : [],
      region: json['region'] ?? '',
      flag: json['flags']['png'] ?? '',
      capital: json['capital'] != null && (json['capital'] as List).isNotEmpty 
          ? json['capital'][0] 
          : '',
      population: json['population'] ?? 0,
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