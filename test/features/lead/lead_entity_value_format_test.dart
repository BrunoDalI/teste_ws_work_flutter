import 'package:flutter_test/flutter_test.dart';
import 'package:teste_ws_work_flutter/features/lead/domain/entities/lead.dart';

void main() {
  group('Lead formattedCarValue heuristic', () {
    Lead build(double value) => Lead(
          carId: 1,
          userName: 'User',
          userEmail: 'u@e.com',
          userPhone: '000',
          createdAt: DateTime(2024, 1, 1),
          carModel: 'Modelo X',
          carValue: value,
        );

    test('inteiro 50 vira 50.000,00', () {
      expect(build(50).formattedCarValue, contains('50.000,00'));
    });

    test('inteiro 47 vira 47.000,00', () {
      expect(build(47).formattedCarValue, contains('47.000,00'));
    });

    test('decimal 47.5 vira 47.500,00', () {
      expect(build(47.5).formattedCarValue, contains('47.500,00'));
    });
  });
}
