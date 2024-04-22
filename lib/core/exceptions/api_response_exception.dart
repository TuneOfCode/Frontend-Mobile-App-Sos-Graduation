class ApiResponseException implements Exception {
  String exceptionMessage;
  dynamic data;

  ApiResponseException({required this.exceptionMessage, this.data});

  @override
  String toString() =>
      "Api Response Exception Message: $exceptionMessage & Data: $data";
}
