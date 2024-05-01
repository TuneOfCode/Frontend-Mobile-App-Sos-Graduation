import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/services/injection_container_service.dart';
import 'package:sos_app/core/sockets/socket.dart';
import 'package:sos_app/core/sockets/webrtc.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/authentication/domain/params/create_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/login_user.params.dart';
import 'package:sos_app/src/authentication/domain/params/update_user_params.dart';
import 'package:sos_app/src/authentication/domain/usecases/create_user.dart';
import 'package:sos_app/src/authentication/domain/usecases/get_profile.dart';
import 'package:sos_app/src/authentication/domain/usecases/get_users.dart';
import 'package:sos_app/src/authentication/domain/usecases/login_user.dart';
import 'package:sos_app/src/authentication/domain/usecases/update_user.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_event.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final CreateUser _createUser;
  final GetUsers _getUsers;
  final LoginUser _loginUser;
  final GetProfile _getProfile;
  final UpdateUser _updateUser;
  final AuthenticationLocalDataSource _authenticationLocalDataSource;

  AuthenticationBloc({
    required CreateUser createUser,
    required GetUsers getUsers,
    required LoginUser loginUser,
    required GetProfile getProfile,
    required UpdateUser updateUser,
  })  : _createUser = createUser,
        _getUsers = getUsers,
        _loginUser = loginUser,
        _getProfile = getProfile,
        _updateUser = updateUser,
        _authenticationLocalDataSource = sl(),
        super(const AuthenticationInitial()) {
    on<CreateUserEvent>(_createUserHandler);
    on<GetUsersEvent>(_getUsersHandler);
    on<LoginUserEvent>(_loginUserHandler);
    on<GetProfileEvent>(_getProfileHandler);
    on<UpdateUserEvent>(_updateUserHandler);
    on<LogoutUserEvent>(_logoutUserHandler);
  }

  Future<void> _createUserHandler(
    CreateUserEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const CreatingUser());

    final result = await _createUser.call(
      CreateUserParams(
        firstName: event.params.firstName,
        lastName: event.params.lastName,
        email: event.params.email,
        contactPhone: event.params.contactPhone,
        password: event.params.password,
        confirmPassword: event.params.confirmPassword,
      ),
    );

    result.fold(
      (failure) => emit(CreateUserError(failure.errorMessageLog, failure.data)),
      (_) => emit(const UserCreated()),
    );
  }

  Future<void> _getUsersHandler(
    GetUsersEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const GettingUsers());

    final result = await _getUsers();

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessageLog)),
      (users) => emit(UsersLoaded(users)),
    );
  }

  FutureOr<void> _loginUserHandler(
      LoginUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const LoggingUser());

    final result = await _loginUser.call(LoginUserParams(
      email: event.params.email,
      password: event.params.password,
    ));

    result.fold(
      (failure) =>
          emit(LoggingUserError(failure.errorMessageLog, failure.data)),
      (auth) => emit(UserLogged(auth)),
    );
  }

  FutureOr<void> _getProfileHandler(
      GetProfileEvent event, Emitter<AuthenticationState> emit) async {
    emit(const GettingProfile());

    final result = await _getProfile();

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessageLog)),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  FutureOr<void> _updateUserHandler(
      UpdateUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const UpdatingUser());

    final result = await _updateUser.call(
      UpdateUserParams(
        userId: event.params.userId,
        firstName: event.params.firstName,
        lastName: event.params.lastName,
        contactPhone: event.params.contactPhone,
        avatar: event.params.avatar,
      ),
    );

    result.fold(
      (failure) {
        logger.e('[UPDATE USER] Failure Data: ${failure.data}');
        emit(UpdateUserError(failure.errorMessageLog, failure.data));
      },
      (_) => emit(const UserUpdated()),
    );
  }

  FutureOr<void> _logoutUserHandler(
      LogoutUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const LoggingUserOut());
    final accessToken =
        await sl<AuthenticationLocalDataSource>().getAccessToken();
    await Socket.logout(accessToken);
    await WebRTCsHub.instance.hubConnection!.invoke('Disconnect');
    await _authenticationLocalDataSource.clearCache();
    emit(const UserLoggedOut());
  }
}
