import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/web_socket/web_socket_event.dart';
import 'package:frontend/bloc/web_socket/web_socket_state.dart';
import 'package:frontend/controller/web_socket_controller.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final WebSocketService webSocketService;
  BuildContext context;
  WebSocketBloc(this.webSocketService,this.context) : super(WebSocketInitial()) {
    on<WebSocketConnectEvent>((event, emit) async {
      try {
        webSocketService.connect(context);
        emit(WebSocketConnected());
      } catch (e) {
        emit(WebSocketError(e.toString()));
      }
    });

    on<WebSocketDisconnectEvent>((event, emit) async {
      webSocketService.disconnect();
      emit(WebSocketDisconnected());
    });

    on<WebSocketSendMessageEvent>((event, emit) async {
      try {
        webSocketService.sendMessage();
        emit(WebSocketMessageReceived()); 
      } catch (e) {
        emit(WebSocketError(e.toString()));
      }
    });

    on<WebSocketProgressEvent>((event, emit) {
      emit(WebSocketProgressState(event.progress));
    });
  }
}
