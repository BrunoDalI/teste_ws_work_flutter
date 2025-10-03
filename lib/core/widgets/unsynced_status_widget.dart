import 'package:flutter/material.dart';

class UnsyncedStatus extends StatelessWidget {
  const UnsyncedStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sync_problem, size: 16, color: Colors.orange[800]),
            const SizedBox(width: 4),
            Text(
              'Não sincronizado',
              style: TextStyle(
                color: Colors.orange[800],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
