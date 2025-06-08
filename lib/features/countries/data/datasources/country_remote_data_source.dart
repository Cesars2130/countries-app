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
  final String fields = 'fields=name,flags,capital,languages,region,population';

  CountryRemoteDataSourceImpl({required this.dio}) {
    dio.options = BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  @override
  Future<List<CountryModel>> getAllCountries() async {
    try {
      final response = await dio.get('/all?$fields');
      print('API Response: ${response.data}'); // Para debugging
      
      if (response.data is! List) {
        throw Exception('Invalid response format: expected a list');
      }

      return (response.data as List).map((country) {
        try {
          return CountryModel.fromJson(country);
        } catch (e) {
          print('Error parsing country: $country');
          print('Error details: $e');
          rethrow;
        }
      }).toList();
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to load countries: $e');
    }
  }

  @override
  Future<List<CountryModel>> getCountriesByName(String name) async {
    try {
      final response = await dio.get('/name/$name?$fields');
      return (response.data as List)
          .map((country) => CountryModel.fromJson(country))
          .toList();
    } catch (e) {
      throw Exception('Failed to load countries by name: $e');
    }
  }

  @override
  Future<List<CountryModel>> getCountriesByLanguage(String language) async {
    try {
      final response = await dio.get('/lang/$language?$fields');
      return (response.data as List)
          .map((country) => CountryModel.fromJson(country))
          .toList();
    } catch (e) {
      throw Exception('Failed to load countries by language: $e');
    }
  }

  @override
  Future<List<CountryModel>> getCountriesByRegion(String region) async {
    try {
      final response = await dio.get('/region/$region?$fields');
      return (response.data as List)
          .map((country) => CountryModel.fromJson(country))
          .toList();
    } catch (e) {
      throw Exception('Failed to load countries by region: $e');
    }
  }
} 