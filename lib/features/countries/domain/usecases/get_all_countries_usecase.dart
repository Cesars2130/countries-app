import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/country_entity.dart';
import '../repositories/country_repository.dart';

class GetAllCountriesUseCase {
  final CountryRepository repository;

  GetAllCountriesUseCase(this.repository);

  Future<Either<Failure, List<CountryEntity>>> call() async {
    return await repository.getAllCountries();
  }
} 