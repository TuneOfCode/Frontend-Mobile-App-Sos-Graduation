import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/params/resend_verify_code_params.dart';
import 'package:sos_app/src/authentication/domain/params/verify_user_params.dart';

class VerifyCodeModel {
  final String verifyCode;
  final String verifyCodeExpried;

  const VerifyCodeModel({
    required this.verifyCode,
    required this.verifyCodeExpried,
  });

  factory VerifyCodeModel.fromJson(DataMap json) => VerifyCodeModel(
        verifyCode: json['verifyCode'].toString(),
        verifyCodeExpried: json['verifyCodeExpried'].toString(),
      );

  static DataMap toVerifyUser(VerifyUserParams params) => {
        'email': params.email,
        'code': params.code,
      };

  static DataMap toResendVerifyCode(ResendVerifyCodeParams params) => {
        'email': params.email,
      };
}
