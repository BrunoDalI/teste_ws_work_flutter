import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/car.dart';
import '../../../lead/domain/entities/lead.dart';

/// Dialog for collecting user information when they want to buy a car
class UserInfoDialog extends StatefulWidget {
  final Car car;

  const UserInfoDialog({super.key, required this.car});

  @override
  State<UserInfoDialog> createState() => _UserInfoDialogState();
}

class _UserInfoDialogState extends State<UserInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Icon(
            Icons.person_add,
            size: 48,
            color: Colors.blue[600],
          ),
          const SizedBox(height: 8),
          const Text(
            'Seus Dados',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Para ${widget.car.nomeModelo}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, informe seu nome';
                  }
                  if (value.trim().length < 2) {
                    return 'Nome deve ter pelo menos 2 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, informe seu e-mail';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, informe um e-mail válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: '11999999999',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, informe seu telefone';
                  }
                  if (value.length < 10) {
                    return 'Telefone deve ter pelo menos 10 dígitos';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar', style: TextStyle(color: Colors.red),),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
          ),
          child: const Text(
            'Confirmar Interesse',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final lead = Lead(
        carId: widget.car.id,
        userName: _nameController.text.trim(),
        userEmail: _emailController.text.trim(),
        userPhone: _phoneController.text.trim(),
        createdAt: DateTime.now(),
        carModel: widget.car.nomeModelo,
        carValue: widget.car.valor,
      );

      Navigator.of(context).pop(lead);
    }
  }
}