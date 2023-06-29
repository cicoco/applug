// @author: tafiagu
// @email: tafiagu@gmail.com
// @date: 2023-06-02 14:02:20

import 'dart:async';
import 'dart:convert';

import 'package:applug/common/values/ids.dart';
import 'package:applug/model/command_ack_msg.dart';
import 'package:applug/model/command_send_msg.dart';
import 'package:applug/utils/unic_log.dart';
import 'package:fijkplayer_new/fijkplayer_new.dart';
import 'package:get/get.dart';
import 'package:memory_cache/memory_cache.dart';
import 'package:r_get_ip/r_get_ip.dart';

import 'my_client.dart';

class MainController extends GetxController {
  final URL = "ws://jingwei-test.wesine.com.cn:8075/api/ws?AppUserToken=Plain%20372@guxiang";
  final PREVIEW_URL = "udp://127.0.0.1:5000";

  final String PING = " ";

  final productKey = '49KaPBUogOO7';
  final deviceCode = 'WSCPCG100000001';

  final websocket = MyClient();

  Timer? _heartbeatTimer;

  String state = "初始化中";

  String ipAddress = "获取中";

  // String playState = "空闲";

  double lastAngle = 0;
  double lastDistance = 0;

  bool switchState = false;
  FijkState playState = FijkState.idle;
  bool _hasPrepared = true;

  bool switchEnable = true;

  // 0空闲，1启动
  int piState = 0;

  final FijkPlayer player = FijkPlayer();

  // onStart 组件在内存分配的时间点就会被调用，这是一个final方法，并使用了内部的callable类型，以避免被子类覆盖。
  // 这里面会调用onInit方方法
  // onDelete：也是一个 final 方法，类型和 onStart 一样，同样不能被覆盖。在 controller被销毁前调用。
  // 这里面会调用onClose方法

