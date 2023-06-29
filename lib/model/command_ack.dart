// @author: tafiagu
// @email: tafiagu@gmail.com
// @date: 2023-06-29 11:12:26
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'command_ack.g.dart';

@JsonSerializable()
class CommandAck {
  late String mid;

  late String rid;

  late num ts;

  late String sn;

  late dynamic data;

  CommandAck(this.mid, this.rid, this.data);

  factory CommandAck.fromJson(Map<String, dynamic> json) => _$CommandAckFromJson(json);

  Map<String, dynamic> toJson() => _$CommandAckToJson(this);

  String toJsonStr() {
    return jsonEncode(toJson());
  }
}
