// ignore_for_file: null_check_always_fails

import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/utils/app_notify.dart';

class Socket {
  const Socket._();

  static Future<HubConnection> init(String? accessToken) async {
    const serverUrl = '${ApiConfig.BASE_SOCKET_URL}/notifications-hub';
    final defaultHeaders = MessageHeaders();
    defaultHeaders.setHeaderValue('Connection', 'Upgrade');
    defaultHeaders.setHeaderValue('Upgrade', 'websocket');
    defaultHeaders.setHeaderValue('Sec-WebSocket-Version', '13');
    defaultHeaders.setHeaderValue('Sec-WebSocket-Extensions',
        'permessage-deflate; client_max_window_bits');
    final httpConnectionOptions = HttpConnectionOptions(
      accessTokenFactory: () => Future.value(accessToken),
      logMessageContent: true,
      headers: defaultHeaders,
    );

    final hubConnection = HubConnectionBuilder()
        .withUrl(serverUrl, options: httpConnectionOptions)
        .withAutomaticReconnect()
        .build();

    final box = GetStorage();
    if (box.read('socketId') != null ||
        hubConnection.state == HubConnectionState.Connected) {
      return hubConnection;
    }
    logger.t('SocketId: ${box.read('socketId')}');
    try {
      await hubConnection.start();
      logger.i('BaseSocketUrl: ${hubConnection.baseUrl}');
      logger.i('id: ${hubConnection.connectionId}');
      box.write('socketId', hubConnection.connectionId);
    } catch (e) {
      logger.e('Error: ${e.toString()}');
      await hubConnection.stop();
    }

    return hubConnection;
  }

  static Future<void> initNotification(String? accessToken) async {
    final hubConnection = await Socket.init(accessToken);

    // get the stream of messages from the hub
    hubConnection.on('ReceiveNotification', (message) async {
      logger.f('DataNotification: $message}');
      var data = await jsonDecode(message![0].toString());

      AppNotify.showNotification(
        title: data['Title'],
        body: data['Message'],
        icon: '${ApiConfig.BASE_IMAGE_URL}${data['SenderAvatar']}',
      );
    });
  }

  static Future<void> logout(String? accessToken) async {
    final hubConnection = await Socket.init(accessToken);

    if (hubConnection.state == HubConnectionState.Connected) {
      // emit the logout event
      hubConnection.invoke('Logout');
    }
  }
}
