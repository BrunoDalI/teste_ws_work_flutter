import 'package:flutter/material.dart';

class ContactInfo extends StatelessWidget {
  final IconData icon;
  final String label;

  const ContactInfo({super.key, 
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
        ),
      ],
    );
  }
}