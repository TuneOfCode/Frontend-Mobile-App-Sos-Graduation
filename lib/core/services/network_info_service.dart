import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfoService {
  Future<bool> get isConnected;
}

class NetworkInfoServiceImpl implements NetworkInfoService {
  final InternetConnection connectionChecker;

  NetworkInfoServiceImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasInternetAccess;
}
