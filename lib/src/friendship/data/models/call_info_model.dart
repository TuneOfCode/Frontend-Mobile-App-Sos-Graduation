import 'package:sos_app/core/utils/typedef.dart';

class CallInfoModel {
  String? callerId;
  String? callerFullName;
  String? callerAvatar;
  String? receiverId;
  String? receiverFullName;
  String? receiverAvatar;
  late bool isCaller;

  CallInfoModel({
    this.callerId,
    this.callerFullName,
    this.callerAvatar,
    this.receiverId,
    this.receiverFullName,
    this.receiverAvatar,
    required this.isCaller,
  });

  CallInfoModel.fromJson(DataMap json) {
    callerId = json['callerId'];
    receiverId = json['receiverId'];
    isCaller = json['isCaller'];
  }

  DataMap toJson() {
    final DataMap data = {};
    data['callerId'] = callerId;
    data['receiverId'] = receiverId;
    data['isCaller'] = isCaller;

    return data;
  }
}
