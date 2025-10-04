import 'package:flutter_test/flutter_test.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/entities/lead.dart';

void main() {
  test('formattedCarValue aplica heurística para valores aparentando milhar abreviado', () {
    final lead = Lead(
      id: 1,
      carId: 1,
      userName: 'User',
      userEmail: 'user@test.com',
      userPhone: '123',
      createdAt: DateTime(2024,1,1),
      carModel: 'Model',
      carValue: 50, // < 1000 será interpretado como milhar (50 -> 50.000)
    );
    final formatted = lead.formattedCarValue; // R$ 50.000,00 esperado em pt_BR
    expect(formatted.contains('50.000'), true);
  });
}

// Resumo (teste Lead entidade):
// Garante que a lógica heurística de multiplicar valores inteiros/semifrações <1000
// para representar milhar funciona e reflete no formato final.
