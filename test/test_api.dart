// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  
  try {
    print('Fazendo requisição para a API...');
    final response = await dio.get('https://wswork.com.br/cars.json');
    
    print('Status Code: ${response.statusCode}');
    print('Response Type: ${response.data.runtimeType}');
    print('Response Data: ${response.data}');
    
    if (response.data is Map) {
      final data = response.data as Map<String, dynamic>;
      print('Chaves disponíveis: ${data.keys}');
      
      if (data.containsKey('cars')) {
        final cars = data['cars'];
        print('Cars Type: ${cars.runtimeType}');
        print('Cars Length: ${cars.length}');
        
        if (cars is List && cars.isNotEmpty) {
          print('Primeiro carro: ${cars[0]}');
          print('Primeiro carro type: ${cars[0].runtimeType}');
          
          final firstCar = cars[0] as Map<String, dynamic>;
          print('Chaves do primeiro carro: ${firstCar.keys}');
          
          // Verificar cada campo individualmente
          for (final key in firstCar.keys) {
            final value = firstCar[key];
            print('$key: $value (${value.runtimeType})');
          }
        }
      }
    }
  } catch (e) {
    print('Erro: $e');
    print('Tipo do erro: ${e.runtimeType}');
  }
}