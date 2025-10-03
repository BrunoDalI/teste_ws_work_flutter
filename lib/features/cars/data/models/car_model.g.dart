

// ignore_for_file: unused_element

part of 'car_model.dart';


CarModel _$CarModelFromJson(Map<String, dynamic> json) => CarModel(
  id: (json['id'] as num).toInt(),
  timestampCadastro: (json['timestampCadastro'] as num).toInt(),
  modeloId: (json['modeloId'] as num).toInt(),
  ano: (json['ano'] as num).toInt(),
  combustivel: json['combustivel'] as String,
  numPortas: (json['numPortas'] as num).toInt(),
  cor: json['cor'] as String,
  nomeModelo: json['nomeModelo'] as String,
  valor: (json['valor'] as num).toDouble(),
);

Map<String, dynamic> _$CarModelToJson(CarModel instance) => <String, dynamic>{
  'id': instance.id,
  'timestampCadastro': instance.timestampCadastro,
  'modeloId': instance.modeloId,
  'ano': instance.ano,
  'combustivel': instance.combustivel,
  'numPortas': instance.numPortas,
  'cor': instance.cor,
  'nomeModelo': instance.nomeModelo,
  'valor': instance.valor,
};
