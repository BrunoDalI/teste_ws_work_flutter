import 'package:json_annotation/json_annotation.dart';
import 'car_model.dart';

part 'cars_response_model.g.dart';

/// Response model for cars API
@JsonSerializable()
class CarsResponseModel {
  final List<CarModel> cars;

  const CarsResponseModel({required this.cars});

  /// Creates a CarsResponseModel from JSON map
  factory CarsResponseModel.fromJson(Map<String, dynamic> json) => _$CarsResponseModelFromJson(json);

  /// Converts CarsResponseModel to JSON map
  Map<String, dynamic> toJson() => _$CarsResponseModelToJson(this);
}