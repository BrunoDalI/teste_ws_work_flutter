import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

/// Car entity representing a car in the domain layer
class Car extends Equatable {
  final int id;
  final int timestampCadastro;
  final int modeloId;
  final int ano;
  final String combustivel;
  final int numPortas;
  final String cor;
  final String nomeModelo;
  final double valor;

  const Car({
    required this.id,
    required this.timestampCadastro,
    required this.modeloId,
    required this.ano,
    required this.combustivel,
    required this.numPortas,
    required this.cor,
    required this.nomeModelo,
    required this.valor,
  });

  @override
  List<Object> get props => [
    id,
    timestampCadastro,
    modeloId,
    ano,
    combustivel,
    numPortas,
    cor,
    nomeModelo,
    valor,
  ];

  /// Returns formatted value as currency string
  String get formattedValue {
    double display = valor;
    if (display < 1000) {
      final fractional = display - display.truncate();
      final isInteger = fractional == 0;
      final isHalf = (fractional - 0.5).abs() < 0.0000001;
      if (isInteger || isHalf) {
        display *= 1000;
      }
    }
    return 'R\$ ${NumberFormat("#,##0.00", "pt_BR").format(display)}';
  }



  /// Returns formatted year string
  String get yearString => ano.toString();

  /// Returns formatted fuel type
  String get fuelTypeFormatted => combustivel.toLowerCase();

  /// Returns formatted door count
  String get doorsFormatted => '$numPortas portas';

  /// Returns formatted color
  String get colorFormatted => cor.toLowerCase();
}