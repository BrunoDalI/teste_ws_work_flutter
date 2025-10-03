import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../domain/entities/car.dart';
import '../../../lead/domain/entities/lead.dart';

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

  // Máscara para telefone brasileiro (celular ou fixo)
  final _phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  // Permite apenas letras e espaços no nome
  final _nameMask = FilteringTextInputFormatter.allow(RegExp(r'[A-Za-zÀ-ÿ\s]'));

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: Colors.blue[100],
                child: Icon(Icons.person_add_alt_1_rounded, size: 38, color: Colors.blue[700]),
              ),
              const SizedBox(height: 14),
              Text(
                'Seus Dados',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Para ${widget.car.nomeModelo}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _ModernTextField(
                      controller: _nameController,
                      label: 'Nome completo',
                      icon: Icons.person,
                      inputFormatters: [
                        _nameMask,
                        LengthLimitingTextInputFormatter(40),
                      ],
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, informe seu nome';
                        }
                        if (!RegExp(r'^[A-Za-zÀ-ÿ\s]+$').hasMatch(value.trim())) {
                          return 'Use apenas letras';
                        }
                        if (value.trim().length < 2) {
                          return 'Nome deve ter pelo menos 2 letras';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    _ModernTextField(
                      controller: _emailController,
                      label: 'E-mail',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
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
                    const SizedBox(height: 18),
                    _ModernTextField(
                      controller: _phoneController,
                      label: 'Telefone',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        _phoneMask,
                        LengthLimitingTextInputFormatter(15),
                      ],
                      hintText: '(11) 99999-9999',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, informe seu telefone';
                        }
                        if (_phoneMask.getUnmaskedText().length < 10) {
                          return 'Telefone deve ter 10 ou 11 dígitos';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[700],
                        side: BorderSide(color: Colors.red[200]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 3,
                        shadowColor: Colors.green[100],
                      ),
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final lead = Lead(
        carId: widget.car.id,
        userName: _nameController.text.trim(),
        userEmail: _emailController.text.trim(),
        userPhone: _phoneMask.getUnmaskedText(),
        createdAt: DateTime.now(),
        carModel: widget.car.nomeModelo,
        carValue: widget.car.valor,
      );
      Navigator.of(context).pop(lead);
    }
  }
}

class _ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const _ModernTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.hintText,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 124, 168, 211)),
        filled: true,
        fillColor: Colors.blue[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.blue[300]!, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      ),
    );
  }
}