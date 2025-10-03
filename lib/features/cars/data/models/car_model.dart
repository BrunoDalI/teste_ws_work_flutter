import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/car.dart';

part 'car_model.g.dart';

/// Data model for Car entity
@JsonSerializable()
class CarModel extends Car {
  const CarModel({
    required super.id,
    required super.timestampCadastro,
    required super.modeloId,
    required super.ano,
    required super.combustivel,
    required super.numPortas,
    required super.cor,
    required super.nomeModelo,
    required super.valor,
  });

  /// Creates a CarModel from JSON map
  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: _parseIntSafely(json['id']) ?? 0,
      timestampCadastro: _parseIntSafely(json['timestamp_cadastro']) ?? 0,
      modeloId: _parseIntSafely(json['modelo_id']) ?? 0,
      ano: _parseIntSafely(json['ano']) ?? 0,
      combustivel: json['combustivel']?.toString() ?? '',
      numPortas: _parseIntSafely(json['num_portas']) ?? 0,
      cor: json['cor']?.toString() ?? '',
      nomeModelo: json['nome_modelo']?.toString() ?? '',
      valor: _parseDoubleSafely(json['valor']) ?? 0.0,
    );
  }

  /// Helper method to safely parse integers
  static int? _parseIntSafely(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Helper method to safely parse doubles
  static double? _parseDoubleSafely(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Converts CarModel to JSON map (for API)
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp_cadastro': timestampCadastro,
    'modelo_id': modeloId,
    'ano': ano,
    'combustivel': combustivel,
    'num_portas': numPortas,
    'cor': cor,
    'nome_modelo': nomeModelo,
    'valor': valor,
  };

  /// Converts CarModel to Map for SQLite (for cache)
  Map<String, dynamic> toMap() => {
    'id': id,
    'timestampCadastro': timestampCadastro,
    'modeloId': modeloId,
    'ano': ano,
    'combustivel': combustivel,
    'numPortas': numPortas,
    'cor': cor,
    'nomeModelo': nomeModelo,
    'valor': valor,
  };

  /// Creates CarModel from SQLite Map
  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'] as int? ?? 0,
      timestampCadastro: map['timestampCadastro'] as int? ?? 0,
      modeloId: map['modeloId'] as int? ?? 0,
      ano: map['ano'] as int? ?? 0,
      combustivel: map['combustivel'] as String? ?? '',
      numPortas: map['numPortas'] as int? ?? 0,
      cor: map['cor'] as String? ?? '',
      nomeModelo: map['nomeModelo'] as String? ?? '',
      valor: (map['valor'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Creates a CarModel from Car entity
  factory CarModel.fromEntity(Car car) {
    return CarModel(
      id: car.id,
      timestampCadastro: car.timestampCadastro,
      modeloId: car.modeloId,
      ano: car.ano,
      combustivel: car.combustivel,
      numPortas: car.numPortas,
      cor: car.cor,
      nomeModelo: car.nomeModelo,
      valor: car.valor,
    );
  }

  /// Converts CarModel to Car entity
  Car toEntity() {
    return Car(
      id: id,
      timestampCadastro: timestampCadastro,
      modeloId: modeloId,
      ano: ano,
      combustivel: combustivel,
      numPortas: numPortas,
      cor: cor,
      nomeModelo: nomeModelo,
      valor: valor,
    );
  }
}