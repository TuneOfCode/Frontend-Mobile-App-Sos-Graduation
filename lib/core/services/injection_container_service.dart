import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:sos_app/core/services/http_client_service.dart';
import 'package:sos_app/src/authentication/data/datasources/authentication_local_storage.dart';
import 'package:sos_app/src/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:sos_app/src/authentication/data/datasources/authentication_remote_datasource_impl.dart';
import 'package:sos_app/src/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:sos_app/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:sos_app/src/authentication/domain/usecases/create_user.dart';
import 'package:sos_app/src/authentication/domain/usecases/get_profile.dart';
import 'package:sos_app/src/authentication/domain/usecases/get_users.dart';
import 'package:sos_app/src/authentication/domain/usecases/login_user.dart';
import 'package:sos_app/src/authentication/domain/usecases/update_user.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';

final sl = GetIt.instance;

Future<void> authenticationInstance() async {
  sl
    // App logic
    ..registerFactory(() => AuthenticationBloc(
          createUser: sl(),
          getUsers: sl(),
          loginUser: sl(),
          getProfile: sl(),
          updateUser: sl(),
        ))

    // Use cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))
    ..registerLazySingleton(() => LoginUser(sl()))
    ..registerLazySingleton(() => GetProfile(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))

    // Repositories
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImpl(sl()))

    // Data sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthenticationRemoteDataSourceImpl(sl(), sl()))
    ..registerLazySingleton(
        () => const AuthenticationLocalStorage(FlutterSecureStorage()))

    // External Dependencies
    ..registerLazySingleton(() => HttpClientService(Dio(), sl()));
}
