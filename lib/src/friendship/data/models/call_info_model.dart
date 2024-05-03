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
    callerFullName = json['callerFullName'];
    callerAvatar = json['callerAvatar'];
    receiverId = json['receiverId'];
    receiverFullName = json['receiverFullName'];
    receiverAvatar = json['receiverAvatar'];
    isCaller = json['isCaller'];
  }

  DataMap toJson() {
    final DataMap data = {};
    data['callerId'] = callerId;
    data['callerFullName'] = callerFullName;
    data['callerAvatar'] = callerAvatar;
    data['receiverId'] = receiverId;
    data['receiverFullName'] = receiverFullName;
    data['receiverAvatar'] = receiverAvatar;
    data['isCaller'] = isCaller;
    return data;
  }
}
