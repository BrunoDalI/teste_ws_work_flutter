part of 'cars_response_model.dart';


CarsResponseModel _$CarsResponseModelFromJson(Map<String, dynamic> json) =>
  CarsResponseModel(
    cars: (json['cars'] as List<dynamic>).map((e) => 
      CarModel.fromJson(e as Map<String, dynamic>)).toList(),
  );

Map<String, dynamic> _$CarsResponseModelToJson(CarsResponseModel instance) =>
  <String, dynamic>{'cars': instance.cars};
