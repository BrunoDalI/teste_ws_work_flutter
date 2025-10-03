import 'package:equatable/equatable.dart';

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
  String get formattedValue => 'R\$ ${valor.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

  /// Returns formatted year string
  String get yearString => ano.toString();

  /// Returns formatted fuel type
  String get fuelTypeFormatted => combustivel.toLowerCase();

  /// Returns formatted door count
  String get doorsFormatted => '$numPortas portas';

  /// Returns formatted color
  String get colorFormatted => cor.toLowerCase();
}