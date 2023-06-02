// @author: tafiagu
// @email: tafiagu@gmail.com
// @date: 2023-06-02 14:02:20

import 'dart:convert';

import 'package:get/get.dart';

import 'my_client.dart';

class MainController extends GetxController {
  final URL = "ws://jingwei-test.wesine.com.cn:8075/api/ws?AppUserToken=Plain%20372@guxiang";
  final productKey = '49KaPBUogOO7';
  final deviceCode = 'WSCPCG100000001';

  final websocket = MyClient();

  // onStart 组件在内存分配的时间点就会被调用，这是一个final方法，并使用了内部的callable类型，以避免被子类覆盖。
  // 这里面会调用onInit方方法
  // onDelete：也是一个 final 方法，类型和 onStart 一样，同样不能被覆盖。在 controller被销毁前调用。
  // 这里面会调用onClose方法

  // 组件在内存分配后会被马上调用，可以在这个方法对 controller 做一些初始化工作
  @override
  void onInit() {
    super.onInit();
    websocket.connect(URL);
    websocket.onMessage.listen((message) {
      // 处理 WebSocket 消息
      print('Received message: $message');
    });
  }

  // 在 onInit 一帧后被调用，适合做一些导航进入的事件，
  // 例如对话框提示、SnackBar 或异步网络请求
  @override
  void onReady() {
    super.onReady();

    // channel.stream.listen((event) {
    //   print('WebSocket event: $event');
    // }, onError: (error) {
    //   print('WebSocket error: $error');
    // }, onDone: () {
    //   print('WebSocket done.');
    // });
  }

  void stop() {
    final Map<String, dynamic> forward = {
      'type': 0,
      'content': {
        'productKey': productKey,
        'deviceCode': deviceCode,
        'command': {
          'identifier': 'control',
          'inputs': {'cmd': 'n'}
        }
      }
    };
    websocket.send(json.encode(forward));
  }

  void goForward() {
    final Map<String, dynamic> forward = {
      'type': 0,
      'content': {
        'productKey': productKey,
        'deviceCode': deviceCode,
        'command': {
          'identifier': 'control',
          'inputs': {'cmd': 'w'}
        }
      }
    };
    websocket.send(json.encode(forward));
  }

  void goBack() {
    final Map<String, dynamic> forward = {
      'type': 0,
      'content': {
        'productKey': productKey,
        'deviceCode': deviceCode,
        'command': {
          'identifier': 'control',
          'inputs': {'cmd': 's'}
        }
      }
    };
    websocket.send(json.encode(forward));
  }

  void toLeft() {
    final Map<String, dynamic> forward = {
      'type': 0,
      'content': {
        'productKey': productKey,
        'deviceCode': deviceCode,
        'command': {
          'identifier': 'control',
          'inputs': {'cmd': 'a'}
        }
      }
    };
    websocket.send(json.encode(forward));
  }

  void toRight() {
    final Map<String, dynamic> forward = {
      'type': 0,
      'content': {
        'productKey': productKey,
        'deviceCode': deviceCode,
        'command': {
          'identifier': 'control',
          'inputs': {'cmd': 'd'}
        }
      }
    };
    websocket.send(json.encode(forward));
  }

  // 在 onDelete 方法前调用、用于销毁 controller 使用的资源，
  // 例如关闭事件监听，关闭流对象，或者销毁可能造成内存泄露的对象
  @override
  void onClose() {
    websocket.disconnect();
    super.onClose();
  }
}
