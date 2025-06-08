import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/country_bloc.dart';

class CountryFilters extends StatefulWidget {
  const CountryFilters({super.key});

  @override
  State<CountryFilters> createState() => _CountryFiltersState();
}

class _CountryFiltersState extends State<CountryFilters> {
  String? _currentName;
  String? _currentLanguage;
  String? _currentRegion;

  void _applyFilters() {
    context.read<CountryBloc>().add(
          ApplyFiltersEvent(
            name: _currentName,
            language: _currentLanguage,
            region: _currentRegion,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryBloc, CountryState>(
      builder: (context, state) {
        if (state is! CountryLoaded) {
          return const SizedBox.shrink();
        }

        // Update local state if it's different from bloc state
        if (state.currentName != _currentName) {
          _currentName = state.currentName;
        }
        if (state.currentLanguage != _currentLanguage) {
          _currentLanguage = state.currentLanguage;
        }
        if (state.currentRegion != _currentRegion) {
          _currentRegion = state.currentRegion;
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Buscar por nombre',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  _currentName = value;
                  _applyFilters();
                },
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  _buildLanguageFilter(context, state),
                  const SizedBox(width: 8),
                  _buildRegionFilter(context, state),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _currentName = null;
                        _currentLanguage = null;
                        _currentRegion = null;
                      });
                      context.read<CountryBloc>().add(GetAllCountriesEvent());
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Limpiar filtros'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageFilter(BuildContext context, CountryLoaded state) {
    return DropdownButton<String>(
      value: _currentLanguage,
      hint: const Text('Filtrar por idioma'),
      items: [
        const DropdownMenuItem(
          value: '',
          child: Text('Todos los idiomas'),
        ),
        ...state.availableLanguages.map(
          (language) => DropdownMenuItem(
            value: language,
            child: Text(language),
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _currentLanguage = value == '' ? null : value;
        });
        _applyFilters();
      },
    );
  }

  Widget _buildRegionFilter(BuildContext context, CountryLoaded state) {
    return DropdownButton<String>(
      value: _currentRegion,
      hint: const Text('Filtrar por región'),
      items: [
        const DropdownMenuItem(
          value: '',
          child: Text('Todas las regiones'),
        ),
        ...state.availableRegions.map(
          (region) => DropdownMenuItem(
            value: region,
            child: Text(region),
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _currentRegion = value == '' ? null : value;
        });
        _applyFilters();
      },
    );
  }
} 