import 'package:equatable/equatable.dart';
import 'package:sos_app/core/utils/typedef.dart';

class Auth extends Equatable {
  final String accessToken;
  final String refreshToken;

  const Auth({
    required this.accessToken,
    required this.refreshToken,
  });

  factory Auth.fromMap(DataMap data) => Auth(
        accessToken: data['accessToken'].toString(),
        refreshToken: data['refreshToken'].toString(),
      );

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
