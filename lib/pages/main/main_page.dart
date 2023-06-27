// @author: tafiagu
// @email: tafiagu@gmail.com
// @date: 2023-06-02 14:01:30

import 'dart:math' as math;
import 'dart:math';

import 'package:applug/common/values/ids.dart';
import 'package:applug/pages/main/joy_stick.dart';
import 'package:applug/utils/image_utils.dart';
import 'package:applug/utils/unic_log.dart';
import 'package:fijkplayer_new/fijkplayer_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
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
                    cover: AssetImage(ImageUtils.wrap("avatar.jpeg")),
                    fsFit: FijkFit.ar16_9,
                  ),
                  // 操控杆区域
                  Text(
                    "本机IP: ${controller.ipAddress}",
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        controller.state,
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      SizedBox(width: 10.w, height: 1.h),
                      FlutterSwitch(
                          height: 26.h,
                          showOnOff: true,
                          value: controller.switchState,
                          onToggle: (val) {
                            controller.switchButton(val);
                          }),
                      SizedBox(width: 10.w, height: 1.h),
                      Text(
                        controller.playState,
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ],
                  ),
                  SizedBox(width: 1.sw, height: 10.h),
                  Joystick(
                    onChange: (offset) {
                      var _joystickAngle = math.atan2(offset.dy, offset.dx);
                      // 计算摇杆的位移
                      final double dx = offset.dx / Joystick.radius;
                      final double dy = offset.dy / Joystick.radius;
                      var _joystickDistance = math.sqrt(dx * dx + dy * dy);

                      UnicLog.i("_joystickAngle:${_joystickAngle * 180 / pi}, _joystickDistance:$_joystickDistance");
                      // TODO
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