  // 组件在内存分配后会被马上调用，可以在这个方法对 controller 做一些初始化工作
  @override
  void onInit() {
    super.onInit();
    getIPAddress();

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

    player.addListener(_fijkValueListener);

    websocket.onMessage.listen((message) {
      // 处理 WebSocket 消息
      if (PING == message) {
        return;
      }
      UnicLog.i("Receive Msg:${message}");
      // I/flutter (13899): │ 💡 Receive Msg:{"type":"commandSend","data":{"request":{"topic":"ws/WSCPCG100000001/v1/49KaPBUogOO7/command/start","payload":"{\"mid\":\"c707a34db27affaa4ed66094cbbbe9c6\",\"sn\":\"$SYS\",\"ts\":1687959407244,\"identifier\":\"start\",\"data\":{\"ip\":\"192.168.2.5\"}}"},"async":true,"requestId":"c707a34db27affaa4ed66094cbbbe9c6"}}
      // I/flutter (13899): │ 💡 Receive Msg:{"type":"commandAck","data":"{\"mid\": \"60ae17af-a222-48d0-8763-ef56359541cb\", \"rid\": \"c707a34db27affaa4ed66094cbbbe9c6\", \"ts\": 1687959407343, \"sn\": \"WSCPCG100000001\", \"data\": {\"code\": 0}}"}

      Map<String, dynamic> msg = jsonDecode(message);
      String type = msg['type'];

      if (type == 'commandSend') {
        CommandSendMsg sendMsg = CommandSendMsg.fromJson(msg);
        dynamic request = sendMsg.data.request;
        String topic = request['topic'];

        String? cacheValue;
        if (topic.endsWith("start")) {
          cacheValue = "start";
        } else if (topic.endsWith("stop")) {
          cacheValue = "stop";
        }
        if (null != cacheValue) {
          MemoryCache.instance.create(
            sendMsg.data.requestId,
            cacheValue,
            expiry: const Duration(seconds: 15),
          );
        }
      } else if (type == 'commandAck') {
        CommandAckMsg ackMsg = CommandAckMsg.fromJson(msg);

        num code = ackMsg.data.data['code'];

        String? _ackVal = MemoryCache.instance.read(ackMsg.data.rid);
        if (null != _ackVal && (_ackVal == 'start' || _ackVal == 'stop')) {
          switchEnable = true;

          if (code == 0) {
            if (_ackVal == 'start') {
              piState = 1;
            } else if (_ackVal == 'stop') {
              piState = 0;
            }
            update([AppIds.main_content_view]);
          }
        }
      }
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

  void getIPAddress() async {
    // 外网IP
    // String? ip = await RGetIp.externalIP;
    // 内网IP
    String? ip = await RGetIp.internalIP;
    ipAddress = ip ?? "获取失败";
    UnicLog.i("ipAddress:$ipAddress");
    update([AppIds.main_content_view]);
  }

  void switchButton(bool val) {
    switchState = val;
    if (switchState) {
      startPlay();
    } else {
      stopPlay();
    }
    update([AppIds.main_content_view]);
  }

  /**
   *  prepared 表示 prepareAsync 后台任务是否执行完成，完成后播放器状态也对应转变为 prepared
      completed 表示播放器是否播放完成，
      audioRenderStart 表示音频是否开始播放，播放第一帧音频是从 false 变为 true，reset() 之后变为 false
      videoRenderStart 表示视频是否开始播放，播放第一帧视频是从 false 变为 true，reset() 之后变为 false
      state 播放器当前状态
      size 视频分辨率大小
      duration 媒体内容长度，对于直播内容，duration 值无效
      fullScreen 播放器是否应该全屏显示，这个属性随着接口 enterFullScreen \ exitFullScreen 的调用而发生变化。
      exception 播放器进入 error 状态的具体原因。 在错误和异常一节中查看更多内容。
   */
  void _fijkValueListener() {
    FijkValue value = player.value;
    if (playState != value.state) {
      playState = value.state;

      if (_hasPrepared && playState == FijkState.asyncPreparing) {
        websocket.send(json.encode(assemblePlayState(ipAddress, true)));
        _hasPrepared = false;
        switchEnable = false;
      }
      if (!_hasPrepared && playState == FijkState.idle) {
        _hasPrepared = true;
      }

      update([AppIds.main_content_view]);
    }
  }

  String getPlayState() {
    switch (playState) {
      case FijkState.idle:
        if (piState == 0) {
          return "空闲";
        } else if (piState == 1) {
          return "等待空闲";
        } else {
          return "空闲未知";
        }
      case FijkState.initialized:
        return "初始化中";
      case FijkState.asyncPreparing:
        return "流等待";
      case FijkState.prepared:
        return "准备完成";
      case FijkState.started:
        return "播放中";
      case FijkState.paused:
        return "暂停";
      case FijkState.completed:
        return "已完成";
      case FijkState.stopped:
        return "已停止";
      case FijkState.error:
        return "错误，请重启";
      case FijkState.end:
        return "已结束";
      default:
        return "未知";
    }
  }

  void startPlay() async {
    await player.setOption(FijkOption.hostCategory, "request-screen-on", 1);
    await player.setOption(FijkOption.hostCategory, "request-audio-focus", 1);
    await player.setDataSource(PREVIEW_URL, autoPlay: true).catchError((e) {
      UnicLog.w("setDataSource error: $e");
    });

    // await player.prepareAsync();
    // await player.start();
  }

  void stopPlay() async {
    await player.stop();
    await player.reset();

    // 发送指令停止ffmpeg
    websocket.send(json.encode(assemblePlayState(ipAddress, false)));
    switchEnable = false;
  }

  // 在 onInit 一帧后被调用，适合做一些导航进入的事件，
  // 例如对话框提示、SnackBar 或异步网络请求
  @override
  void onReady() {
    super.onReady();
    _heartbeatTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      websocket.send(PING);
    });
  }

  Map<String, dynamic> assemblePlayState(String ip, bool start) {
    if (start) {
      return {
        'type': 10000001,
        'content': {
          'productKey': productKey,
          'deviceCode': deviceCode,
          'command': {
            'identifier': 'start',
            'inputs': {'ip': ip}
          }
        }
      };
    } else {
      return {
        'type': 10000001,
        'content': {
          'productKey': productKey,
          'deviceCode': deviceCode,
          'command': {'identifier': 'stop'}
        }
      };
    }
  }

  // 在 onDelete 方法前调用、用于销毁 controller 使用的资源，
  // 例如关闭事件监听，关闭流对象，或者销毁可能造成内存泄露的对象
  @override
  void onClose() {
    stopPlay();
    player.removeListener(_fijkValueListener);
    player.release();
    _heartbeatTimer?.cancel();
    websocket.disconnect();
    super.onClose();
  }
}
