// @author: tafiagu
// @email: tafiagu@gmail.com
// @date: 2023-06-02 15:41:40
import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

class MyClient {
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  late String _url;
  StreamController<String> _messageController = StreamController<String>.broadcast();
  StreamController<void> _connectController = StreamController<void>.broadcast();

  Stream<String> get onMessage => _messageController.stream;

  Stream<void> get onConnect => _connectController.stream;

  Future<void> connect(String url) async {
    _url = url;
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel!.stream.listen(
        (data) {
          _messageController.sink.add(data);
        },
        onDone: () {
          if(_channel != null){
            _channel!.sink.close();
            _channel = null;
          }
          _connectController.sink.addError('连接已关闭');
          _reconnect();
        },
        onError: (error) {
          if(_channel != null){
            _channel!.sink.close();
            _channel = null;
          }
          _connectController.sink.addError(error);
          _reconnect();
        },
      );
      _connectController.sink.add(null); // 发送连接成功事件
    } catch (e) {
      _channel = null;
      _reconnect();
      _connectController.sink.addError(e);
    }
  }

  void send(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    }
  }

  void disconnect() {
    if(_channel != null){
      _channel!.sink.close();
      _channel = null;
    }
    _messageController.close();
    _connectController.close();
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
