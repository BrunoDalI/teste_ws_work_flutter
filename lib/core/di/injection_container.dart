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
import '../../features/cars/presentation/bloc/car_bloc.dart';
import '../../features/lead/presentation/bloc/lead_bloc.dart';

final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> init() async {
  //! Features - Cars
  // Bloc
  sl.registerFactory(() => CarBloc(getCars: sl()));
  sl.registerFactory(() => LeadBloc(saveLead: sl(), getLeads: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetCars(sl()));
  sl.registerLazySingleton(() => SaveLead(sl()));
  sl.registerLazySingleton(() => GetLeads(sl()));

  // Repository
  sl.registerLazySingleton<CarRepository>(
    () => CarRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<LeadRepository>(
    () => LeadRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<CarRemoteDataSource>(
    () => CarRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<CarLocalDataSource>(
    () => CarLocalDataSourceImpl(database: sl()),
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
  );
  sl.registerLazySingleton(() => dio);
}