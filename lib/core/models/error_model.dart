import 'package:sos_app/core/utils/typedef.dart';

class ErrorModel {
  final String code;
  final dynamic message;

  ErrorModel({
    required this.code,
    required this.message,
  });

  factory ErrorModel.fromJson(DataMap json) {
    return ErrorModel(
      code: json['code'].toString(),
      message: json['message'].toString(),
    );
  }

  DataMap toJson() {
    return {
      'code': code,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'code: $code, message: $message';
  }
}
