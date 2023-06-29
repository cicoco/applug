// @author: tafiagu
// @email: tafiagu@gmail.com
// @date: 2023-06-29 11:03:14
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'command_send.g.dart';

@JsonSerializable()
class CommandSend {
  // I/flutter (13899): │ 💡 Receive Msg:{"type":"commandSend","data":
  // {"request":{"topic":"ws/WSCPCG100000001/v1/49KaPBUogOO7/command/start",
  // "payload":"{\"mid\":\"c707a34db27affaa4ed66094cbbbe9c6\",\"sn\":\"$SYS\",\"ts\":1687959407244,\"identifier\":\"start\",\"data\":{\"ip\":\"192.168.2.5\"}}"},
  // "async":true,"requestId":"c707a34db27affaa4ed66094cbbbe9c6"}}

  bool? async;

  late String requestId;

  late dynamic request;

  CommandSend(this.async, this.requestId, this.request);

  factory CommandSend.fromJson(Map<String, dynamic> json) => _$CommandSendFromJson(json);

  Map<String, dynamic> toJson() => _$CommandSendToJson(this);

  String toJsonStr() {
    return jsonEncode(toJson());
  }
}
