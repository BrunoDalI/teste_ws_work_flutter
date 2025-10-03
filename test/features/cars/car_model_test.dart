import 'package:flutter_test/flutter_test.dart';
import 'package:teste_ws_work_flutter/features/cars/data/models/car_model.dart';

void main() {
  group('CarModel valor heuristic parsing', () {
    CarModel build(Map<String, dynamic> json) => CarModel.fromJson(json);

    test('parses 50.000 (string) as 50000', () {
      final model = build({
        'id': 1,
        'timestamp_cadastro': 0,
        'modelo_id': 1,
        'ano': 2020,
        'combustivel': 'Flex',
        'num_portas': 4,
        'cor': 'Preto',
        'nome_modelo': 'Teste',
        'valor': '50.000',
      });
      expect(model.valor, 50000);
    });

    test('parses 47.500 (string) as 47500', () {
      final model = build({
        'id': 1,
        'timestamp_cadastro': 0,
        'modelo_id': 1,
        'ano': 2020,
        'combustivel': 'Flex',
        'num_portas': 4,
        'cor': 'Preto',
        'nome_modelo': 'Teste',
        'valor': '47.500',
      });
      expect(model.valor, 47500);
    });

    test('parses numeric 50.000 as 50000 using heuristic', () {
      final model = build({
        'id': 1,
        'timestamp_cadastro': 0,
        'modelo_id': 1,
        'ano': 2020,
        'combustivel': 'Flex',
        'num_portas': 4,
        'cor': 'Preto',
        'nome_modelo': 'Teste',
        'valor': 50.000, // JSON numeric literal becomes 50.0 in Dart
      });
      expect(model.valor, 50000);
    });

    test('does not upscale legitimate small value 50.5', () {
      final modelHalf = build({
        'id': 1,
        'timestamp_cadastro': 0,
        'modelo_id': 1,
        'ano': 2020,
        'combustivel': 'Flex',
        'num_portas': 4,
        'cor': 'Preto',
        'nome_modelo': 'Teste',
        'valor': 47.5,
      });
      expect(modelHalf.valor, 47500);
    });
  });
}
