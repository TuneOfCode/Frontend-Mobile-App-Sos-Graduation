import 'dart:convert';

import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/entities/user.dart';
import 'package:sos_app/src/authentication/domain/params/create_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/login_user.params.dart';
import 'package:sos_app/src/authentication/domain/params/update_user_params.dart';

class UserModel extends User {
  const UserModel({
    required super.userId,
    required super.fullName,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.contactPhone,
    required super.avatarUrl,
    required super.verifiedAt,
    required super.createdAt,
  });

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel.fromMap(DataMap data)
      : this(
          userId: data['userId'].toString(),
          fullName: data['fullName'].toString(),
          firstName: data['firstName'].toString(),
          lastName: data['lastName'].toString(),
          email: data['email'].toString(),
          contactPhone: data['contactPhoneNumber'].toString(),
          avatarUrl: data['avatar'].toString(),
          verifiedAt: data['verifiedOnUtc'].toString(),
          createdAt: data['createdOnUtc'].toString(),
        );

  static DataMap toCreateUser(CreateUserParams params) => {
        'firstName': params.firstName,
        'lastName': params.lastName,
        'email': params.email,
        'contactPhone': params.contactPhone,
        'password': params.password,
        'confirmPassword': params.confirmPassword,
      };

  static dynamic toUpdateUser(UpdateUserParams params) {
    DataMap dataMap = {
      'userId': params.userId,
      'lastName': params.lastName,
      'firstName': params.firstName,
      'contactPhone': params.contactPhone,
      'avatar': params.avatar,
    };

    // if (params.avatar != null) {
    //   File file = File(params.avatar!.path);
    //   if (kIsWeb) {
    //     dataMap['avatar'] =
    //         await http.MultipartFile.fromPath('file', file.path);
    //   } else if (Platform.isAndroid || Platform.isIOS) {
    //     dataMap['avatar'] = await MultipartFile.fromFile(file.path);
    //   }
    // }

    return dataMap;
  }

  static DataMap toLoginUser(LoginUserParams params) => {
        'email': params.email,
        'password': params.password,
      };

  DataMap toMap() => {
        'userId': userId,
        'fullName': fullName,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'contactPhoneNumber': contactPhone,
        'avatar': avatarUrl,
        'verifiedOnUtc': verifiedAt,
        'createdOnUtc': createdAt,
      };

  String toJson() => jsonEncode(toMap());
}
