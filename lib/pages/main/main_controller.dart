// @author: tafiagu
// @email: tafiagu@gmail.com
// @date: 2023-06-02 14:02:20

import 'dart:async';
import 'dart:convert';

import 'package:applug/common/values/ids.dart';
import 'package:applug/utils/unic_log.dart';
import 'package:fijkplayer_new/fijkplayer_new.dart';
import 'package:get/get.dart';

import 'my_client.dart';

class MainController extends GetxController {
  final URL = "ws://jingwei-test.wesine.com.cn:8075/api/ws?AppUserToken=Plain%20372@guxiang";
  final PREVIEW_URL = "udp://127.0.0.1:5000";

  final productKey = '49KaPBUogOO7';
  final deviceCode = 'WSCPCG100000001';

  final websocket = MyClient();

  Timer? _heartbeatTimer;

  String state = "初始化中";

  final FijkPlayer player = FijkPlayer();

  // onStart 组件在内存分配的时间点就会被调用，这是一个final方法，并使用了内部的callable类型，以避免被子类覆盖。
  // 这里面会调用onInit方方法
  // onDelete：也是一个 final 方法，类型和 onStart 一样，同样不能被覆盖。在 controller被销毁前调用。
  // 这里面会调用onClose方法

  // 组件在内存分配后会被马上调用，可以在这个方法对 controller 做一些初始化工作
  @override
  void onInit() {
    super.onInit();

    // ffplay -fflags nobuffer -flags low_delay -framedrop udp://192.168.2.116:5000
    player.setOption(FijkOption.playerCategory, "fflags", "nobuffer");
    player.setOption(FijkOption.playerCategory, "flags", "low_delay");

    player.setOption(FijkOption.playerCategory, "mediacodec", 1);
    player.setOption(FijkOption.playerCategory, "mediacodec-auto-rotate", 1);
    // 允许MediaCodec在解码过程中自动适应分辨率的变化，以提高视频播放的效率和稳定性
    player.setOption(FijkOption.playerCategory, "mediacodec-handle-resolution-change", 1);

    // 音频
    player.setOption(FijkOption.playerCategory, "opensles", 0);

    // SDL_FCC_RV32
    player.setOption(FijkOption.playerCategory, "overlay-format", 842225234);
    player.setOption(FijkOption.playerCategory, "framedrop", 1);
    player.setOption(FijkOption.playerCategory, "max_cached_duration", 0);
    player.setOption(FijkOption.playerCategory, "start-on-prepared", 0);
    player.setOption(FijkOption.playerCategory, "packet-buffering", 0);

    player.setOption(FijkOption.formatCategory, "http-detect-range-support", 0);
    player.setOption(FijkOption.formatCategory, "analyzemaxduration", 100);
    player.setOption(FijkOption.formatCategory, "probesize", 10240);
    player.setOption(FijkOption.formatCategory, "flush_packets", 1);

    player.setOption(FijkOption.codecCategory, "skip_loop_filter", 48);

    startPlay();

    websocket.onMessage.listen((message) {
      // 处理 WebSocket 消息
      UnicLog.i('Received message: $message');
    });

    websocket.onConnect.listen((_) {
      UnicLog.i("连接成功");
      state = "已连接";
      update([AppIds.main_content_view]);
    }, onError: (error) {
      UnicLog.i("连接异常：$error");
      state = "连接异常";
      update([AppIds.main_content_view]);
    });
    websocket.connect(URL);
  }

  void startPlay() async {
    await player.setOption(FijkOption.hostCategory, "request-screen-on", 1);
    await player.setOption(FijkOption.hostCategory, "request-audio-focus", 1);
    await player.setDataSource(PREVIEW_URL, autoPlay: true).catchError((e) {
      UnicLog.w("setDataSource error: $e");
    });
  }

  // 在 onInit 一帧后被调用，适合做一些导航进入的事件，
  // 例如对话框提示、SnackBar 或异步网络请求
  @override
  void onReady() {
    super.onReady();
    _heartbeatTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      websocket.send(" ");
    });
  }

  void stop() {
    websocket.send(json.encode(assembleDirection('n')));
  }

  void goForward() {
    websocket.send(json.encode(assembleDirection('w')));
  }

  void goBack() {
    websocket.send(json.encode(assembleDirection('s')));
  }

  void toLeft() {
    websocket.send(json.encode(assembleDirection('a')));
  }

  void toRight() {
    websocket.send(json.encode(assembleDirection('d')));
  }

  Map<String, dynamic> assembleDirection(String direction) {
    return {
      'type': 10000001,
      'content': {
        'productKey': productKey,
        'deviceCode': deviceCode,
        'command': {
          'identifier': 'control',
          'inputs': {'cmd': direction}
        }
      }
    };
  }

  // 在 onDelete 方法前调用、用于销毁 controller 使用的资源，
  // 例如关闭事件监听，关闭流对象，或者销毁可能造成内存泄露的对象
  @override
  void onClose() {
    player.release();
    _heartbeatTimer?.cancel();
    websocket.disconnect();
    super.onClose();
  }
}
