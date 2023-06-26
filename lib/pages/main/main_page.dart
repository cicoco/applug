// @author: tafiagu
// @email: tafiagu@gmail.com
// @date: 2023-06-02 14:01:30

import 'dart:math' as math;
import 'dart:math';

import 'package:applug/common/values/ids.dart';
import 'package:applug/pages/main/joy_stick.dart';
import 'package:applug/utils/unic_log.dart';
import 'package:fijkplayer_new/fijkplayer_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'main_controller.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: GetBuilder<MainController>(
            id: AppIds.main_content_view,
            builder: (controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 摄像头
                  FijkView(
                    width: 1.sw,
                    height: 0.5.sh,
                    player: controller.player,
                    color: Colors.transparent,
                    // panelBuilder: fijkPanel2Builder(snapShot: true),
                    fsFit: FijkFit.ar16_9,
                  ),
                  // 操控杆区域
                  Joystick(
                    onChange: (offset) {
                      var _joystickAngle = math.atan2(offset.dy, offset.dx);

                      // 计算摇杆的位移
                      final double dx = offset.dx / Joystick.radius;
                      final double dy = offset.dy / Joystick.radius;
                      var _joystickDistance = math.sqrt(dx * dx + dy * dy);

                      UnicLog.i("_joystickAngle:${_joystickAngle * 180 / pi}, _joystickDistance:$_joystickDistance");
                    },
                  ),
                ],
              );
            }));
    // body: Container(
    //   child: _ContentView(),
    // ));
  }
}
