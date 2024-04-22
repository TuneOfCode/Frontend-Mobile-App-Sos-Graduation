import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/router/app_router.dart';
import 'package:sos_app/core/services/injection_container_service.dart';
import 'package:sos_app/src/authentication/data/datasources/authentication_local_storage.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';

String? accessToken = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await authenticationInstance();
  accessToken = await sl<AuthenticationLocalStorage>().getAccessToken();
  if (accessToken != null) {
    // sl<AuthenticationBloc>().add(const AuthenticationEvent.getProfile());
  }
  logger.f('accessToken: $accessToken');
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
      ],
      child: MaterialApp(
        initialRoute: // AppRouter.authentication,
            accessToken == null ? AppRouter.authentication : AppRouter.home,
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
