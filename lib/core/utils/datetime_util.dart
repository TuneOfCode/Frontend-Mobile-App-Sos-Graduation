// ignore_for_file: depend_on_referenced_packages

import 'package:intl/intl.dart';

class DatimeUtil {
  const DatimeUtil._();

  static String formatDateTime(
      {required String dateTimeStr, String format = 'dd/MM/yyyy HH:mm:ss'}) {
    return DateFormat(format).format(DateTime.parse(dateTimeStr));
  }
}
