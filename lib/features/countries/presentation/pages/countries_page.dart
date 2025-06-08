import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/country_bloc.dart';
import '../widgets/country_card.dart';

class CountriesPage extends StatelessWidget {
  const CountriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        centerTitle: true,
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
            return Center(child: Text(state.message));
          }
          
          if (state is CountryLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.countries.length,
              itemBuilder: (context, index) {
                final country = state.countries[index];
                return CountryCard(country: country);
              },
            );
          }
          
          return const SizedBox();
        },
      ),
    );
  }
} 