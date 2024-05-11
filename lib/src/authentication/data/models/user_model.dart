// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/entities/user.dart';
import 'package:sos_app/src/authentication/domain/params/change_password_params.dart';
import 'package:sos_app/src/authentication/domain/params/create_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/login_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/update_location_params.dart';
import 'package:sos_app/src/authentication/domain/params/update_user_params.dart';

class UserModel extends User {
  UserModel({
    required super.userId,
    required super.fullName,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.contactPhone,
    required super.avatarUrl,
    required super.longitude,
    required super.latitude,
    required super.verifiedAt,
    required super.createdAt,
  });

  factory UserModel.fromJson(DataMap json) => UserModel(
        userId: json['userId'].toString(),
        fullName: json['fullName'].toString(),
        firstName: json['firstName'].toString(),
        lastName: json['lastName'].toString(),
        email: json['email'].toString(),
        contactPhone: json['contactPhone'].toString(),
        avatarUrl: json['avatar'].toString(),
        longitude: double.parse(json['longitude'].toString()),
        latitude: double.parse(json['latitude'].toString()),
        verifiedAt: json['verifiedAt'].toString(),
        createdAt: json['createdAt'].toString(),
      );

  DataMap toJson() => {
        'userId': userId,
        'fullName': fullName,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'contactPhone': contactPhone,
        'avatar': avatarUrl,
        'longitude': longitude,
        'latitude': latitude,
        'verifiedAt': verifiedAt,
        'createdAt': createdAt,
      };
  static UserModel constructor() {
    return UserModel(
      userId: '',
      fullName: '',
      firstName: '',
      lastName: '',
      email: '',
      contactPhone: '',
      avatarUrl: '',
      longitude: 107.5778275,
      latitude: 16.4634687,
      verifiedAt: '',
      createdAt: '',
    );
  }

  static Future<UserModel> empty() {
    return Future.value(UserModel(
      userId: '',
      fullName: '',
      firstName: '',
      lastName: '',
      email: '',
      contactPhone: '',
      avatarUrl: '',
      longitude: 107.5778275,
      latitude: 16.4634687,
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

    return dataMap;
  }

  static DataMap toLoginUser(LoginUserParams params) => {
        'email': params.email,
        'password': params.password,
      };

  static DataMap toChangePassword(ChangePasswordParams params) => {
        'currentPassword': params.currentPassword,
        'password': params.password,
        'confirmPassword': params.confirmPassword,
      };

  static DataMap toUpdateLocation(UpdateLocationParams params) => {
        'longitude': params.longitude,
        'latitude': params.latitude,
      };
}

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => jsonEncode(data.toJson());
