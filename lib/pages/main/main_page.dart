// @author: tafiagu
// @email: tafiagu@gmail.com
// @date: 2023-06-02 14:01:30

import 'package:applug/common/values/ids.dart';
import 'package:applug/pages/main/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('mainTitle'.tr),
        ),
        body: Container(
          child: _ContentView(),
        ));
  }
}

class _ContentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
        id: AppIds.main_content_view,
        builder: (controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextButton(
                    "W",
                    onTapDown: () {
                      controller.goForward();
                    },
                    onTapUp: () {
                      controller.stop();
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextButton(
                    "A",
                    onTapDown: () {
                      controller.toLeft();
                    },
                    onTapUp: () {
                      controller.stop();
                    },
                  ),
                  SizedBox(width: 80),
                  _buildTextButton(
                    "D",
                    onTapDown: () {
                      controller.toRight();
                    },
                    onTapUp: () {
                      controller.stop();
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextButton(
                    "S",
                    onTapDown: () {
                      controller.goBack();
                    },
                    onTapUp: () {
                      controller.stop();
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}

Widget _buildTextButton(String text, {VoidCallback? onTapDown, VoidCallback? onTapUp}) {
  return Material(
    color: Colors.transparent,
    child: InkResponse(
      onTapDown: (_) {
        if (onTapDown != null) onTapDown();
      },
      onTapUp: (_) {
        if (onTapUp != null) onTapUp();
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          style: TextStyle(fontSize: 50),
        ),
      ),
      highlightShape: BoxShape.rectangle,
      highlightColor: Colors.red.withOpacity(0.5),
      radius: 10,
    ),
  );
}
