// @author: tafiagu
// @email: tafiagu@gmail.com
// @date: 2023-06-29 10:38:59
import 'package:applug/model/socket_msg.dart';

import 'command_send.dart';

class CommandSendMsg extends SocketMsg {
  late CommandSend data;

  CommandSendMsg.fromJson(dynamic json) {
    type = json['type'];
    data = CommandSend.fromJson(json['data']);
  }
}
