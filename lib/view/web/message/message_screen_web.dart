import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/web_socket/web_socket_bloc.dart';
import 'package:frontend/bloc/web_socket/web_socket_event.dart';
import 'package:frontend/bloc/web_socket/web_socket_state.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/service/db_service.dart';
import 'package:frontend/widgets/components.dart';

class MessageScreenWeb extends StatefulWidget {
  const MessageScreenWeb({super.key});

  @override
  State<MessageScreenWeb> createState() => _MessageScreenWebState();
}

class _MessageScreenWebState extends State<MessageScreenWeb> {
  int progress = 0;
  final TextEditingController controller = TextEditingController();
  final DatabaseService databaseService = DatabaseService();
  AuthController authController = AuthController();
  // ignore: prefer_typing_uninitialized_variables
  var dummyData;
  @override
  void initState() {
    context.read<WebSocketBloc>().add(WebSocketConnectEvent());
    context.read<WebSocketBloc>().add(WebSocketSendMessageEvent());
    super.initState();
  }
@override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      databaseService.getDummyData().then((data) {
        setState(() {
          dummyData = data!['data'];
        });
        Components.logMessage(dummyData);
      });
    });
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    context.read<WebSocketBloc>().add(WebSocketDisconnectEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text('WebSocket Demo')),
          body: BlocListener<WebSocketBloc, WebSocketState>(
            listener: (context, state) {
              if (state is WebSocketConnected) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Connected")));
              } else if (state is WebSocketDisconnected) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Disconnected")));
              } else if (state is WebSocketProgressState) {
                setState(() {
                  progress = state.progress;
                });
              }
            },
            child: BlocBuilder<WebSocketBloc, WebSocketState>(
              builder: (context, state) {
                return Column(
                  children: [
                    TextField(
                      controller: controller,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          databaseService.storeDummyData(controller.text);
                          authController.sendData(dummyData);
                        },
                        child: const Text("submit")),
                    ElevatedButton(
                        onPressed: () {
                          if (dummyData != null) {
                            authController.sendData("Offline Data$dummyData");
                          }
                          databaseService.deleteDummyData();
                        },
                        child: const Text("offline")),
                    ElevatedButton(
                        onPressed: () {
                          authController
                              .sendData("Online Data${controller.text}");
                        },
                        child: const Text("online")),
                  ],
                );
              },
            ),
          ),
        ),
        // if (progress < 90)
        //   Column(
        //     children: [
        //       const Align(
        //           alignment: Alignment(0, 0),
        //           child: CircularProgressIndicator()),
        //       Text("$progress")
        //     ],
        //   )
      ],
    );
  }
}
