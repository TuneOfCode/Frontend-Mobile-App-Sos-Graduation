import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  String get message;
  dynamic get data;

  String get errorMessageLog => message;
  @override
  List<Object?> get props => [message];
}
