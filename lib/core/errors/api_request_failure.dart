import 'package:dio/dio.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/errors/failure.dart';
import 'package:sos_app/core/models/error_model.dart';

class ApiRequestFailure extends Failure {
  final Response response;

  ApiRequestFailure(this.response);

  @override
  String get message {
    return _extractErrorMessage();
  }

  int? get code {
    try {
      final c = response.statusCode;
      return c;
    } catch (e) {
      logger.e('Error extracting code from response: ${response.data}');
      return 500;
    }
  }

  String _extractErrorMessage() {
    dynamic msg;
    if (response.data is Map) {
      msg = response.data['message'] ?? "";
    } else {
      msg = 'Internal server error, please try again later.';
    }

    return msg;
  }

  @override
  get data {
    List<ErrorModel> errors = List<dynamic>.from(response.data['errors'])
        .map((item) => ErrorModel.fromMap(item))
        .toList();
    // logger.e('[API REQUEST FAILURE] errors: $errors');
    return errors;
  }
}
