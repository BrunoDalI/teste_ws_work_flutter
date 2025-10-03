import 'package:flutter/material.dart';
import '../../domain/entities/car.dart';

/// Widget for displaying a car card
class CarCard extends StatelessWidget {
  final Car car;
  final VoidCallback onEuQueroPressed;

  const CarCard({
    super.key,
    required this.car,
    required this.onEuQueroPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    car.nomeModelo,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    car.formattedValue,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.calendar_today,
                  label: car.yearString,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.local_gas_station,
                  label: car.fuelTypeFormatted,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.door_front_door,
                  label: car.doorsFormatted,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.palette,
                  label: car.colorFormatted,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onEuQueroPressed,
                icon: const Icon(Icons.favorite, color: Colors.white),
                label: const Text(
                  'EU QUERO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal widget for displaying info chips
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.blueGrey[600],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blueGrey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}