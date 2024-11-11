abstract class WebSocketEvent {}

class WebSocketConnectEvent extends WebSocketEvent {}

class WebSocketDisconnectEvent extends WebSocketEvent {}

class WebSocketSendMessageEvent extends WebSocketEvent {

}

class WebSocketHandshakeEvent extends WebSocketEvent {}

class WebSocketProgressEvent extends WebSocketEvent {
  final int progress;

  WebSocketProgressEvent(this.progress);
}
