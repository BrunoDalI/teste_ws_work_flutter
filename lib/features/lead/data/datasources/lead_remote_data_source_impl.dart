// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/lead_model.dart';
import 'lead_remote_data_source.dart';

/// Implementation of [LeadRemoteDataSource] using Dio HTTP client
class LeadRemoteDataSourceImpl implements LeadRemoteDataSource {
  final Dio client;
  
  static const String leadsEndpoint = 'https://www.wswork.com.br/cars/leads';

  LeadRemoteDataSourceImpl({required this.client});

  @override
  Future<void> sendLead(LeadModel lead) async {
    Exception? lastException;
    

    try {
      final data = lead.toJson();
      print('Tentando enviar lead para: $leadsEndpoint');
      print('Lead data: $data');
      
      final response = await client.post(
        leadsEndpoint,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          followRedirects: true,
          maxRedirects: 5,
          validateStatus: (status) => status! < 400, // Aceita até 399
        ),
      );
      
      print('✅ Sucesso! Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      return; // Sucesso, sai da função
      
    } on DioException catch (e) {
      print('❌ Erro com $leadsEndpoint: ${e.type} - ${e.message}');
      print('Response: ${e.response?.statusCode} - ${e.response?.data}');
      lastException = ServerException(_handleDioError(e, leadsEndpoint));
    
    } catch (e) {
      print('❌ Erro inesperado com $leadsEndpoint: $e');
      lastException = ServerException('Unexpected error occurred: $e');
    }


    throw lastException;
  }

  @override
  Future<void> sendLeads(List<LeadModel> leads) async {
    Exception? lastException;
    
    try {
      // Tenta primeiro enviar individualmente
      print('Tentando enviar ${leads.length} leads individualmente para: $leadsEndpoint');
      
      for (int i = 0; i < leads.length; i++) {
        final lead = leads[i];
        final data = lead.toJson();
        print('Enviando lead ${i + 1}/${leads.length}: ${lead.userName}');
        
        final response = await client.post(
          leadsEndpoint,
          data: data,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            followRedirects: true,
            maxRedirects: 5,
            validateStatus: (status) => status! < 400,
          ),
        );
        
        print('✅ Lead ${i + 1} enviado! Status: ${response.statusCode}');
      }
      
      print('✅ Todos os ${leads.length} leads enviados com sucesso!');
      return; // Sucesso, sai da função
      
    } on DioException catch (e) {
      print('❌ Erro com $leadsEndpoint: ${e.type} - ${e.message}');
      print('Response: ${e.response?.statusCode} - ${e.response?.data}');
      lastException = ServerException(_handleDioError(e, leadsEndpoint));
      
    } catch (e) {
      print('❌ Erro inesperado com $leadsEndpoint: $e');
      lastException = ServerException('Unexpected error occurred: $e');
    }

    throw lastException;
  }

  String _handleDioError(DioException e, String attemptedUrl) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout para $attemptedUrl';
      case DioExceptionType.sendTimeout:
        return 'Send timeout para $attemptedUrl';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout para $attemptedUrl';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;
        if (statusCode == 301) {
          final location = e.response?.headers['location']?.first;
          return 'URL redirecionada (301): $attemptedUrl → ${location ?? 'desconhecido'}';
        }
        return 'Server error $statusCode em $attemptedUrl${responseData != null ? ' - $responseData' : ''}';
      case DioExceptionType.cancel:
        return 'Request cancelado para $attemptedUrl';
      case DioExceptionType.connectionError:
        return 'Connection error para $attemptedUrl: ${e.message}';
      case DioExceptionType.unknown:
        return 'Unknown error para $attemptedUrl: ${e.message}';
      default:
        return 'Erro em $attemptedUrl: ${e.message}';
    }
  }
}