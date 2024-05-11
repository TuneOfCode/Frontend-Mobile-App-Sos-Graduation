import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sos_app/core/services/http_client_service.dart';
import 'package:sos_app/core/services/network_info_service.dart';
import 'package:sos_app/core/utils/app_notify.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource_impl.dart';
import 'package:sos_app/src/authentication/data/datasources/remote/authentication_remote_datasource.dart';
import 'package:sos_app/src/authentication/data/datasources/remote/authentication_remote_datasource_impl.dart';
import 'package:sos_app/src/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:sos_app/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:sos_app/src/authentication/domain/usecases/change_password.dart';
import 'package:sos_app/src/authentication/domain/usecases/create_user.dart';
import 'package:sos_app/src/authentication/domain/usecases/get_profile.dart';
import 'package:sos_app/src/authentication/domain/usecases/get_users.dart';
import 'package:sos_app/src/authentication/domain/usecases/login_user.dart';
import 'package:sos_app/src/authentication/domain/usecases/resend_verify_code.dart';
import 'package:sos_app/src/authentication/domain/usecases/update_location.dart';
import 'package:sos_app/src/authentication/domain/usecases/update_user.dart';
import 'package:sos_app/src/authentication/domain/usecases/verify_user.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';
import 'package:sos_app/src/friendship/data/datasources/local/friendship_local_datasource.dart';
import 'package:sos_app/src/friendship/data/datasources/local/friendship_local_datasource_impl.dart';
import 'package:sos_app/src/friendship/data/datasources/remote/friendship_remote_datasource.dart';
import 'package:sos_app/src/friendship/data/datasources/remote/friendship_remote_datasource_impl.dart';
import 'package:sos_app/src/friendship/data/datasources/remote/friendship_request_remote_datasource.dart';
import 'package:sos_app/src/friendship/data/datasources/remote/friendship_request_remote_datasource_impl.dart';
import 'package:sos_app/src/friendship/data/repositories/friendship_repository_impl.dart';
import 'package:sos_app/src/friendship/data/repositories/friendship_request_repository_impl.dart';
import 'package:sos_app/src/friendship/domain/repositories/friendship_repository.dart';
import 'package:sos_app/src/friendship/domain/repositories/friendship_request_repository.dart';
import 'package:sos_app/src/friendship/domain/usecases/accept_friendship_request.dart';
import 'package:sos_app/src/friendship/domain/usecases/cancel_friendship_request.dart';
import 'package:sos_app/src/friendship/domain/usecases/create_friendship_request.dart';
import 'package:sos_app/src/friendship/domain/usecases/get_friendship_recommends.dart';
import 'package:sos_app/src/friendship/domain/usecases/get_friendship_request_by_id.dart';
import 'package:sos_app/src/friendship/domain/usecases/get_friendship_requests_received_by_user.dart';
import 'package:sos_app/src/friendship/domain/usecases/get_friendship_requests_sent_by_user.dart';
import 'package:sos_app/src/friendship/domain/usecases/get_friendships.dart';
import 'package:sos_app/src/friendship/domain/usecases/reject_friendship_request.dart';
import 'package:sos_app/src/friendship/domain/usecases/remove_friendship.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_bloc.dart';

final sl = GetIt.instance;

Future<void> dependencyInjection() async {
  const secureStorage = FlutterSecureStorage();
  final getStorage = await GetStorage.init();
  final dio = Dio();
  sl

    ///***********************************************
    // !Authentication Dependencies
    // App logic
    ..registerFactory(() => AuthenticationBloc(
          createUser: sl(),
          getUsers: sl(),
          loginUser: sl(),
          verifyUser: sl(),
          resendVerifyCode: sl(),
          getProfile: sl(),
          updateUser: sl(),
          changePassword: sl(),
          updateLocation: sl(),
        ))

    // Use cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))
    ..registerLazySingleton(() => LoginUser(sl()))
    ..registerLazySingleton(() => VerifyUser(sl()))
    ..registerLazySingleton(() => ResendVerifyCode(sl()))
    ..registerLazySingleton(() => GetProfile(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton(() => ChangePassword(sl()))
    ..registerLazySingleton(() => UpdateLocation(sl()))
    // Repositories
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImpl(sl(), sl(), sl()))

    // Data sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthenticationRemoteDataSourceImpl(sl(), sl()))
    ..registerLazySingleton<AuthenticationLocalDataSource>(
        () => AuthenticationLocalDataSourceImpl(sl()))

    ///***********************************************///

    ///***********************************************
    // !FriendshipRequest Dependencies
    // App logic
    ..registerFactory(() => FriendshipRequestBloc(
          authenticationLocalDataSource: sl(),
          getFriendshipRequestById: sl(),
          getFriendshipRequestsSentByUser: sl(),
          getFriendshipRequestsReceivedByUser: sl(),
          createFriendshipRequest: sl(),
          acceptFriendshipRequest: sl(),
          rejectFriendshipRequest: sl(),
          cancelFriendshipRequest: sl(),
        ))

    // Use cases
    ..registerLazySingleton(() => GetFriendshipRequestById(sl()))
    ..registerLazySingleton(() => GetFriendshipRequestsSentByUser(sl()))
    ..registerLazySingleton(() => GetFriendshipRequestsReceivedByUser(sl()))
    ..registerLazySingleton(() => CreateFriendshipRequest(sl()))
    ..registerLazySingleton(() => AcceptFriendshipRequest(sl()))
    ..registerLazySingleton(() => RejectFriendshipRequest(sl()))
    ..registerLazySingleton(() => CancelFriendshipRequest(sl()))

    // Repositories
    ..registerLazySingleton<FriendshipRequestRepository>(
        () => FriendshipRequestRepositoryImpl(sl()))

    // Data sources
    ..registerLazySingleton<FriendshipRequestRemoteDataSource>(
        () => FriendshipRequestRemoteDataSourceImpl(sl(), sl()))

    ///***********************************************///

    ///***********************************************
    // !Friendship Dependencies
    // App logic
    ..registerFactory(() => FriendshipBloc(
          getFriendships: sl(),
          getFriendshipRecommends: sl(),
          removeFriendship: sl(),
        ))

    // Use cases
    ..registerLazySingleton(() => GetFriendships(sl()))
    ..registerLazySingleton(() => GetFriendshipRecommends(sl()))
    ..registerLazySingleton(() => RemoveFriendship(sl()))

    // Repositories
    ..registerLazySingleton<FriendshipRepository>(
        () => FriendshipRepositoryImpl(sl(), sl(), sl()))

    // Data sources
    ..registerLazySingleton<FriendshipRemoteDataSource>(
        () => FriendshipRemoteDataSourceImpl(sl(), sl(), sl()))
    ..registerLazySingleton<FriendshipLocalDataSource>(
        () => FriendshipLocalDataSourceImpl())

    ///***********************************************///

    ///***********************************************
    /// !External Dependencies
    ..registerLazySingleton<NetworkInfoService>(
        () => NetworkInfoServiceImpl(sl()))
    ..registerLazySingleton(() => secureStorage)
    ..registerLazySingleton(() => getStorage)
    ..registerLazySingleton(() => dio)
    ..registerLazySingleton(() => http.Client())
    ..registerLazySingleton(() => InternetConnection())
    ..registerLazySingleton(() => FlutterLocalNotificationsPlugin())
    ..registerLazySingleton(() => HttpClientService(sl(), sl(), sl()));

  // Notify dependencies
  await AppNotify.init();
}
