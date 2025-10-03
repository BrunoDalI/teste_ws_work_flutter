import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/car_model.dart';
import '../models/cars_response_model.dart';
import 'car_remote_data_source.dart';

/// Implementation of [CarRemoteDataSource] using Dio HTTP client
class CarRemoteDataSourceImpl implements CarRemoteDataSource {
  final Dio client;
  static const String baseUrl = 'https://wswork.com.br/cars.json';

  CarRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CarModel>> getCars() async {
    try {
      final response = await client.get(baseUrl);
      
      if (response.statusCode == 200) {
        final carsResponse = CarsResponseModel.fromJson(response.data);
        return carsResponse.cars;
      } else {
        throw ServerException('Failed to load cars. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout: ${e.message}');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('Connection error: ${e.message}');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e');
    }
  }
}