import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/repositories/country_repository.dart';
import '../datasources/country_remote_data_source.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CountryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CountryEntity>>> getAllCountries() async {
    if (await networkInfo.isConnected) {
      try {
        final countries = await remoteDataSource.getAllCountries();
        return Right(countries);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<CountryEntity>>> getCountriesByName(String name) async {
    if (await networkInfo.isConnected) {
      try {
        final countries = await remoteDataSource.getCountriesByName(name);
        return Right(countries);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<CountryEntity>>> getCountriesByLanguage(String language) async {
    if (await networkInfo.isConnected) {
      try {
        final countries = await remoteDataSource.getCountriesByLanguage(language);
        return Right(countries);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<CountryEntity>>> getCountriesByRegion(String region) async {
    if (await networkInfo.isConnected) {
      try {
        final countries = await remoteDataSource.getCountriesByRegion(region);
        return Right(countries);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
} 