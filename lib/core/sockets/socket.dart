// ignore_for_file: null_check_always_fails, use_build_context_synchronously

import 'dart:convert';

import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/utils/app_notify.dart';

class Socket {
  HubConnection? hubConnection;

  Socket._();
  static final instance = Socket._();

  Future<void> init(String? accessToken) async {
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

    hubConnection = HubConnectionBuilder()
        .withUrl(serverUrl, options: httpConnectionOptions)
        .withAutomaticReconnect()
        .build();

    if (hubConnection != null &&
        hubConnection!.state == HubConnectionState.Connected) {
      // get the stream of messages from the hub
      hubConnection!.on('ReceiveNotification', (message) async {
        // logger.f('DataNotification: $message}');
        var data = await jsonDecode(message![0].toString());

        AppNotify.showNotification(
          title: data['Title'],
          body: data['Message'],
          icon: '${ApiConfig.BASE_IMAGE_URL}${data['Avatar']}',
        );
      });

      return;
    }

    try {
      await hubConnection!.start();
      // logger.i('BaseSocketUrl: ${hubConnection!.baseUrl}');
      // logger.i('id: ${hubConnection!.connectionId}');

      // get the stream of messages from the hub
      hubConnection!.on('ReceiveNotification', (message) async {
        // logger.f('DataNotification: $message}');
        var data = await jsonDecode(message![0].toString());

        AppNotify.showNotification(
          title: data['Title'],
          body: data['Content'],
          icon: '${ApiConfig.BASE_IMAGE_URL}${data['ThumbnailUrl']}',
        );
      });
    } catch (e) {
      logger.e('Error: ${e.toString()}');
      await hubConnection!.stop();
    }
  }

  Future<void> logout() async {
    if (hubConnection!.state == HubConnectionState.Connected) {
      // emit the logout event
      hubConnection!.invoke('Logout');
    }
  }
}
