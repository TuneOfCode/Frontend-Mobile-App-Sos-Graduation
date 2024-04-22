import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/errors/failure.dart';
import 'package:sos_app/core/models/error_model.dart';

class ApiResponseFailure extends Failure {
  final String errMessage;
  final dynamic errData;

  ApiResponseFailure({required this.errMessage, this.errData});

  @override
  String get message => errMessage;

  @override
  dynamic get data {
    logger.e('[API RESPONSE FAILURE] errors: $errData');
    List<ErrorModel> errors = List<dynamic>.from(errData.data['errors'])
        .map((item) => ErrorModel.fromMap(item))
        .toList();
    return errors;
  }
}
