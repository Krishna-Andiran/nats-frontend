import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/app/util.dart';
import 'package:frontend/service/db_service.dart';
import 'package:frontend/widgets/components.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  WebSocketChannel? _channel;
  Function(dynamic)? onProgressReceived;

  final id = storage.read("id");
  WebSocketService({required this.url, this.onProgressReceived});

  void connect(BuildContext context) {
    try {
      if (kIsWeb) {
        //_channel = HtmlWebSocketChannel.connect(url);
      } else {
        _channel = IOWebSocketChannel.connect(url);
      }
      _channel!.stream.listen(
        (message) {
          Components.logMessage(message);
          try {
            final data = jsonDecode(message);
            final progress = data['progress'];
            if (data['data']['active'] == true) {
              DatabaseService().storeData(data);
            }
            Components.logMessage(progress);
          } catch (e) {
            // Components.logErrMessage("Error parsing message:", e);
          }
        },
        onDone: () {
          Components.logErrMessage("WebSocket connection closed", "error");
        },
        onError: (error) {
          Components.logErrMessage("WebSocket error:", error);
        },
      );
    } catch (e) {
      Components.logErrMessage("WebSocket connection failed:", e);
    }
  }

  void sendMessage() {
    if (_channel != null) {
      String msg = jsonEncode({
        "requester": {
          "name": "admin app",
          "version": "1.0",
          "timestamp": "2024-06-17T15:33:47+0000",
          "requestedBy": "5dcb89a0-832b-44b6-b270-9a94ccc888fe"
        },
        "requestName": "read_Workgroup",
        "data": {"id": id}
      });
      _channel!.sink.add(msg);
      Components.logMessage("message check:$msg");
    }
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
