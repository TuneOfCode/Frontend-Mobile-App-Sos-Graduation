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

  factory UserModel.fromJson(DataMap json) => UserModel(
        userId: json['userId'].toString(),
        fullName: json['fullName'].toString(),
        firstName: json['firstName'].toString(),
        lastName: json['lastName'].toString(),
        email: json['email'].toString(),
        contactPhone: json['contactPhoneNumber'].toString(),
        avatarUrl: json['avatar'].toString(),
        verifiedAt: json['verifiedOnUtc'].toString(),
        createdAt: json['createdOnUtc'].toString(),
      );

  DataMap toJson() => {
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
  static Future<UserModel> empty() {
    return Future.value(const UserModel(
      userId: '',
      fullName: '',
      firstName: '',
      lastName: '',
      email: '',
      contactPhone: '',
      avatarUrl: '',
      verifiedAt: '',
      createdAt: '',
    ));
  }

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

  // DataMap toMap() => {
  //       'userId': userId,
  //       'fullName': fullName,
  //       'firstName': firstName,
  //       'lastName': lastName,
  //       'email': email,
  //       'contactPhoneNumber': contactPhone,
  //       'avatar': avatarUrl,
  //       'verifiedOnUtc': verifiedAt,
  //       'createdOnUtc': createdAt,
  //     };
}

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => jsonEncode(data.toJson());
