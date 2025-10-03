// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../../features/cars/data/datasources/car_local_data_source.dart';
import '../../features/cars/data/datasources/car_local_data_source_impl.dart';
import '../../features/cars/data/datasources/car_remote_data_source.dart';
import '../../features/cars/data/datasources/car_remote_data_source_impl.dart';
import '../../features/cars/data/repositories/car_repository_impl.dart';
import '../../features/lead/data/repositories/lead_repository_impl.dart';
import '../../features/cars/domain/repositories/car_repository.dart';
import '../../features/lead/domain/repositories/lead_repository.dart';
import '../../features/cars/domain/usecases/get_cars.dart';
import '../../features/lead/domain/usecases/get_leads.dart';
import '../../features/lead/domain/usecases/save_lead.dart';
import '../../features/lead/domain/usecases/get_unsent_leads.dart';
import '../../features/lead/domain/usecases/send_leads.dart';
import '../../features/lead/data/datasources/lead_remote_data_source.dart';
import '../../features/lead/data/datasources/lead_remote_data_source_impl.dart';
import '../../features/cars/presentation/bloc/car_bloc.dart';
import '../../features/lead/presentation/bloc/lead_bloc.dart';
import '../../features/lead/presentation/bloc/lead_sync_bloc.dart';
import '../sync/auto_sync_service.dart';

final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> init() async {
  //! Features - Cars
  // Bloc
  sl.registerFactory(() => CarBloc(getCars: sl()));
  sl.registerFactory(() => LeadBloc(saveLead: sl(), getLeads: sl()));
  sl.registerFactory(
    () => LeadSyncBloc(
      getUnsentLeads: sl(),
      sendLeads: sl(),
      leadRepository: sl(),
      autoSyncService: sl(),
    )
  );

  // Use cases
  sl.registerLazySingleton(() => GetCars(sl()));
  sl.registerLazySingleton(() => SaveLead(sl()));
  sl.registerLazySingleton(() => GetLeads(sl()));
  sl.registerLazySingleton(() => GetUnsentLeads(sl()));
  sl.registerLazySingleton(() => SendLeads(sl()));

  // Repository
  sl.registerLazySingleton<CarRepository>(
    () => CarRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<LeadRepository>(
    () => LeadRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Auto Sync Service (foreground)
  sl.registerLazySingleton(
    () => AutoSyncService(
      getUnsentLeads: sl(),
      sendLeads: sl(),
      leadRepository: sl(),
    )
  );

  // Data sources
  sl.registerLazySingleton<CarRemoteDataSource>(
    () => CarRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<CarLocalDataSource>(
    () => CarLocalDataSourceImpl(database: sl()),
  );

  sl.registerLazySingleton<LeadRemoteDataSource>(
    () => LeadRemoteDataSourceImpl(client: sl()),
  );

  //! Core
  // Database
  final database = await DatabaseHelper.database;
  sl.registerLazySingleton<Database>(() => database);

  // HTTP Client
  final dio = Dio();
  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    followRedirects: true,
    maxRedirects: 5,
  );
  
  // Add interceptor for logging
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    logPrint: (obj) => print(obj),
  ));
  
  sl.registerLazySingleton(() => dio);
}