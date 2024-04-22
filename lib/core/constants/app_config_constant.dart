// ignore_for_file: constant_identifier_names

import 'package:sos_app/core/models/error_model.dart';

class AppConfig {
  const AppConfig._();

//static in App Strings
  static const APP_NAME = "Sos App";
  static const GENERAL_ERROR_MSG = "Có lỗi xảy ra!";
  static const UNAUTHORIZED_ERROR_MSG = "Bạn chưa đăng nhập!";
  static const FORBIDEN_ERROR_MSG = "Bạn không được phép truy cập!";
  static const BAD_REQUEST_ERROR_MSG = "Yêu cầu không hợp lệ!";
  static const NOT_FOUND_ERROR_MSG = "Không tìm thấy!";

  static String getErrorFirst(List<ErrorModel> errors, String prefixCode) {
    prefixCode = prefixCode.trim().toLowerCase();
    List<ErrorModel> errorModels = [];
    for (var error in errors) {
      String codeFormat = error.code.trim().toLowerCase();
      if (codeFormat.contains(prefixCode)) {
        errorModels.add(ErrorModel(code: prefixCode, message: error.message));
      }
    }

    return errorModels.isEmpty ? '' : errorModels.first.message;
  }
}
