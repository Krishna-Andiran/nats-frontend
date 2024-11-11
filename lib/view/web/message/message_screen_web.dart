import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/web_socket/web_socket_bloc.dart';
import 'package:frontend/bloc/web_socket/web_socket_event.dart';
import 'package:frontend/bloc/web_socket/web_socket_state.dart';

class MessageScreenWeb extends StatefulWidget {
  const MessageScreenWeb({super.key});

  @override
  State<MessageScreenWeb> createState() => _MessageScreenWebState();
}

class _MessageScreenWebState extends State<MessageScreenWeb> {
  int progress = 0;
  @override
  void initState() {
    context.read<WebSocketBloc>().add(WebSocketConnectEvent());
    context.read<WebSocketBloc>().add(WebSocketSendMessageEvent());
    super.initState();
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
                return const Column(
                  children: [],
                );
              },
            ),
          ),
        ),
        if (progress < 90)
          Column(
            children: [
              const Align(
                  alignment: Alignment(0, 0),
                  child: CircularProgressIndicator()),
              Text("$progress")
            ],
          )
      ],
    );
  }
}
