// @author: tafiagu
// @email: tafiagu@gmail.com
// @date: 2023-06-02 15:41:40
import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

class MyClient {
  late WebSocketChannel _channel;
  Timer? _reconnectTimer;
  late String _url;
  StreamController<String> _messageController = StreamController<String>.broadcast();

  Stream<String> get onMessage => _messageController.stream;

  Future<void> connect(String url) async {
    _url = url;
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel.stream.listen(
        (data) {
          _messageController.sink.add(data);
        },
        onDone: () {
          _channel.sink.close();
          // _reconnect();
        },
        onError: (error) {
          _channel.sink.close();
          _reconnect();
        },
      );
    } catch (e) {
      _reconnect();
    }
  }

  void send(String message) {
    if (_channel != null) {
      _channel.sink.add(message);
    }
  }

  void disconnect() {
    _channel.sink.close();
    _messageController.close();
    _reconnectTimer?.cancel();
  }

  void _reconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: 5), () {
      if (_channel == null) {
        connect(_url);
      }
    });
  }
}
