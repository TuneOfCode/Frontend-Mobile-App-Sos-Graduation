import 'package:sos_app/core/utils/typedef.dart';

abstract class Usecase<Type> {
  const Usecase();
  ResultFuture<Type> call();
}

abstract class UsecaseWithParams<Type, Params> {
  const UsecaseWithParams();
  ResultFuture<Type> call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  const StreamUseCase();
  Stream<Type> call(Params params);
}
