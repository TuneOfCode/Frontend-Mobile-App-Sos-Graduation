import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/params/update_location_params.dart';
import 'package:sos_app/src/authentication/domain/repositories/authentication_repository.dart';

class UpdateLocation extends UsecaseWithParams<void, UpdateLocationParams> {
  final AuthenticationRepository _repository;

  const UpdateLocation(this._repository);

  @override
  ResultFuture<void> call(UpdateLocationParams params) async =>
      _repository.updateLocation(
        UpdateLocationParams(
          userId: params.userId,
          longitude: params.longitude,
          latitude: params.latitude,
        ),
      );
}
