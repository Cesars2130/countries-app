import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/country_entity.dart';

abstract class CountryRepository {
  Future<Either<Failure, List<CountryEntity>>> getAllCountries();
  Future<Either<Failure, List<CountryEntity>>> getCountriesByName(String name);
  Future<Either<Failure, List<CountryEntity>>> getCountriesByLanguage(String language);
  Future<Either<Failure, List<CountryEntity>>> getCountriesByRegion(String region);
} 