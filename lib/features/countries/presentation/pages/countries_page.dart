import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/country_bloc.dart';
import '../widgets/country_card.dart';
import '../widgets/country_filters.dart';

class CountriesPage extends StatelessWidget {
  const CountriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Países del Mundo'),
      ),
      body: BlocBuilder<CountryBloc, CountryState>(
        builder: (context, state) {
          if (state is CountryInitial) {
            context.read<CountryBloc>().add(GetAllCountriesEvent());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CountryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CountryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CountryBloc>().add(GetAllCountriesEvent());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is CountryLoaded) {
            return Column(
              children: [
                const CountryFilters(),
                Expanded(
                  child: state.countries.isEmpty
                      ? const Center(
                          child: Text('No se encontraron países'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: state.countries.length,
                          itemBuilder: (context, index) {
                            final country = state.countries[index];
                            return CountryCard(country: country);
                          },
                        ),
                ),
              ],
            );
          }

          return const Center(
            child: Text('Estado no manejado'),
          );
        },
      ),
    );
  }
} 