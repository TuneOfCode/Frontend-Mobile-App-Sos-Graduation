import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sos_app/core/services/injection_container_service.dart';
import 'package:sos_app/core/sockets/socket.dart';
import 'package:sos_app/core/sockets/webrtc.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/authentication/domain/params/change_password_params.dart';
import 'package:sos_app/src/authentication/domain/params/create_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/login_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/resend_verify_code_params.dart';
import 'package:sos_app/src/authentication/domain/params/update_location_params.dart';
import 'package:sos_app/src/authentication/domain/params/update_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/verify_user_params.dart';
import 'package:sos_app/src/authentication/domain/usecases/change_password.dart';
import 'package:sos_app/src/authentication/domain/usecases/create_user.dart';
import 'package:sos_app/src/authentication/domain/usecases/get_profile.dart';
import 'package:sos_app/src/authentication/domain/usecases/get_users.dart';
import 'package:sos_app/src/authentication/domain/usecases/login_user.dart';
import 'package:sos_app/src/authentication/domain/usecases/resend_verify_code.dart';
import 'package:sos_app/src/authentication/domain/usecases/update_location.dart';
import 'package:sos_app/src/authentication/domain/usecases/update_user.dart';
import 'package:sos_app/src/authentication/domain/usecases/verify_user.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_event.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_state.dart';
import 'package:sos_app/src/friendship/data/datasources/local/friendship_local_datasource.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final CreateUser _createUser;
  final GetUsers _getUsers;
  final LoginUser _loginUser;
  final VerifyUser _verifyUser;
  final ResendVerifyCode _resendVerifyCode;
  final GetProfile _getProfile;
  final UpdateUser _updateUser;
  final ChangePassword _changePassword;
  final UpdateLocation _updateLocation;

  AuthenticationBloc({
    required CreateUser createUser,
    required GetUsers getUsers,
    required LoginUser loginUser,
    required VerifyUser verifyUser,
    required ResendVerifyCode resendVerifyCode,
    required GetProfile getProfile,
    required UpdateUser updateUser,
    required ChangePassword changePassword,
    required UpdateLocation updateLocation,
  })  : _createUser = createUser,
        _getUsers = getUsers,
        _loginUser = loginUser,
        _verifyUser = verifyUser,
        _resendVerifyCode = resendVerifyCode,
        _getProfile = getProfile,
        _updateUser = updateUser,
        _changePassword = changePassword,
        _updateLocation = updateLocation,
        super(const AuthenticationInitial()) {
    on<CreateUserEvent>(_createUserHandler);
    on<GetUsersEvent>(_getUsersHandler);
    on<LoginUserEvent>(_loginUserHandler);
    on<VerifyUserEvent>(_verifyUserHandler);
    on<ResendVerifyCodeEvent>(_resendVerifyCodeHandler);
    on<GetProfileEvent>(_getProfileHandler);
    on<UpdateUserEvent>(_updateUserHandler);
    on<ChangePasswordEvent>(_changePasswordHandler);
    on<UpdateLocationEvent>(_updateLocationHandler);
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

  FutureOr<void> _verifyUserHandler(
      VerifyUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const VerifingUser());

    final result = await _verifyUser.call(VerifyUserParams(
      email: event.params.email,
      code: event.params.code,
    ));

    result.fold(
      (failure) => emit(VerifyUserError(failure.errorMessageLog, failure.data)),
      (_) => emit(const UserVerified()),
    );
  }

  FutureOr<void> _resendVerifyCodeHandler(
      ResendVerifyCodeEvent event, Emitter<AuthenticationState> emit) async {
    emit(const ResendingVerifyCode());

    final result = await _resendVerifyCode.call(ResendVerifyCodeParams(
      email: event.params.email,
    ));

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessageLog)),
      (data) => emit(const VerifyCodeResent()),
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
      (failure) => emit(UpdateUserError(failure.errorMessageLog, failure.data)),
      (_) => emit(const UserUpdated()),
    );
  }

  FutureOr<void> _changePasswordHandler(
      ChangePasswordEvent event, Emitter<AuthenticationState> emit) async {
    emit(const ChangingPassword());

    final result = await _changePassword.call(
      ChangePasswordParams(
        userId: event.params.userId,
        currentPassword: event.params.currentPassword,
        password: event.params.password,
        confirmPassword: event.params.confirmPassword,
      ),
    );

    result.fold(
      (failure) =>
          emit(ChangePasswordError(failure.errorMessageLog, failure.data)),
      (_) => emit(const PasswordChanged()),
    );
  }

  FutureOr<void> _updateLocationHandler(
      UpdateLocationEvent event, Emitter<AuthenticationState> emit) async {
    emit(const UpdatingLocation());

    final result = await _updateLocation.call(
      UpdateLocationParams(
        userId: event.params.userId,
        longitude: event.params.longitude,
        latitude: event.params.latitude,
      ),
    );

    result.fold(
      (failure) =>
          emit(UpdateLocationError(failure.errorMessageLog, failure.data)),
      (_) => emit(const LocationUpdated()),
    );
  }

  FutureOr<void> _logoutUserHandler(
      LogoutUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const LoggingUserOut());
    await Socket.instance.logout();
    await WebRTCsHub.instance.hubConnection!.invoke('Disconnect');
    await sl<AuthenticationLocalDataSource>().clearCache();
    await sl<FriendshipLocalDataSource>().clearFriendships();
    emit(const UserLoggedOut());
  }
}
