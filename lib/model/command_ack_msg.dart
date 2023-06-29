// @author: tafiagu
// @email: tafiagu@gmail.com
// @date: 2023-06-29 11:11:43

import 'dart:convert';

import 'package:applug/model/socket_msg.dart';

import 'command_ack.dart';

class CommandAckMsg extends SocketMsg {
  late CommandAck data;

  CommandAckMsg.fromJson(dynamic json) {
    type = json['type'];
    data = CommandAck.fromJson(jsonDecode(json['data']));
  }
}
