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
    // Parse raw value (may come as 50.000 meaning 50000)
    double parsedValor = _parseDoubleSafely(json['valor']) ?? 0.0;
    // Heuristic: backend sends thousands using a dot but keeps JSON numeric (50.000 -> 50).
    // If value is unrealistically low for a car (e.g. < 1000) but originally had a dot formatting pattern,
    // scale by 1000 to recover intended thousands.
    // We attempt to detect the original string to avoid wrongly scaling legitimate low values.
    final originalValorRaw = json['valor'];
    if (parsedValor < 1000) {
      if (originalValorRaw is String && originalValorRaw.contains('.')) {
        parsedValor *= 1000; // "50.000" -> 50 * 1000 = 50000
      } else if (originalValorRaw is num) {
        final fractional = parsedValor - parsedValor.truncate();
        final isInteger = fractional == 0;
        final isHalf = (fractional - 0.5).abs() < 0.0000001; // .500 caso perdido
        if (isInteger || (isHalf && parsedValor < 100)) {
          parsedValor *= isHalf ? 1000 : 1000; // both upscale
        }
      }
    }

    return CarModel(
      id: _parseIntSafely(json['id']) ?? 0,
      timestampCadastro: _parseIntSafely(json['timestamp_cadastro']) ?? 0,
      modeloId: _parseIntSafely(json['modelo_id']) ?? 0,
      ano: _parseIntSafely(json['ano']) ?? 0,
      combustivel: json['combustivel']?.toString() ?? '',
      numPortas: _parseIntSafely(json['num_portas']) ?? 0,
      cor: json['cor']?.toString() ?? '',
      nomeModelo: json['nome_modelo']?.toString() ?? '',
      valor: parsedValor,
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
    if (value is num) return value.toDouble();
    if (value is String) {
      // Remove pontos de milhar e troca vírgula por ponto (caso venha assim)
      final sanitized = value.replaceAll('.', '').replaceAll(',', '.');
      return double.tryParse(sanitized);
    }
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