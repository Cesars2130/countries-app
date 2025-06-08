import 'package:dio/dio.dart';
import '../models/country_model.dart';

abstract class CountryRemoteDataSource {
  Future<List<CountryModel>> getAllCountries();
  Future<List<CountryModel>> getCountriesByName(String name);
  Future<List<CountryModel>> getCountriesByLanguage(String language);
  Future<List<CountryModel>> getCountriesByRegion(String region);
}

class CountryRemoteDataSourceImpl implements CountryRemoteDataSource {
  final Dio dio;
  final String baseUrl = 'https://restcountries.com/v3.1';

  CountryRemoteDataSourceImpl({required this.dio}) {
    dio.options = BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        return status! < 500;
      },
    );
  }

  @override
  Future<List<CountryModel>> getAllCountries() async {
    try {
      final response = await dio.get('/all');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((country) => CountryModel.fromJson(country))
            .toList();
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load countries: $e');
    }
  }

  @override
  Future<List<CountryModel>> getCountriesByName(String name) async {
    try {
      final response = await dio.get('/name/$name');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((country) => CountryModel.fromJson(country))
            .toList();
      } else {
        throw Exception('Failed to load countries by name: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load countries by name: $e');
    }
  }

  @override
  Future<List<CountryModel>> getCountriesByLanguage(String language) async {
    try {
      final response = await dio.get('/lang/$language');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((country) => CountryModel.fromJson(country))
            .toList();
      } else {
        throw Exception('Failed to load countries by language: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load countries by language: $e');
    }
  }

  @override
  Future<List<CountryModel>> getCountriesByRegion(String region) async {
    try {
      final response = await dio.get('/region/$region');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((country) => CountryModel.fromJson(country))
            .toList();
      } else {
        throw Exception('Failed to load countries by region: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load countries by region: $e');
    }
  }
} 