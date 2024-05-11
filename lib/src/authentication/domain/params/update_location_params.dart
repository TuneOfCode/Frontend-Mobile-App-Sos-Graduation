import 'package:equatable/equatable.dart';

class UpdateLocationParams extends Equatable {
  final String userId;
  final double longitude;
  final double latitude;

  const UpdateLocationParams({
    required this.userId,
    required this.longitude,
    required this.latitude,
  });

  @override
  List<Object?> get props => [
        userId,
        longitude,
        latitude,
      ];
}
