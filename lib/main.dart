import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app/app_url.dart';
import 'package:frontend/bloc/web_socket/web_socket_bloc.dart';
import 'package:frontend/controller/web_socket_controller.dart';
import 'package:frontend/service/background_service.dart';
import 'package:frontend/view/nats/nats.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  BackgroundService? _backgroundService;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _backgroundService = BackgroundService();
    WidgetsBinding.instance.addObserver(this);
    _logger.i("Background service initialized");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _logger.i("App disposed");
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _backgroundService!.appInactive();
      _logger.i("App is inactive");
    } else if (state == AppLifecycleState.resumed) {
      _backgroundService!.appActive();
      _logger.i("App is resumed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WebSocketBloc(
          WebSocketService(url: "ws://${AppUrl.webSocket}"), context),
      child: MaterialApp(
        title: 'Responsive Login',
        theme: ThemeData(primarySwatch: Colors.blue),
        home:  PublishMessageScreen(),
      ),
    );
  }
}


