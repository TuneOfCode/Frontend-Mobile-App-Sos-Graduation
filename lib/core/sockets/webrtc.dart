import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';

class WebRTCsHub {
  HubConnection? hubConnection;

  WebRTCsHub._();
  static final instance = WebRTCsHub._();

  Future<void> init(String accessToken) async {
    const serverUrl = '${ApiConfig.BASE_SOCKET_URL}/webRTCs-hub';

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

    try {
      await hubConnection!.start();
      logger.i('BaseSocketUrl: ${hubConnection!.baseUrl}');

      hubConnection!.on('UserConnected', (data) {
        logger.i('UserConnected: $data');

        // callerId = dataUserConnected['UserId'];
        // logger.i('callerId: $callerId');
      });

      var dataUserConnected = await hubConnection!.invoke('Connect');

      logger.f('invoke data user connected: $dataUserConnected');
      // var jsonDataUserConnected = jsonDecode(dataUserConnected.toString());
    } catch (e) {
      logger.e('Error: ${e.toString()}');
      await hubConnection!.stop();
    }
  }
}
