import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class UpdateUserParams extends Equatable {
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? contactPhone;
  final XFile? avatar;

  const UpdateUserParams({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.contactPhone,
    required this.avatar,
  });

  @override
  List<Object?> get props => [userId, firstName, lastName, contactPhone];
}
