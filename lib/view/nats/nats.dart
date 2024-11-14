import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:frontend/service/db_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PublishMessageScreen extends StatefulWidget {
  const PublishMessageScreen({super.key});

  @override
  _PublishMessageScreenState createState() => _PublishMessageScreenState();
}

class _PublishMessageScreenState extends State<PublishMessageScreen> {
  final TextEditingController _controller = TextEditingController();
  WebSocketChannel? _channel;
  bool _isConnected = false;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService();
    _connectWebSocket();

    // Listen to connectivity changes and try publishing offline messages when online
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        _connectWebSocket(); // Ensure WebSocket is connected
        await _tryPublishingOfflineMessages(); // Try sending stored messages
      }
    });
  }

  // Initialize WebSocket connection
  void _connectWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.100.166:5000/ws/publish'), // Local server URL
    );
    _isConnected = true;
    print('WebSocket connected');

    // Listen to WebSocket messages
    _channel!.stream.listen(
      (message) {
        print('Server response: $message');
      },
      onDone: () {
        print('WebSocket connection closed');
        _isConnected = false;
        _reconnectWebSocket(); // Reconnect when connection is lost
      },
      onError: (error) {
        print('WebSocket error: $error');
        _isConnected = false;
        _reconnectWebSocket();
      },
    );
  }

  // Reconnect WebSocket with a delay
  void _reconnectWebSocket() async {
    await Future.delayed(const Duration(seconds: 5));
    _connectWebSocket();
  }

  // Store message in Sembast if offline
  Future<void> _storeMessageForLater(String message) async {
    await _databaseService.storeOfflineData(message);
    print('Message saved for later');
  }

  // Try publishing all offline messages when online
  Future<void> _tryPublishingOfflineMessages() async {
    final offlineMessages = await _databaseService.getAllMessages();
    for (String message in offlineMessages) {
      if (_isConnected) {
        _channel!.sink.add(message); // Attempt to publish each offline message
        print('Offline message sent: $message');
      }
    }
    await _databaseService.deleteOfflineData(); // Clear saved offline messages
  }

  // Send message via WebSocket
  void _sendMessage(String message) {
    if (_isConnected && _channel != null) {
      _channel!.sink.add(message);
      print('Message sent: $message');
    } else {
      print('WebSocket not connected, storing message for later');
      _storeMessageForLater(message);
    }
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publish Message')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter message'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool isOnline = await Connectivity().checkConnectivity() != ConnectivityResult.none;
                if (isOnline) {
                  _sendMessage(_controller.text); // Send immediately if online
                } else {
                  _storeMessageForLater(_controller.text); // Store if offline
                  print('Device is offline, message saved for later');
                }
              },
              child: const Text('Publish Message'),
            ),
          ],
        ),
      ),
    );
  }
}
