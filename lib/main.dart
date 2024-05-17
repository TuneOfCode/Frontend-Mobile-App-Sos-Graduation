import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/router/app_router.dart';
import 'package:sos_app/core/services/injection_container_service.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_bloc.dart';
import 'package:sos_app/src/notifications/presentation/logic/notification_bloc.dart';

String? accessToken = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependencyInjection();

  accessToken = await sl<AuthenticationLocalDataSource>().getAccessToken();
  logger.f('accessToken: $accessToken');

  // if (accessToken != null) {
  //   WebRTCsHub.instance.init(accessToken!);
  // }

  // var currentUser = await sl<AuthenticationLocalStorage>().getCurrentUser();
  // logger.f('currentUser: $currentUser');
  runApp(const SosApp());
}

class SosApp extends StatelessWidget {
  const SosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthenticationBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<FriendshipRequestBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<FriendshipBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<NotificationBloc>(),
        ),
      ],
      child: MaterialApp(
        initialRoute:
            accessToken == null || (accessToken != null && accessToken!.isEmpty)
                ? AppRouter.authentication
                : AppRouter.home,
        onGenerateRoute: AppRouter.onGenerateRoute,
        title: 'Sos App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
