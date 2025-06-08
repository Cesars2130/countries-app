import 'package:flutter/material.dart';
import '../../domain/entities/country_entity.dart';

class CountryCard extends StatelessWidget {
  final CountryEntity country;

  const CountryCard({
    super.key,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: Image.network(
              country.flag,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  heightFactor: 4,
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  country.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  country.officialName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.location_on, 'Region: ${country.region}'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.people, 'Population: ${country.population}'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.language, 'Languages: ${country.languages.join(", ")}'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.location_city, 'Capital: ${country.capital}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
} 