abstract class WebSocketState {}

class WebSocketInitial extends WebSocketState {}

class WebSocketConnected extends WebSocketState {}

class WebSocketDisconnected extends WebSocketState {}

class WebSocketMessageReceived extends WebSocketState {}

class WebSocketMessageSent extends WebSocketState {
  final String message;
  WebSocketMessageSent(this.message);
}

class WebSocketError extends WebSocketState {
  final String error;
  WebSocketError(this.error);
}

class WebSocketHandshakeSuccess extends WebSocketState {
  final String message;
  WebSocketHandshakeSuccess(this.message);
}

class WebSocketProgressState extends WebSocketState {
  final int progress;
  WebSocketProgressState(this.progress);
}
